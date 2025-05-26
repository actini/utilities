#! /bin/bash
function ensure_dependencies() {
    if [ -z $(which sudo) ]
    then
        if [ "root" == "$(whoami)" ]
        then
            echo "Installing sudo ..."
            apt-get install sudo -y > /dev/null
        else
            echo "The package 'sudo' is required, run 'apt-get install sudo' as root to install!"
            exit 1
        fi
    fi

    sudo apt-get update > /dev/null

    if [ -z $(which curl) ]
    then
        echo "Installing curl ..."
        sudo apt-get install curl -y > /dev/null
    fi
}

function cleanup_legacy_packages() {
    if [ ! -z "$(apt list --installed | grep python)" ]
    then
        echo "Removing legacy Python packages ..."
        sudo apt-get purge python* -y > /dev/null
        sudo apt-get auto-remove -y > /dev/null
    fi

    remove_file $(which python)
    remove_file /usr/bin/python
    remove_file /usr/bin/python-
}

function remove_file() {
    FILE=${1:-somefiledoesnotexist}

    if [ -f $FILE ]
    then
        if [ ! -z $(readlink $FILE) ]
        then
            sudo unlink $FILE
        else
            sudo rm -rf $FILE
        fi
    fi
}

function install_required_python() {
    VERSION=$1

    echo "Installing Python ${VERSION} packages ..."

    sudo apt-get install software-properties-common -y > /dev/null
    sudo add-apt-repository ppa:deadsnakes/ppa  --yes > /dev/null

    sudo apt-get update > /dev/null

    sudo apt-get install -y python${VERSION}-full python${VERSION}-dev > /dev/null

    if [ -z $(which python) ]
    then
        sudo ln -s $(which python${VERSION}) /usr/bin/python
    fi

    echo "Python $(python --version) in installed, cheers!"

    cat << EOF
     _______________
    < I love Python >
     ---------------
            \   ^__^
             \  (oo)\_______
                (__)\       )\/\\
                    ||----w |
                    ||     ||
EOF
}

# function install_corresponding_pip() {
#     VERSION=$1

#     curl -Ls https://bootstrap.pypa.io/pip/get-pip.py | sudo python

#     if [ ! -z $(which pip) ]
#     then
#         pipbin=$(which pip)
#         sudo mv $pipbin /usr/local/bin/pip-
#         sudo ln -s $(which pip${VERSION}) $pipbin
#     else
#         sudo ln -s $(which pip${VERSION}) /usr/local/bin/pip
#     fi

#     sudo -H pip install -U pip
#     sudo -H pip install setuptools six
# }

function install_python() {
    PYTHON_VERSION=$1
    ensure_dependencies
    cleanup_legacy_packages
    install_required_python $PYTHON_VERSION
    # install_corresponding_pip $PYTHON_VERSION
}

install_python ${1:-3.12}
