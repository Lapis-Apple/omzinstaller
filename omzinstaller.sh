#!/bin/sh

# OmzInstaller Script
# By Lapis Apple (laple@pd2.ink)
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
        USE_DOWNLOADER='curl'
    fi
else
    USE_DOWNLOADER='wget'
fi

if ! command_exists git; then
    echo "FATAL: git is not installed. Please install it."
    exit 1
fi

if [ -d "/usr/share/oh-my-zsh" ]; then
    echo "FATAL: /usr/share/oh-my-zsh exists! Please delete it before install."
    #exit 1
fi

if [ `whoami` != "root" ];then
	echo "FATAL: Use root user."
	exit 1
fi
}
self_check

echo "Now downloading install script.."
if [ $USE_DOWNLOADER = curl ]; then
    $USE_DOWNLOADER -o install.sh https://raw.fastgit.org/ohmyzsh/ohmyzsh/master/tools/install.sh
else
    $USE_DOWNLOADER https://raw.fastgit.org/ohmyzsh/ohmyzsh/master/tools/install.sh
fi
chmod +x ./install.sh

echo "----- RUNNING OH-MY-ZSH INSTALL SCRIPT -----"
RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} REPO=${REPO:-ohmyzsh/ohmyzsh} REMOTE=${REMOTE:-https://hub.fastgit.org/${REPO}.git} ./install.sh
if [ $? != 0 ];then
    echo "WARNING: Install script returned error. Code=$?."
    read -p "WARNING: Do you want to ignore this error? (y/N)" ANSWER
    if [ "$ANSWER" != "Y" -o "$ANSWER" != "y" ]; then
        exit 1
    fi
fi
echo "----- OH-MY-ZSH INSTALL SCRIPT COMPLETED -----"
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template /usr/share/oh-my-zsh/templates/zshrc.zsh-template_bak
rm -rf ~/.zshrc

echo "Now patching zshrc file.."

sed -i "s#\$HOME/.oh-my-zsh#\"/usr/share/oh-my-zsh\"#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#robbyrussell#gentoo#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#plugins=(git)#plugins=(git extract sudo cp pip z wd zsh_reload zsh-syntax-highlighting zsh-autosuggestions adb docker)#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template

echo "Now installing zsh-syntax-highlighting."
git clone https://hub.fastgit.org/zsh-users/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
echo "Now installing zsh-autosuggestions."
git clone https://hub.fastgit.org/zsh-users/zsh-autosuggestions /usr/share/oh-my-zsh/plugins/zsh-autosuggestions
#echo "Now installing autojump."
#git clone https://hub.fastgit.org/wting/autojump.git /usr/share/oh-my-zsh/plugins/autojump

echo "Applying patched zshrc file.."
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

echo -e "\033[33moh-my-zsh is now installed! \033[0m" && echo "if you want to let oh-my-zsh works in other user, go to that user and execute:" && echo -e "\033[36mcp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \033[0m"

exit 0
