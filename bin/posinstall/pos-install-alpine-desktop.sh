#!/bin/sh

# Test the Arguments
if [ $# -lt 2 ]
  then
    echo "Its necessary 2 arguments"
    exit 1
fi
USER=$1
UID=$2

#########################
#   Create the user     #
#########################
if ! [ -f /root/.install/user.ok ]; then
  echo "Creating user"
  apk add pwgen
  adduser \
    --disabled-password \
    --gecos "" \
    --uid "$UID" \
    "$USER"
  chown -R $USER:$USER /home/$USER
  echo "root:$(pwgen 50 1)" | chpasswd
  echo "$USER:$(pwgen 50 1)" | chpasswd

  echo "Installing Sudo"
  apk add sudo
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

  echo "Adding user to groups sudo and wheel"
  addgroup $USER wheel

  echo "User creation finished"
  touch /root/.install/user.ok
fi

################
#    SSH       #
################
if [ -f /root/.install/ssh ]; then

  apk add --no-cache --update openssh openssh-keygen runuser && rm -rf /var/cache/* && mkdir /var/cache/apk \
    && rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key \
    && ssh-keygen -A \
    && mkdir -p /var/run/sshd \
    && chown -R $USER:$USER /home/$USER \
    && echo "AuthorizedKeysFile      .ssh/authorized_keys"      > /etc/ssh/sshd_config \
    && echo "MaxAuthTries 3"                                    >> /etc/ssh/sshd_config \
    && echo "LoginGraceTime 20"                                 >> /etc/ssh/sshd_config \
    && echo "AllowAgentForwarding no"                           >> /etc/ssh/sshd_config \
    && echo "AllowTcpForwarding yes"                             >> /etc/ssh/sshd_config \
    && echo "PermitTunnel yes"                                   >> /etc/ssh/sshd_config \
    && echo "GatewayPorts no"                                   >> /etc/ssh/sshd_config \
    && echo "X11Forwarding yes"                                 >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin no"                                >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication no"                         >> /etc/ssh/sshd_config \
    && echo "PermitEmptyPasswords no"                           >> /etc/ssh/sshd_config \
    && echo "ChallengeResponseAuthentication no"                >> /etc/ssh/sshd_config \
    && echo "KerberosAuthentication no"                         >> /etc/ssh/sshd_config \
    && echo "GSSAPIAuthentication no"                           >> /etc/ssh/sshd_config \
    && echo "PermitUserEnvironment no"                          >> /etc/ssh/sshd_config \
    && echo "Protocol 2"                                        >> /etc/ssh/sshd_config \
    && echo "UsePAM no"                                         >> /etc/ssh/sshd_config \
    && echo "PrintMotd no"                                      >> /etc/ssh/sshd_config \
    && echo "PrintLastLog yes"                                  >> /etc/ssh/sshd_config \
    && echo "AllowUsers $USER"                                  >> /etc/ssh/sshd_config



  echo "Creating dir and getting id_rsa files"
  mkdir -p /home/$USER/.ssh
  cp /.sshtmp/id_rsa /home/$USER/.ssh/ 2>/dev/null
  cp /.sshtmp/id_rsa.pub /home/$USER/.ssh/ 2>/dev/null
  chown -R $USER:$USER /home/$USER
  
  echo "Permission to .ssh"
  runuser -l $USER -c 'chmod 0700 /home/$USER/.ssh'
  echo "Permission to authorized_keys"
  runuser -l $USER -c 'chmod 600 /home/$USER/.ssh/*'
  echo "Extra permission in /var/run/sshd"
  mkdir -p -m0755 /var/run/sshd
  echo "Creating ssh.ok"  
  mv /root/.install/ssh /root/.install/ssh.ok
  echo "SSH config finished"
  ls -lah /home/$USER/.ssh/
fi



################
#    VNC       #
################
if [ -f /root/.install/vnc ]; then

  echo "Installing TigerVNC"
  apk add tigervnc runuser

  echo "Creating files"
  mkdir -p /home/$USER/.vnc
  echo 'securitytypes=None'  >/home/$USER/.vnc/config
  echo 'desktop=sandbox'     >> /home/$USER/.vnc/config
  echo 'geometry=1920x1080'   >>/home/$USER/.vnc/config
  echo 'localhost=no'        >> /home/$USER/.vnc/config
  echo 'alwaysshared'        >> /home/$USER/.vnc/config

  echo '#!/bin/sh'          > /home/$USER/.vnc/xstartup
  echo 'exec i3'             >> /home/$USER/.vnc/xstartup
  chown -R $USER:$USER /home/$USER/
  runuser -l $USER -c 'chmod +x /home/$USER/.vnc/xstartup'

  echo '#!/bin/sh'                                                > /root/.install/vnc.sh
  echo "runuser -l $USER -c 'while :; do vncserver :1 ; done'" >> /root/.install/vnc.sh
  chmod +x /root/.install/vnc.sh
  
  mv /root/.install/vnc /root/.install/vnc.ok
  echo "VNC config finished"
fi

########################
#    Basic packages    #
########################
if ! [ -f /root/.install/basic.ok ]; then
  echo "Installing Basic Packages"
  apk add nano wget psmisc

  echo "Basic Packages installation end"
  touch /root/.install/basic.ok
fi

################
#    Git       #
################
if ! [ -f /root/.install/git.ok ]; then
  echo "Installing Git"
  apk add git git-lfs
  runuser -l $USER -c 'git lfs install'
  runuser -l $USER -c 'ssh-keyscan -t rsa github.com > /home/$USER/.ssh/known_hosts'

  echo "Git installation end"
  touch /root/.install/git.ok
fi



################
#    i3-wm    #
################
if [ -f /root/.install/i3 ]; then

  echo "Installing i3 packages"
  apk add i3wm polybar picom mesa-utils alacritty font-awesome lf firefox

  (mkdir -p /usr/share/fonts/truetype \
   && cd /usr/share/fonts/truetype \
   && wget https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Inconsolata/InconsolataNerdFontMono-Regular.ttf \
   && fc-cache -fv)

  echo "Clonning git repo"
  runuser -l $USER -c 'git clone git@github.com:steel-a/dotfiles.git /home/$USER/.config/dotfiles'
  echo "Verify if Git Clone was sucessfull. If not, do it again with https"
  if ! [ -f /home/$USER/.config/dotfiles/bin/posinstall/dotfiles-load.sh ]; then
    runuser -l $USER -c 'git clone https://github.com/steel-a/dotfiles.git /home/$USER/.config/dotfiles'
  fi
  
  echo "Changing permission to +exec"
  runuser -l $USER -c 'chmod -R +x /home/$USER/.config/dotfiles/bin/*'
  echo "Loading dotfiles"
  runuser -l $USER -c '/home/$USER/.config/dotfiles/bin/posinstall/dotfiles-load.sh'
   

  mv /root/.install/i3 /root/.install/i3.ok
  echo "i3 config finished"
fi
