#!/bin/bash
# author: pan93412
# usage: bash bash-it.sh [install | remove]

function help {
    echo "      BASH IT 安裝程序"
    echo " * 安裝說明 * "
    echo " 感謝您使用本 BASH 檔案安裝 "
    echo " BASH IT！Bash it 是個 BASH"
    echo " 的社區維護的 Bash 擴充，包含了"
    echo " 主題等功能。"
    echo " 使用：$0 [install | remove]"
    echo " 作者：pan93412"
    }

function install {
    echo "      * 開始安裝 BASH IT *"
    echo "[正在進行] 正在安裝 git 與 bash ..."
    sudo pacman -Sy --needed --noconfirm git bash
    echo "[正在進行] 正在設定預設終端器…"
    sudo chsh -s /bin/bash
    echo "[正在進行] 正在下載 BASH IT ..."
    rm -rf ~/.bash_it
    git clone --depth=1 https://github.com/Bash-it/bash-it ~/.bash_it
    echo "[正在進行] 正在安裝 BASH IT ..."
    bash ~/.bash_it/install.sh -s
    echo "[即將完成] 正在設定主題至 powerline-plain ..."
    sed -i "s/^export BASH_IT_THEME='.*'/export BASH_IT_THEME='powerline'/g" ~/.bashrc
    git clone --depth=1 https://github.com/powerline/fonts.git ~/.powerline-fonts
    bash ~/.powerline-fonts/install.sh
    echo "[結束] 正在結束…"
    bash
    exit
}

function remove {
    echo "      * 開始移除 BASH IT *"
    echo "[正在進行] 正在移除 BASH IT ..."
    bash ~/.bash_it/uninstall.sh
    rm -rf ~/.bash_it
    echo "[正在進行] 正在移除主題字體 ..."
    bash ~/.powerline-fonts/uninstall.sh
    rm -rf ~/.powerline-fonts
    echo "[結束] 正在結束…"
    bash
    exit
}

case $1 in
install)
    install
    ;;
remove)
    remove
    ;;
*)
    help
    ;;
esac
