#!/bin/sh
# OMZInstaller Script!
# A simple script for installing oh-my-zsh for all users, common plugins, and mirror for China Mainland!
# This script is open-source under MPL.
# GitHub URL: https://github.com/Lapis-Apple/omzinstaller/
# Made by Lapis Apple! Twitter@LapisApple2
command_exists() {
        command -v "$@" >/dev/null 2>&1
}
self_check() {
if ! command_exists zsh; then
    echo "FATAL: zsh is not installed. Please install it."
    exit 1
fi

if ! command_exists wget; then
    if ! command_exists curl; then
        echo "FATAL: wget or curl is not installed. Please install one or more of it(recommended wget)."
        exit 1
    else
        echo "WARNING: wget is not installed, falling back to curl. this may cause error."
        echo "We strongly recommended you press Ctrl+C now and install wget, then run omzinstaller again."
        echo "Waiting for 10s.."
        sleep 10s
        USED_DOWNLOADER='curl'
    fi
else
    USED_DOWNLOADER='wget'
fi

if ! command_exists git; then
    echo "FATAL: git is not installed. Please install it."
    exit 1
fi

if [ -d "/usr/share/oh-my-zsh" ]; then
    echo "FATAL: /usr/share/oh-my-zsh exists! Please delete it before install."
    exit 1

#    read -p "WARNING: Do you want to ignore this error? (y/N)" ANSWER
#    if [ "$ANSWER" != "Y" -o "$ANSWER" != "y" ]; then
#        exit 1
#    fi
fi

if [ `whoami` != "root" ];then
	echo "FATAL: Use root user."
	exit 1
fi
}
self_check

read -p "What mirror do you want to use? G=GitHub F=FastGit E=Gitee > " MIRRORANSWER
#if [ "$MIRRORANSWER" != "F" -o "$MIRRORANSWER" != "f" -o "$MIRRORANSWER" != "g" -o "$MIRRORANSWER" != "G" -o "$MIRRORANSWER" != "E" -o "$MIRRORANSWER" != "e" ]; then
#    echo "FATAL: Selection invaild."
#    exit 1
#fi

echo "Now downloading install script.."
if [ $USED_DOWNLOADER = curl ]; then
    DOWNLOAD_CMD="$USED_DOWNLOADER -o install.sh" 
else
    DOWNLOAD_CMD="$USED_DOWNLOADER"
fi

if [ "$MIRRORANSWER" = "G" -o "$MIRRORANSWER" = "g" ]; then
    $DOWNLOAD_CMD https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
elif [ "$MIRRORANSWER" = "F" -o "$MIRRORANSWER" = "f" ]; then
    $DOWNLOAD_CMD https://raw.fastgit.org/ohmyzsh/ohmyzsh/master/tools/install.sh
elif [ "$MIRRORANSWER" = "e" -o "$MIRRORANSWER" = "E" ]; then
    $DOWNLOAD_CMD https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
elif [ "$MIRRORANSWER" = "o" -o "$MIRRORANSWER" = "O" ]; then
    $DOWNLOAD_CMD https://codechina.csdn.net/mirrors/ohmyzsh/ohmyzsh/-/raw/master/tools/install.sh

else
    echo "FATAL: Selection may invaild."
fi


chmod +x ./install.sh

echo "----- RUNNING OH-MY-ZSH INSTALL SCRIPT -----"
if [ "$MIRRORANSWER" = "G" -o "$MIRRORANSWER" = "g" ]; then
    RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} ./install.sh
elif [ "$MIRRORANSWER" = "F" -o "$MIRRORANSWER" = "f" ]; then
    RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} REPO=${REPO:-ohmyzsh/ohmyzsh} REMOTE=${REMOTE:-https://hub.fastgit.org/${REPO}.git} ./install.sh
elif [ "$MIRRORANSWER" = "e" -o "$MIRRORANSWER" = "E" ]; then
    RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} REPO=${REPO:-mirrors/oh-my-zsh} REMOTE=${REMOTE:-https://gitee.com/${REPO}.git} ./install.sh
elif [ "$MIRRORANSWER" = "o" -o "$MIRRORANSWER" = "O" ]; then
    MIRRORANSWER="f"
    echo "Thank you for testing CodeChina Mirror! Aftet that I'll redirect you to FastGit."
    RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} REPO=${REPO:-ohmyzsh/ohmyzsh} REMOTE=${REMOTE:-https://codechina.csdn.net/mirrors/${REPO}.git} ./install.sh
else
    echo "What? How do you get there? Report this bug if you're not developer."
fi
if [ $? != 0 ];then
    echo "WARNING: Install script returned error!"
    read -p "WARNING: Do you want to ignore this error? (y/N)" ANSWER
    if [ "$ANSWER" != "Y" -o "$ANSWER" != "y" ]; then
        exit 1
    fi
fi
echo "----- OH-MY-ZSH INSTALL SCRIPT COMPLETED -----"
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template /usr/share/oh-my-zsh/templates/zshrc.zsh-template.bak
rm ~/.zshrc

echo "Now patching zshrc file.."

sed -i "s#\$HOME/.oh-my-zsh#\"/usr/share/oh-my-zsh\"#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#robbyrussell#gentoo#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#plugins=(git)#plugins=(git extract sudo cp pip z wd zsh_reload zsh-syntax-highlighting zsh-autosuggestions adb docker)#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template

echo "Now installing zsh-syntax-highlighting."

if [ "$MIRRORANSWER" = "G" -o "$MIRRORANSWER" = "g" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
elif [ "$MIRRORANSWER" = "F" -o "$MIRRORANSWER" = "f" ]; then
    git clone https://hub.fastgit.org/zsh-users/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
elif [ "$MIRRORANSWER" = "e" -o "$MIRRORANSWER" = "E" ]; then
    git clone https://gitee.com/mirror-github/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
fi

echo "Now installing zsh-autosuggestions."

if [ "$MIRRORANSWER" = "G" -o "$MIRRORANSWER" = "g" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git /usr/share/oh-my-zsh/plugins/zsh-autosuggestions
elif [ "$MIRRORANSWER" = "F" -o "$MIRRORANSWER" = "f" ]; then
    git clone https://hub.fastgit.org/zsh-users/zsh-autosuggestions.git /usr/share/oh-my-zsh/plugins/zsh-autosuggestions
elif [ "$MIRRORANSWER" = "e" -o "$MIRRORANSWER" = "E" ]; then
    git clone https://gitee.com/mirror-github/zsh-autosuggestions.git /usr/share/oh-my-zsh/plugins/zsh-autosuggestions
fi

echo "Applying patched zshrc file.."
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo -e "\033[33moh-my-zsh is now installed! \033[0m" && echo "if you want to let oh-my-zsh works in other user, go to that user and execute:" && echo -e "\033[36mcp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \033[0m"

exit 0
