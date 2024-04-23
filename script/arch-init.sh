#!/usr/bin/env bash

set -e

pacman --noconfirm -Syyu
pacman -S --noconfirm --needed sudo wget zsh git base-devel \
    zsh-syntax-highlighting zsh-autosuggestions zsh-theme-powerlevel10k \
    docker docker-compose jq bind unzip tmux

cat >/etc/sysctl.d/bbr.conf <<EOF
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF
sysctl -p /etc/sysctl.d/bbr.conf

# add user
USERNAME=sunls
if id -u "${USERNAME}" >/dev/null 2>&1; then
    true
else
    useradd -m -G wheel -s /bin/bash $USERNAME
    echo "Enter the $USERNAME password"
    passwd $USERNAME
    sed -i 's|# %wheel ALL=(ALL:ALL) NOPASSWD: ALL|%wheel ALL=(ALL:ALL) NOPASSWD: ALL|' /etc/sudoers
fi

# edit sshd_config
sed -i 's|#Port 22|Port 24|' /etc/ssh/sshd_config
sed -i 's|PermitRootLogin yes|#PermitRootLogin yes|' /etc/ssh/sshd_config
sed -i 's|UsePAM yes|UsePAM no|' /etc/ssh/sshd_config
sed -i 's|#ClientAliveInterval 0|ClientAliveInterval 60|' /etc/ssh/sshd_config
sed -i 's|#ClientAliveCountMax 3|ClientAliveCountMax 10|' /etc/ssh/sshd_config
systemctl restart sshd

systemctl enable --now docker
chsh -s /usr/bin/zsh $USERNAME
id $USERNAME | grep docker >/dev/null 2>&1 || usermod -aG docker $USERNAME

sudo -i -u $USERNAME bash <<EOF
# yay
if command -v yay >/dev/null 2>&1; then
    true
else
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ~
    yay --noconfirm
    rm -rf yay-bin
fi

# zsh
[ -e .zshrc ] || curl -s https://raw.githubusercontent.com/sunls24/config/master/.zshrc -o .zshrc

# vim
[ -e .vimrc ] || curl -s https://raw.githubusercontent.com/sunls24/config/master/one.vim | bash

# ssh
[ -e .ssh ] || (mkdir .ssh && chmod 700 .ssh)
[ -e .ssh/authorized_keys ] || (touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys)
EOF

echo "done"
