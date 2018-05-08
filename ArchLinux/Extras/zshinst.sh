#!/bin/bash
# ZSH AUTOMATIC INSTALL for ARCH LINUX
# usage: zshinst [--help] (--no-themes)
# AUTHOR: byStarTW

function install {
    echo "開始安裝 zsh 與 git、curl 元件 ..."
    sudo pacman -Sy --noconfirm --needed zsh git curl
    echo "開始安裝 oh-my-zsh 元件…"
    curl -L http://install.ohmyz.sh >ohmyz.sh
    sed -i 's/env zsh//g' ohmyz.sh
    bash ohmyz.sh
    if [ ! "$1" == "--no-themes" ]; then
        echo "設定主題為 agnoster ..."
        sed -i 's/^ZSH_THEME=".*"/ZSH_THEME="agnoster"/g' ~/.zshrc
    fi
    echo "完成。"
}

function usage1 {
    echo "可用指令：zshinst [--help] (--no-themes)"
    echo "zshinst 直接執行就是安裝 zsh。"
    echo "增加 --no-themes 則不將主題設定為 agnoster"
    echo "--help：說明"
}

if [ "$1" == "--help" ]; then
    usage1
    exit
fi

install $1
exit
