#!/bin/bash

# Test the Arguments
if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi
USER=$1

#########################
#   Create the user     #
#########################
if ! [ -f /root/.install/user.ok ]; then
  RUN adduser \
    --disabled-password \
    --gecos "" \
    --uid "1000" \
    "$USER"
  chown -R $USER:$USER /home/$USER
  echo "root:123456" | chpasswd
  echo "$USER:123456" | chpasswd

  apt-get install -y sudo
  echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
  usermod -aG sudo $USER
  usermod -aG wheel $USER

touch /root/.install/user.ok
fi

################
#    SSH       #
################
if [ -f /root/.install/ssh ]; then
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
  apt-get install -y openssh-server
  chmod 0700 /home/$USER/.ssh
  chmod 600 /home/$USER/.ssh/authorized_keys
  
  mv /root/.install/ssh /root/.install/ssh.ok
fi
