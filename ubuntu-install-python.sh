#！/bin/bash

sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa  --yes

sudo apt-get update
sudo apt-get install -y python3.8-full python3.8-dev

if [ ! -z $(which python) ]
then
    pythonbin=$(which python)
    sudo mv $pythonbin /usr/bin/python-
    sudo ln -s $(which python3.8) $pythonbin
else
    sudo ln -s $(which python3.8) /usr/bin/python
fi

curl -Ls https://bootstrap.pypa.io/get-pip.py | sudo python

if [ ! -z $(which pip) ]
then
    pipbin=$(which pip)
    sudo mv $pipbin /usr/local/bin/pip-
    sudo ln -s $(which pip3.8) $pipbin
else
    sudo ln -s $(which pip3.8) /usr/local/bin/pip
fi

sudo -H pip install -U pip
sudo -H pip install setuptools six
