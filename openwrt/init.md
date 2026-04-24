1. delete pkg: luci-app-attendedsysupgrade
2. add pkg:
   luci-i18n-base-zh-cn luci-i18n-firewall-zh-cn luci-i18n-package-manager-zh-cn
   kmod-tun kmod-nft-queue
3. theme:
   https://github.com/eamonxg/luci-theme-aurora
   https://github.com/eamonxg/luci-app-aurora-config
4. rm -rf /etc/profile.d/apk-cheatsheet.sh
5. ddns / sing-box
6. authorized_keys:
   vim /etc/dropbear/authorized_keys
   chmod 600 /etc/dropbear/authorized_keys
