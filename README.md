# Arch 下自用配置文件

## .zshrc

`zsh` 终端配置，不使用 `Oh My Zsh`，自己简单配置两个插件和主题足够用了。[参考链接](https://zhuanlan.zhihu.com/p/345559097)

```bash
# 安装zsh，插件和主题
sudo pacman -S zsh zsh-completions zsh-syntax-highlighting zsh-autosuggestions zsh-theme-powerlevel10k
# 切换终端
chsh -s /usr/bin/zsh
# copy配置，注销重启
cp .zshrc ~
```
## rime

`RIME` 输入法配置，使用小鹤双拼，只支持简体字。基于 [`placeless`](https://github.com/placeless/squirrel_config) 和 [`四叶草`](https://github.com/fkxxyz/rime-cloverpinyin) 的词库。

```bash
# 安装ibus-rime输入法
sudo pacman -S ibus-rime
# copy配置，重新部署
sudo cp rime/* ~/.config/ibus/rime
```

## .vimrc

`VIM` 编辑器配置文件, 另外也可以使用 [`amix/vimrc`](https://github.com/amix/vimrc) 的配置
```
cp .vimrc ~
```

## goland-settings.zip
`Goland` IDE 设置文件，在编辑器中导入即可

## GRUB2 theme
[`arch-silence`](https://github.com/fghibellini/arch-silence)

```
sudo vim /etc/default/grub
# GRUB_THEME="/boot/grub/themes/arch-silence/theme.txt"

./install.sh
```
