#!/bin/sh

# ref. http://qiita.com/woowee/items/edafa395df84ae4292e1

pb=/usr/libexec/PlistBuddy
plistis=/System/Library/Input\ Methods/JapaneseIM.app/Contents/Resources/KeySetting_Default.plist
# if [ ! -e "$plistis.orig" ]; then
#     sudo cp $plistis $plistis.orig
# fi

# ' '
sudo "${pb}" -c "Set :keys:before_typing:\'' \'':character ' '" "${plistis}"
sudo "${pb}" -c "Set :keys:before_typing:shift+\'' \'':character '　'" "${plistis}"

# '`'
sudo "${pb}" -c "Set :keys:*:\''\`\'':character '\`'" "${plistis}"
# '~'
# do nothing
# '!'
# do nothing
# '@'
sudo "${pb}" -c "Set :keys:*:\''@\'':character '@'" "${plistis}"
# '#'
sudo "${pb}" -c "Set :keys:*:\''#\'':character '#'" "${plistis}"
# '$'
sudo "${pb}" -c "Set :keys:*:\''$\'':character '$'" "${plistis}"
# '%'
sudo "${pb}" -c "Set :keys:*:\''%\'':character '%'" "${plistis}"
# '^'
sudo "${pb}" -c "Set :keys:*:\''^\'':character '^'" "${plistis}"
# '&'
sudo "${pb}" -c "Set :keys:*:\''&\'':character '&'" "${plistis}"
# '*'
sudo "${pb}" -c "Set :keys:*:\''*\'':character '*'" "${plistis}"
# '(', ')'
# sudo "${pb}" -c "Set :keys:*:\''(\'':character '('" "${plistis}"
# sudo "${pb}" -c "Set :keys:*:\'')\'':character ')'" "${plistis}"
# '-'
# sudo "${pb}" -c "Set :keys:*:\''-\'':character '-'" "${plistis}"
# '_'
sudo "${pb}" -c "Set :keys:*:\''_\'':character '_'" "${plistis}"
# '='
sudo "${pb}" -c "Set :keys:*:\''=\'':character '='" "${plistis}"
# '+'
sudo "${pb}" -c "Set :keys:*:\''+\'':character '+'" "${plistis}"
# '[', ']', '{', '}'
# do nothing
# '\'
# TODO
# '|'
sudo "${pb}" -c "Set :keys:*:\''|\'':character '|'" "${plistis}"
# ':'
sudo "${pb}" -c "Set :keys:*:\''\:\'':character ':'" "${plistis}"
# ';'
# sudo "${pb}" -c "Set :keys:*:\'';\'':character ';'" "${plistis}"
# '\''
sudo "${pb}" -c "Set :keys:*:\''\'\'':character '\''" "${plistis}"
# '\"'
sudo "${pb}" -c "Set :keys:*:\''"'\"'"\'':character '"'\"'"'" "${plistis}"
# "<", ">"
sudo "${pb}" -c "Set :keys:*:\''<\'':character '<'" "${plistis}"
sudo "${pb}" -c "Set :keys:*:\''>\'':character '>'" "${plistis}"
# '/'
# do nothing
# '?'
# sudo "${pb}" -c "Set :keys:*:\''?\'':character '?'" "${plistis}"

killall JapaneseIM
