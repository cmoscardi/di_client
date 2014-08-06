apt-get update
while read line
do
  apt-get install -y $line
done < "/vagrant/install_repos"

pip install virtualenv
