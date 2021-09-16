#! /bin/bash
# bash ubuntu-install.sh 5.0.0

version=${1:-"latest"}

sudo apt-get install -y gnupg

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list

sudo apt-get -y update

if [ $version == "latest" ]
then
    version=$(apt show mongodb-org -a | grep Version | awk -F ": " '{print $2}' | sort -r | head -1)
else
    if [ -z $(apt show mongodb-org -a | grep Version | awk -F ": " '{print $2}' | grep $version) ]
    then
        echo -e "No MongoDB of version $version available!"
        echo -e "Available versions are"
        echo -e $(apt show mongodb-org -a | grep Version | awk -F ": " '{print $2}')
        exit 1
    fi
fi

echo -e "Installing MongoDB $version"

if [ -z $(id -u mongodb) ]
then
    sudo useradd mongodb
fi

if [ -z $(id -g mongodb) ]
then
    sudo groupadd mongodb
fi

sudo apt-mark unhold $(apt-mark showhold | grep mongodb-org)

sudo apt-get install -y mongodb-org=$version mongodb-org-server=$version mongodb-org-shell=$version mongodb-org-mongos=$version mongodb-org-tools=$version

echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-org-shell hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

if [[ $version == 5* ]]
then
    sudo apt-get install -y mongodb-org-database=$version
    echo "mongodb-org-database hold" | sudo dpkg --set-selections
fi

sudo getent passwd mongodb

if [ $? == 0 ]
then
    sudo mkdir -p /var/lib/mongodb /var/log/mongodb
    sudo chown mongodb /var/lib/mongodb
    sudo chown mongodb /var/log/mongodb
fi

sudo service mongod start

if [ $? == 0 ]
then
    echo -e "MongoDB is running!"
else
    echo -e "MongoDB failed to start!"
fi
