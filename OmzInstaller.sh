#!/bin/sh


if [ `whoami` != "root" ];then
	echo "WARNING: Use root!!"
	exit 1
fi

#从Gitee得到oh-my-zsh安装脚本
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
#加上可执行权限
chmod +x ./install.sh
#开始安装 （不运行zsh 安装在/usr/share/oh-my-zsh 从gitee镜像下载）
RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} REPO=${REPO:-mirrors/oh-my-zsh} REMOTE=${REMOTE:-https://gitee.com/${REPO}.git} ./install.sh
#备份template zshrc
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template /usr/share/oh-my-zsh/templates/zshrc.zsh-template_bak
#删掉安装脚本生成的zshrc
rm -rf ~/.zshrc

#修改Zshrc
sed -i "s#\$HOME/.oh-my-zsh#\"/usr/share/oh-my-zsh\"#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#robbyrussell#ys#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#plugins=(git)#plugins=(git extract sudo cp zsh_reload zsh-syntax-highlighting)#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template

#安装高亮插件
git clone https://gitee.com/Annihilater/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting

#把修改完的zshrc拷贝到用户文件夹
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

#输出提示
echo -e "\033[33moh-my-zsh is now installed! \033[0m" && echo "if you want to let oh-my-zsh works in other user, go to that user and execute:" && echo -e "\033[36mcp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \033[0m"


#rm -rf ./install.sh && wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh && chmod +x ./install.sh#!/bin/sh

command_exists() {
        command -v "$@" >/dev/null 2>&1
}

if ! command_exists zsh; then
    echo "${YELLOW}Zsh is not installed!${RESET} Please install it!!"
    exit 1
fi

if [ `whoami` != "root" ];then
	echo "WARNING: Use root!!"
	exit 1
fi

#从Gitee得到oh-my-zsh安装脚本
wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh
#加上可执行权限
chmod +x ./install.sh
#开始安装 （不运行zsh 安装在/usr/share/oh-my-zsh 从gitee镜像下载）
RUNZSH=no ZSH=${ZSH:-/usr/share/oh-my-zsh} REPO=${REPO:-mirrors/oh-my-zsh} REMOTE=${REMOTE:-https://gitee.com/${REPO}.git} ./install.sh
#备份template zshrc
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template /usr/share/oh-my-zsh/templates/zshrc.zsh-template_bak
#删掉安装脚本生成的zshrc
rm -rf ~/.zshrc

#修改Zshrc
sed -i "s#\$HOME/.oh-my-zsh#\"/usr/share/oh-my-zsh\"#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#robbyrussell#ys#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template
sed -i "s#plugins=(git)#plugins=(git extract sudo cp zsh_reload zsh-syntax-highlighting)#g"  /usr/share/oh-my-zsh/templates/zshrc.zsh-template

#安装高亮插件
git clone https://gitee.com/Annihilater/zsh-syntax-highlighting.git /usr/share/oh-my-zsh/plugins/zsh-syntax-highlighting

#把修改完的zshrc拷贝到用户文件夹
cp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

#输出提示
echo -e "\033[33moh-my-zsh is now installed! \033[0m" && echo "if you want to let oh-my-zsh works in other user, go to that user and execute:" && echo -e "\033[36mcp /usr/share/oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc \033[0m"


#rm -rf ./install.sh && wget https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh && chmod +x ./install.sh
