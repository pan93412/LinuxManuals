#!/bin/bash
# ZSH AUTOMATIC INSTALL for ARCH LINUX
# usage: zshinst
# AUTHOR: byStarTW

function install {
    echo "開始安裝 zsh 與 git 元件 ..."
    sudo pacman -Sy --noconfirm --needed zsh git
    echo "設定 zsh 為預設值"
    sudo chsh -s /usr/bin/zsh
    echo "開始安裝 oh-my-zsh 元件…"
    curl -L http://install.ohmyz.sh >ohmyz.sh
    sed -i 's/env zsh//g' ohmyz.sh
    bash ohmyz.sh
    echo "設定主題為 agnoster ..."
    sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="agnoster"/g' ~/.zshrc
    echo "完成。請自行重新啟動系統！"
}

install
exit
