apt-get update
while read line
do
  apt-get install -y $line
done < "/vagrant/install_packages"

pip install virtualenv
