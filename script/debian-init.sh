#!/usr/bin/env bash

set -e

apt update && apt upgrade -y
apt install -y vim curl wget zsh git htop zsh-syntax-highlighting docker.io docker-compose jq systemd-timesyncd

USERNAME=${1:-sunls}
chsh -s /usr/bin/zsh $USERNAME
[ $USERNAME = "root" ] || usermod -aG docker $USERNAME

[ -e /etc/motd ] && rm /etc/motd
sed -i 's|UsePAM yes|UsePAM no|' /etc/ssh/sshd_config
sed -i 's|#PrintLastLog yes|PrintLastLog no|' /etc/ssh/sshd_config
sed -i 's|X11Forwarding yes|X11Forwarding no|' /etc/ssh/sshd_config
sed -i 's|#ClientAliveInterval 0|ClientAliveInterval 60|' /etc/ssh/sshd_config
sed -i 's|#ClientAliveCountMax 3|ClientAliveCountMax 10|' /etc/ssh/sshd_config
systemctl restart sshd

sudo -i -u $USERNAME bash <<EOF
set -e

# zsh
[ -e .zshrc ] || curl -sfO https://raw.githubusercontent.com/sunls24/config/master/.zshrc

mkdir -p .zsh
[ -e .zsh/zsh-autosuggestions ] || git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions .zsh/zsh-autosuggestions
[ -e .zsh/powerlevel10k ] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git .zsh/powerlevel10k

sed -i 's|/usr/share/zsh/plugins/zsh-syntax|/usr/share/zsh-syntax|' .zshrc
sed -i 's|/usr/share/zsh/plugins|~/.zsh|' .zshrc
sed -i 's|/usr/share/zsh-theme-|~/.zsh/|' .zshrc

echo "
alias upgrade='sudo apt update && sudo apt upgrade -y'
alias cleanup='sudo apt autoremove && sudo apt clean && sudo apt autoclean && sudo rm -rf /var/lib/apt/lists/* && sudo apt update'" >> .zshrc

# vim
[ -e .vimrc ] || curl -sf https://raw.githubusercontent.com/sunls24/config/master/one.vim | bash

# ssh
[ -e .ssh ] || (mkdir .ssh && chmod 700 .ssh)
[ -e .ssh/authorized_keys ] || (touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys)
EOF
