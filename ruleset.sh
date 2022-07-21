# https://github.com/Loyalsoldier/clash-rules
list="reject icloud apple google proxy direct private gfw greatfire tld-not-cn telegramcidr cncidr lancidr applications"
for i in $list; do
    curl https://raw.githubusercontent.com/Loyalsoldier/clash-rules/release/"$i".txt >~/.config/clash/ruleset/"$i".yaml
done
