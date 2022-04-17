ln -f ~/.config/dotfiles/.Xresources		~/.Xresources

mkdir -p ~/.config/ 		&& ln -f ~/.config/dotfiles/picom.conf		~/.config/picom.conf
mkdir -p ~/.config/i3/		&& ln -f ~/.config/dotfiles/i3.config 		~/.config/i3/config
mkdir -p ~/.config/nitrogen/ 	&& ln -f ~/.config/dotfiles/nitrogen.cfg 	~/.config/nitrogen/nitrogen.cfg
				   ln -f ~/.config/dotfiles/nitrogen.bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
mkdir -p ~/.config/gtk-3.0/	&& ln -f ~/.config/dotfiles/gtk-3.0.settings.ini ~/.config/gtk-3.0/settings.ini
mkdir -p ~/.config/polybar/     && ln -f ~/.config/dotfiles/polybar.config      ~/.config/polybar/config

DIR="~/.config/wallpapers/"
if [ -d "$DIR" ]; then
  ln -f ~/.config/dotfiles/nitrogen.bg-saved.cfg ~/.config/nitrogen/bg-saved.cfg
else
  mkdir -p ~/.config/wallpapers/
  wget https://abglt.org.br/wp-content/uploads/2020/10/wallpaper-pc1-scaled.jpg -P ~/.config/wallpapers/
  echo "[xin_-1]"							> ~/.config/nitrogen/bg-saved.cfg
  echo "file=/home/$USER/.config/wallpapers/wallpaper-pc1-scaled.jpg"	>> ~/.config/nitrogen/bg-saved.cfg
  echo "mode=5" 							>> ~/.config/nitrogen/bg-saved.cfg
  echo "bgcolor=#000000" 						>> ~/.config/nitrogen/bg-saved.cfg
fi
