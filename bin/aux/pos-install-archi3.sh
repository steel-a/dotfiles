#!/bin/bash
export USER="user"
export LANG="pt_BR.UTF-8"
export TIMEZONE="America/Sao_Paulo"

  ###################################
  # ENTRYPOINT IF ALREADY INSTALLED #
  ###################################
  FILE=/root/pos-install-archi3.ok
  if test -f "$FILE"; then
    runuser -l $USER -c 'vncserver :0' &
    trap : TERM INT; sleep infinity & wait
  fi


  ####################
  # PACKAGES Install #
  ####################
  echo "Begin packages install" \
  &&  sed -i 's/#ParallelDownloads = [0-9]*/ParallelDownloads = 10/g' /etc/pacman.conf \
  &&  pacman --noconfirm -Syu \
  &&  pacman --noconfirm --needed -S pacman-contrib \
  &&  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup \
  &&  rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist \
  &&  echo "Fastest mirrors:" && cat /etc/pacman.d/mirrorlist \
  &&  pacman --noconfirm --needed -S sudo shadow coreutils util-linux procps psmisc base-devel \
        wget curl git git-lfs neovim \
        openssh \
        tigervnc \
        i3-gaps gnu-free-fonts ttf-font-awesome xfce4-terminal rofi thunar nitrogen \
        xorg-xprop lxappearance \
  &&  rm -rf /var/cache/pacman
        # wine wine-mono wine-gecko winetricks \
        #  && winetricks winhttp \

  #####################
  # Locale n Timezone #
  #####################
  echo "$LANG UTF-8" > /etc/locale.gen \
  && echo "LANG=$LANG" > /etc/locale.conf \
  && locale-gen \
  && ln -sr /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

  ########
  # User #
  ########
  useradd --create-home $USER \
  && usermod --append --groups wheel $USER \
  && echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && runuser -l $USER -c 'git lfs install' \
  && mv /root/files/* /home/$USER/ \
  && chown -R $USER:$USER /home/$USER/ \
  #&& echo "$USER:$PASS" | chpasswd \

  ########################
  # AUR Packages Install #
  ########################
  # polybar
  # picom
  echo "Begin AUR Install" \
  && runuser -l $USER -c 'export APP=polybar && mkdir -p ~/tmp && cd ~/tmp && git clone https://aur.archlinux.org/$APP && cd $APP && makepkg -Asicr --noconfirm && cd ../.. && rm -rf ~/tmp' \
  && runuser -l $USER -c 'export APP=picom-ibhagwan-git && mkdir -p ~/tmp && cd ~/tmp && git clone https://aur.archlinux.org/$APP && cd $APP && makepkg -Asicr --noconfirm && cd ../.. && rm -rf ~/tmp' \
  && rm -rf /var/cache/pacman \
  && echo "End AUR Install"


  ##############
  # VNC Server #
  ##############
  mkdir -p /home/$USER/.vnc \
  && cp /etc/tigervnc/vncserver-config-defaults   /home/$USER/.vnc/config \
  && echo "securitytypes=None"                  >> /home/$USER/.vnc/config \
  && echo "desktop=sandbox"                     >> /home/$USER/.vnc/config \
  && echo "geometry=1920x1080"                  >> /home/$USER/.vnc/config \
  && echo "localhost"                           >> /home/$USER/.vnc/config \
  && echo "alwaysshared"                        >> /home/$USER/.vnc/config \
  && echo "session=i3"                          >> /home/$USER/.vnc/config \
  && chown -R $USER:$USER /home/$USER/

  #########################
  # Config i3 environment #
  #########################
  runuser -l $USER -c 'git clone https://github.com/steel-a/dotfiles.git ~/.config/dotfiles && chmod -R +x ~/.config/dotfiles/bin/* && ~/.config/dotfiles/bin/aux/dotfiles-load.sh'
z\\#  && runuser -l $USER -c 'git clone -b material-black-COLORS https://github.com/rtlewis88/rtl88-Themes.git /home/$USER/rtl88-Themes' \
#  && cd /home/$USER/rtl88-Themes && mv Material* /usr/share/themes/ && rm -rf /home/$USER/rtl88-Themes \
#  && rm /usr/share/xsessions/i3-*.desktop \
  #&& echo "End Config i3 environment"



  # If TigerVNC is installed, it's headless server, no need to install xorg
  export XORG=""
  if echo "$(pacman -Q --info tigervnc)" | grep -q "erro"; then
    export XORG=" xorg-server xorg-xinit "
  fi


  touch /root/pos-install-archi3.ok
  runuser -l $USER -c 'vncserver :0' &
  trap : TERM INT; sleep infinity & wait
