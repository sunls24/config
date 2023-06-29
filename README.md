# Linux & Develop 自用配置

## .zshrc

`zsh` 终端配置，插件：[`zsh-syntax-highlighting`](https://github.com/zsh-users/zsh-syntax-highlighting) [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) [`zsh-theme-powerlevel10k`](https://github.com/romkatv/powerlevel10k)

```shell
curl -sfO https://raw.githubusercontent.com/sunls24/config/master/.zshrc
```

## .vimrc

`vim` 基础配置：[amix/vimrc](https://github.com/amix/vimrc)，`one-light` 主题：[rakr/vim-one](https://github.com/rakr/vim-one)

```shell
curl -sf https://raw.githubusercontent.com/sunls24/config/master/one.vim | bash
```

## Vimium

[Vimium](https://vimium.github.io) 浏览器插件的配置和主题

```shell
curl -sfO https://raw.githubusercontent.com/sunls24/config/main/vimium-options.json
```

## VPS 网络重装

### [debi.sh](https://github.com/bohanyang/debi)

```shell
curl -sfLO https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh && chmod +x debi.sh

./debi.sh --no-install-recommends --no-apt-non-free-firmware --no-apt-src --no-apt-backports --cloud-kernel --bbr --grub-timeout 0 --timezone Asia/Shanghai --dns 8.8.8.8 --install curl --version 13 --ssh-port xxx --hostname xxx --user xxx --password xxx

# 重启
shutdown -r now

# 撤销
rm -rf debi.sh /etc/default/grub.d/zz-debi.cfg /boot/debian-* && { sudo update-grub || sudo grub2-mkconfig -o /boot/grub2/grub.cfg; }
```

### debian-init
```shell
curl -sf https://raw.githubusercontent.com/sunls24/config/master/script/debian-init.sh | bash
```

### arch-init

```shell
curl -sf https://raw.githubusercontent.com/sunls24/config/master/script/arch-init.sh | bash
```
