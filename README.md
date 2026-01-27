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

## [ddns.sh](https://github.com/sunls24/config/blob/main/script/ddns.sh)

可以在路由器中运行的简单 ddns 脚本，支持 `ipv4` 和 `ipv6`（需要 `cloudflare`）

## [shellsb](https://github.com/sunls24/config/tree/main/shellsb)

在路由器中运行 [`sing-box`](https://github.com/SagerNet/sing-box)，并使用 `iptables` 转发和过滤流量，仅转发指定 mac 地址的设备

很多路由器存储空间有限，可以使用这里的[精简打包版本](https://github.com/sunls24/sing-box/actions/workflows/build-small.yml)

## sing-box 配置示例

- [`sing-box.json`](https://github.com/sunls24/config/blob/main/sing-box-config-example/sing-box.json) 仅 ipv4
- [`sing-box-v6.json`](https://github.com/sunls24/config/blob/main/sing-box-config-example/sing-box-v6.json) 优先 ipv6
- [`sing-box-old.json`](https://github.com/sunls24/config/blob/main/sing-box-config-example/sing-box-old.json) 适用于 `1.11.x` 版本（iOS App Store 版本）
- [`sing-box-server.json`](https://github.com/sunls24/config/blob/main/sing-box-config-example/sing-box-server.json) 服务端配置

**默认 hysteria2 协议使用了端口跳跃**，服务器 iptables 脚本可参考[这里](https://github.com/sunls24/config/blob/main/script/port-hopping.sh)
