#!/bin/bash
sudo apt-get install -y --no-install-recommends neovim python3-pip python3-pynvim python3-flake8 python3-bandit python3-black python3-isort
touch ~/.bashrc
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
echo "Please rum source ~/.bashrc && nvm install --lts && npm install -g pyright"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
