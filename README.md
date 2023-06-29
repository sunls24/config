# Linux 自用配置

## arch-init

```shell
curl -sf https://raw.githubusercontent.com/sunls24/config/master/script/arch-init.sh | bash
```

## .zshrc

```shell
curl -sfO https://raw.githubusercontent.com/sunls24/config/master/.zshrc
```

## .vimrc

```shell
curl -sf https://raw.githubusercontent.com/sunls24/config/master/one.vim | bash
```

## [debi.sh](https://github.com/bohanyang/debi)

```shell
curl -sfLO https://raw.githubusercontent.com/bohanyang/debi/master/debi.sh && chmod +x debi.sh

./debi.sh --bbr --cloud-kernel --ethx --timezone Asia/Shanghai --full-upgrade --version 12 --grub-timeout 0 --ssh-port 24 --hostname xxx --user sunls --password xxx

# 重启
shutdown -r now

# 撤销
rm -rf debi.sh /etc/default/grub.d/zz-debi.cfg /boot/debian-* && { sudo update-grub || sudo grub2-mkconfig -o /boot/grub2/grub.cfg; }
```

## debian-init
```shell
curl -sf https://raw.githubusercontent.com/sunls24/config/master/script/debian-init.sh | bash
```
