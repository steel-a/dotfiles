#!/bin/bash

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
  adduser \
    --disabled-password \
    --gecos "" \
    --uid "$UID" \
    "$USER"
  chown -R $USER:$USER /home/$USER
  #echo "root:123456" | chpasswd
  #echo "$USER:123456" | chpasswd

  echo "Installing Sudo"
  apt-get install -y --no-install-recommends sudo
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

  echo "Adding user to groups sudo and wheel"
  groupadd wheel
  usermod -aG sudo $USER
  usermod -aG wheel $USER

  echo "User creation finished"
  touch /root/.install/user.ok
fi

################
#    SSH       #
################
if [ -f /root/.install/ssh ]; then
  echo "Creating file sshd_config"
  echo "AuthorizedKeysFile      .ssh/authorized_keys"       > /etc/ssh/sshd_config 
  echo "MaxAuthTries 3"                                    >> /etc/ssh/sshd_config 
  echo "LoginGraceTime 20"                                 >> /etc/ssh/sshd_config 
  echo "AllowAgentForwarding no"                           >> /etc/ssh/sshd_config 
  echo "AllowTcpForwarding yes"                            >> /etc/ssh/sshd_config 
  echo "PermitTunnel no"                                   >> /etc/ssh/sshd_config 
  echo "GatewayPorts no"                                   >> /etc/ssh/sshd_config 
  echo "X11Forwarding yes"                                 >> /etc/ssh/sshd_config 
  echo "PermitRootLogin no"                                >> /etc/ssh/sshd_config 
  echo "PasswordAuthentication no"                         >> /etc/ssh/sshd_config 
  echo "PermitEmptyPasswords no"                           >> /etc/ssh/sshd_config 
  echo "ChallengeResponseAuthentication no"                >> /etc/ssh/sshd_config 
  echo "KerberosAuthentication no"                         >> /etc/ssh/sshd_config 
  echo "GSSAPIAuthentication no"                           >> /etc/ssh/sshd_config 
  echo "PermitUserEnvironment no"                          >> /etc/ssh/sshd_config 
  echo "Protocol 2"                                        >> /etc/ssh/sshd_config 
  echo "UsePAM no"                                         >> /etc/ssh/sshd_config 
  echo "PrintMotd no"                                      >> /etc/ssh/sshd_config 
  echo "PrintLastLog yes"                                  >> /etc/ssh/sshd_config 
  echo "AllowUsers $USER"                                  >> /etc/ssh/sshd_config

  echo "Installing openssh-server"
  apt-get install -y --no-install-recommends openssh-server

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
  apt-get install -y --no-install-recommends tigervnc-standalone-server

  echo "Creating files"
  mkdir -p /home/$USER/.vnc
  echo 'securitytypes=None'  >/home/$USER/.vnc/config
  echo 'desktop=sandbox'     >> /home/$USER/.vnc/config
  echo 'geometry=1366x768'   >>/home/$USER/.vnc/config
  echo 'localhost=no'        >> /home/$USER/.vnc/config
  echo 'alwaysshared'        >> /home/$USER/.vnc/config

  echo '#!/bin/bash'          > /home/$USER/.vnc/xstartup
  echo 'exec i3'             >> /home/$USER/.vnc/xstartup
  chown -R $USER:$USER /home/$USER/
  runuser -l $USER -c 'chmod +x /home/$USER/.vnc/xstartup'

  echo '#!/bin/bash'                                                > /root/.install/vnc.sh
  echo "runuser -l $USER -c 'while :; do vncserver -fg --I-KNOW-THIS-IS-INSECURE; done'" >> /root/.install/vnc.sh
  chmod +x /root/.install/vnc.sh
  
  mv /root/.install/vnc /root/.install/vnc.ok
  echo "VNC config finished"
fi

########################
#    Basic packages    #
########################
if ! [ -f /root/.install/basic.ok ]; then
  echo "Installing Basic Packages"
  apt-get install -y --no-install-recommends ncurses-term nano

  echo "Basic Packages installation end"
  touch /root/.install/basic.ok
fi

################
#    Git       #
################
if ! [ -f /root/.install/git.ok ]; then
  echo "Installing Git"
  apt-get install -y --no-install-recommends git git-lfs
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
  apt-get install -y --no-install-recommends i3-wm polybar nitrogen

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
