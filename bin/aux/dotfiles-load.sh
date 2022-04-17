ln -f ~/.config/dotfiles/.Xresources		~/.Xresources

mkdir -p ~/.config/ 		&& ln -f ~/.config/dotfiles/picom.conf		 ~/.config/picom.conf
mkdir -p ~/.config/i3/		&& ln -f ~/.config/dotfiles/i3.config 		 ~/.config/i3/config
mkdir -p ~/.config/gtk-3.0/	&& ln -f ~/.config/dotfiles/gtk-3.0.settings.ini ~/.config/gtk-3.0/settings.ini
mkdir -p ~/.config/polybar/     && ln -f ~/.config/dotfiles/polybar.config       ~/.config/polybar/config
				   ln -f ~/.config/dotfiles/gtkrc-2.0		 ~/.gtkrc-2.0
mkdir -p ~/.config/xfce4/terminal && ln -f ~/.config/dotfiles/xfce4.terminalrc   ~/.config/xfce4/terminal/terminalrc

if [ ! -f ~/.config/nitrogen/bg-saved.cfg ]; then
  mkdir -p ~/.config/wallpapers/ && ln -f ~/.config/dotfiles/bg.jpg ~/.config/wallpapers/bg.jpg
  mkdir ~/.config/nitrogen
  echo "[xin_-1]"							> ~/.config/nitrogen/bg-saved.cfg
  echo "file=/home/$USER/.config/wallpapers/bg.jpg"			>> ~/.config/nitrogen/bg-saved.cfg
  echo "mode=5" 							>> ~/.config/nitrogen/bg-saved.cfg
  echo "bgcolor=#000000" 						>> ~/.config/nitrogen/bg-saved.cfg
fi
