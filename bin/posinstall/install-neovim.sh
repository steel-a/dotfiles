#!/bin/bash
sudo apt-get install -y neovim python3-pip python3-pynvim python3-flake8 python3-bandit python3-isort python3-debugpy python3-venv gcc build-essential
touch ~/.bashrc
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir ~/.virtualenvs
cd ~/.virtualenvs
python3 -m venv debugpy
debugpy/bin/python -m pip install debugpy

source ~/.bashrc && nvm install --lts && npm install -g pyright


echo ""
echo "#######################################################################"
echo "Enter nvim and run the commands:                                       "
echo "        :PlugInstall                                                   "
echo "        :TSInstall python                                              "
echo "#######################################################################"
