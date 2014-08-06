Data Incubator client box and mock server setup
======

Instructions for basic testing
-----
1. Clone this repository
2. Run 'vagrant up'
3. Run 'vagrant ssh'
4. cd into 'lesson\_1'
5. Modify your answer
6. Commit your code
7. git push grading master
8. You'll see the results of grading appear!


Further Documentation
-----
Here's how everything works.

1. During initialization, vagrant first installs all needed libraries. This setup is simple enough that Puppet or Chef isn't necessary (all of the provisioning is done with shell scripts here), but both integrate nicely with Vagrant and will allow for easier user-specific configuration, once users need to have individualised vagrant boxes.
2. Next, it clones a 'lesson 1' server repository, then creates a local repo based on the server information. In a full-fledged setup, we would be cloning a repository from the git server specific to that user. You can see this code in the 'setup\_git\_server' and 'setup\_git\_client' scripts. It adds a remote named 'grading'. Of course, we could also add a remote called testing which has a different set of hooks (so users can ensure their code is somewhat correct).
3. Finally, it sets up and seeds a local database. In production, this step would of course be entirely unnecessary - the grading server would take care of connecting to the database.
4. The database setup is interesting and worth its own numbered item: it has two collections, 'users' and 'answers'. The set of 'answers' is a store of test cases for each assignment and function within that assignment. 'users' stores each user's info, including their grade book.

5. Once this is all setup, the environment is ready. 

6. Upon pushing code, the 'post-commit' hook runs (you can see it in git-server.git/hooks/post-commit on the vagrant box). The first script to run is 'process\_commit.py' (in the git-server.git directory). Based on a given filename or list of filenames (which will vary based on the repository in production - here it's hardcoded as 'q0.py'), this script uses a python git wrapper to extract all of the necessary code and output it to stdout.
7. The post-commit hook now has all of the user's python code. In this prototype version, it pipes the code into another local script - grade.py (again git-server.git directory). In production, we would actually send this code to the grading server to run a grading task (possibly via Jenkins, but as discussed the VM spinup machinery is something I need to look more into)
8. The grading script first inserts the user's code (and thus function definitions) into the runtime. Then, (in production) we pull the names of each to-be-graded function from the database, based on the assignment name.Here, the function name is hardcoded for simplicity's sake. 
9. Next, a grading function is called. It pulls the test cases for a given function from the database, and runs those test cases. The grading criteria here is simple: the user's answer is simply checked against the correct answer. If it's correct, then the user gets a 'point', with each test case being worth a point.
10. Upon finishing grading, the user's score for that assignment is pushed to the gradebook, and the grading server reports the score back to the git server. The git server returns this information to the client.

Design Decision Notes
-----
Notably, I didn't include a @gradable decorator or anything similar. This simplifies setup on the client end, as they don't need a new module to process the behavior of the @gradable decorator or anything similar. Additionally, I've essentially converted question specs into a markup file - I hardcoded the spec in the database, but this sort of setup lends itself nicely to a JSON file for the specification of each lesson, each gradable function in the lesson, and test cases for that question. One possibility for building lessons would be to include @gradable decorators in the skeleton python file on the development side, and then upon building for production, create a JSON spec file for the question based on the function signature and return type.
