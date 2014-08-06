user=vagrant
mkdir lesson_1
cd lesson_1
git init
git remote add grading ../git_server
git pull grading master
chown -R $user ../lesson_1 
