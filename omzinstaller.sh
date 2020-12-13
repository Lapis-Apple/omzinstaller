#!/bin/sh


command_exists() {
        command -v "$@" >/dev/null 2>&1
}

if ! command_exists zsh; then
    echo "Zsh is not installed! Please install it."
    exit 1
fi

if ! command_exists curl; then
    echo "curl is not installed. Please install it."
    exit 1
fi

if ! command_exists git; then
    echo "git is not installed. Please install it."
    exit 1
fi

if [ `whoami` != "root" ];then
	echo "WARNING: Use root user."
	exit 1
fi

#从Fastgit得到oh-my-zsh安装脚本
curl -o ohmyzshinstall.sh https://raw.fastgit.org/ohmyzsh/ohmyzsh/master/tools/install.sh
#加上可执行权限
chmod +x ./ohmyzshinstall.sh
#开始安装 （不运行zsh 安装在/usr/share/oh-my-zsh 从Fastgit下载）
RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} REPO=${REPO:-ohmyzsh/ohmyzsh} REMOTE=${REMOTE:-https://hub.fastgit.org/${REPO}.git} ./ohmyzshinstall.sh
#备份template zshrc
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template /usr/share/oh-my-zsh/templates/zshrc.zsh-template_bak
#删掉安装脚本生成的zshrc
rm -rf ~/.zshrc

#修改Zshrc
sed -i "s#\$HOME/.oh-my-zsh#\"/usr/share/oh-my-zsh\"#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#robbyrussell#ys#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#plugins=(git)#plugins=(git extract sudo cp zsh_reload zsh-syntax-highlighting zsh-autosuggestions)#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template

#安装高亮插件
git clone https://hub.fastgit.org/zsh-users/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting
#安装自动提示插件
git clone https://hub.fastgit.org/zsh-users/zsh-autosuggestions /usr/share/oh-my-zsh/plugins/zsh-autosuggestions

#把修改完的zshrc拷贝到用户文件夹
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

#输出提示
echo -e "\033[33moh-my-zsh is now installed! \033[0m" && echo "if you want to let oh-my-zsh works in other user, go to that user and execute:" && echo -e "\033[36mcp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \033[0m"
