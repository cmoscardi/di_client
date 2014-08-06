user=vagrant

git clone https://github.com/cmoscardi/di_lesson_1.git
mv di_lesson_1 git_server.git
cd git_server.git 
rm -rf .git
pip install -r requirements.txt

chown -R $user ../git_server.git

