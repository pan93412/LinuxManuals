# 如何安裝 Arch Linux？
## 說明
有些人會以為 Arch Linux 十分困難、超級難安裝、
非常恐怖，但事實沒有這麼恐怖，頂多比 Debian
的安裝程式還要複雜一點點而已。

本教學會引導你學會安裝 Arch Linux，在其中你
可以感受到安裝 Arch Linux 的自訂性與 DIY 的
成就感。

這是一本面向 Arch Linux 初心者的安裝說明書。

## 準備
-  **有一定的電腦、Linux 基礎**
  - 有一定的英文基礎，看 ArchWiki 必須！
- Arch Linux 映像檔案
  - [**64 位元（大多數電腦的架構）**](https://www.archlinux.org/download/)
  - [32 位元](https://www.archlinux32.org/download/)
- 一隻 **至少有 1GB 的隨身碟** 、SD 卡或者是其他可開機裝置

## ISO 準備
### 下載 Arch Linux ISO
進入網址後往下滑，會看到 HTTP Direct Downloads，
從這一堆節點裡面找一個離你地區最近的國家位址。

當你下載完成之後，接下來是將得到的 ISO 刷入隨身碟。

### 刷入 Arch Linux ISO
#### Windows
先下載 Rufus [（點這裡下載！！！）](https://rufus.akeo.ie)，
找到 Download 後按下去最新版 (e.g Rufus 2.18 (945 KB))

打開之後選擇好自己的裝置、選擇好 ISO 映像檔案、
把「使用映像檔建立開機片」旁邊的「ISO 映像」改成「DD 映像」，
之後即可按下「開始」刷入 Arch Linux ISO。
> DD 映像比較快、也比較能保證自己的安裝隨身碟是完整的。

#### Linux
使用 DD 指令即可。
```
# 先使用 lsblk 確定自己的 USB 位置
lsblk
# 再使用 dd 指令刷入 USB 的磁碟區（不是分割區，通常只有三碼 - e.g sda, sdc ...）
dd if=ISO 位置 of=/dev/USB 磁碟區 bs=4M
```

#### macOS
使用 DD 指令即可。
```
# 先使用 lsblk 確定自己的 USB 位置
lsblk
# 再使用 dd 指令刷入 USB 的磁碟區（不是分割區，通常只有三碼 - e.g sda, sdc ...）
dd if=ISO 位置 of=/dev/USB 磁碟區 bs=4M
```

## 開始安裝
當你進入 Arch Linux LiveCD 後，選擇第一個選項開機。

### 磁碟分割與配置
#### 分割磁碟
輸入 `parted` 開始分割磁碟。輸入 `help` 得知
可以使用的指令。

其實比較建議在安裝前就處理好。

#### 格式化磁碟
先輸入 `lsblk -f` 查詢自己要格式化的磁碟，
再輸入 `mkfs.ext4 /dev/(磁碟)` 來格式化磁碟。
> Tips: 跟 mkfs 名字很像的功能為 fsck，
可以幫你檢查磁碟的錯誤與問題。

### LiveCD 網路與時間設定
```
# 檢查你網路的最好方法就是 ping 一台主機。
ping www.google.com
# 如果 ping 不通，重插網路線
# 避免使用 Wi-Fi 連線。
```
```
# 接著把目前的時間與網路對時，防止憑證等等的錯誤。
timedatectl set-ntp true
# 看看現在的時間是否正確
timedatectl
```
```
# 掛載分割區到 /mnt，這樣才能進行接下來的步驟
# /mnt 是系統預留給你掛載分割區用的路徑。
# 假設磁碟分割區為 /dev/sda2
mount /dev/sda2 /mnt
# UEFI 使用者請繼續執行下面的步驟：
# 建立 /mnt/boot 資料夾以掛載 UEFI 開機分區
mkdir /mnt/boot
# 掛載 UEFI 開機分區 (通常為 /dev/sda1)
mount /dev/sda1 /mnt/boot
```
```
# 安裝基本系統，就可以進入基本系統囉！
# 普通版（不需要 Wi-Fi 的使用者）
pacstrap /mnt base base-devel
# Wi-Fi 版
pacstrap /mnt base base-devel iw dialog wpa_supplicant wpa_actiond dhcpcd
# 依照你的需求，任選一個你要的指令。
# 接著告訴系統磁碟與分割區的位置
genfstab -U /mnt >/mnt/etc/fstab
# 最後進入基本系統
arch-chroot /mnt
# 開始處理基本系統吧！
```
> pacstrap 是 chroot 與 pacman 的組合。

> genfstab -U 代表告訴磁碟與分割區的方式為 UUID，而 UUID 比較不會發生什麼相容性問題

### 基本系統設定
#### 時間設定
```
# 設定時區
# 例如台灣的時區設定檔就在 /usr/share/zoneinfo/Asia/Taiwan
# /usr/share/zoneinfo/洲/地區
ln -sf /usr/share/zoneinfo/Asia/Taiwan /etc/localtime
# 將系統時間設定為 UTC
hwclock -w --utc
```

#### 語系設定
```
# 打開 /etc/locale.gen
nano /etc/locale.gen
# 解除註解以下：
# en_US.UTF-8 UTF-8
# zh_TW.UTF-8 UTF-8
# zh_CN.UTF-8 UTF-8
# 儲存後執行以下指令
locale-gen
```
```
# 輸入以下指令，將預設語系設定為正體中文。
echo 'LANG=zh_TW.UTF-8'>/etc/locale.conf
echo 'LANGUAGE=zh_TW'>/etc/locale.conf
```

#### 主機名稱
```
# 主機名稱可以亂取，但是不要取中文與有特殊符號
# 的主機名稱。建議取英文字母為第一個字。
echo "想要的主機名稱" >/etc/hostname
```

#### GRUB 安裝
> 假如你打算 Windows + Linux 雙系統，請多安裝
os-prober，並且掛載要加入 GRUB 開機選項的
磁碟區。（尚未完成 #TODO）

BIOS + MBR 環境：
```
# 安裝 GRUB 主程式
pacman -Sy grub
# 安裝 GRUB 開機管理程式
# 假設磁碟編號為 /dev/sda
# 可透過查詢 lsblk 找到自己的磁碟編號
grub-install /dev/sda --recheck
# 建立 GRUB 設定檔
grub-mkconfig -o /boot/grub/grub.cfg
```

UEFI + **GPT** 環境：

> 此方法只支援 GPT 分區！

```
# 安裝 GRUB 主程式，與 UEFI 所需工具。
pacman -Sy grub efibootmgr dosfstools
# 安裝 GRUB 開機管理程式
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck
# 建立 GRUB 設定檔
grub-mkconfig -o /boot/grub/grub.cfg
```

外部連結：[ArchWiki 的 GRUB 條目](https://wiki.archlinux.org/index.php/GRUB)

#### 建立使用者
```
# 建立使用者
useradd -m -s /bin/bash 使用者名稱
# 設定使用者密碼
passwd 使用者名稱
```

#### 設定使用者的 sudo 權限
```
# 開啟 sudoers - sudo 的設定檔
sudo nano /etc/sudoers
# 找到這個部份
##
## User privilege specification
##
# 在 root ALL=(ALL) ALL 後面增加
# 使用者名稱 ALL=(ALL) ALL
```

外部連結：[ArchWiki 的 sudo 條目](https://wiki.archlinux.org/index.php/Sudo)

#### NetworkManager 安裝 (選用)
> 選用，使用有線網路者可以不用安裝，使用
Wi-Fi 網路者建議安裝（除非你會設定 netctl）
```
# 安裝 NetworkManager
sudo pacman -Sy networkmanager
# 啟用 NetworkManager
sudo systemctl enable NetworkManager
```

#### 桌面環境安裝 (選用)
> xorg 是每個桌面環境的底層基礎，少了
xorg 將無法啟動桌面環境。

```
# 首先必須安裝 xorg 環境
sudo pacman -Sy xorg
# 若使用 Intel 內顯，需多安裝這個驅動
sudo pacman -Sy xf86-video-intel
```
> 你也可以選擇改安裝比較精簡的 `xorg-server`，
但這比較建議給進階使用者。

> 假如你是 Nvidia 卡：如果是單 Nvidia 顯卡，[參閱此處](https://wiki.archlinux.org/index.php/NVIDIA)；
如果是 Intel + Nvidia 或其他，[參閱此處](https://wiki.archlinux.org/index.php/NVIDIA_Optimus)

> 假如你是 AMD (ATI) 卡：[參閱此處](https://wiki.archlinux.org/index.php/ATI)

外部連結：[ArchWiki 的 Xorg 條目](https://wiki.archlinux.org/index.php/Xorg)

##### KDE
```
# 安裝 plasma（KDE 底層框架）與 kde-applications、sddm（KDE 推薦的登入管理器）
sudo pacman -Sy plasma kde-applications sddm
# 啟用 sddm 登入管理器
sudo systemctl enable sddm
```
> kde-applications 是 KDE 的所有軟體，如果
你懂 KDE 每個程式的用途，你可以選擇手動選擇安裝。

外部連結：[ArchWiki 的 KDE 條目](https://wiki.archlinux.org/index.php/KDE)

#### 安裝輸入法
##### fcitx
```
# 此處安裝 chewing 新酷音
sudo pacman -Sy fcitx-im fcitx-chewing
# 進入自己的使用者，以進行接下來的步驟
su 使用者名稱
# 讓系統辨識到 fcitx 輸入法
echo "GTK_IM_MODULE=fcitx">~/.pam_environment
echo "QT_IM_MODULE=fcitx">>~/.pam_environment
echo "XMODIFIERS=@im=fcitx">>~/.pam_environment
exit
```
> 只能使用 .pam_environment，這是英文版 ArchWiki
提供的方法。.xprofile 或者其他在 KDE 或大多數桌面環境
可能不起作用。

> 請安裝 fcitx-im，不要單獨安裝 fcitx，因為 fcitx-im 
包含了給 GTK 與 QT 的輸入法 lib。

外部連結：[ArchWiki 的 fcitx 條目](https://wiki.archlinux.org/index.php/Fcitx)

#### 安裝常用軟體 (選用)
- ntfs-3g：讀取與寫入 NTFS 格式的磁碟
- firefox：Firefox 網頁瀏覽器
  - firefox-i18n-zh-tw：Firefox 正體中文語系包
- chromium：Chrome 的開源版本 - Chromium
- htop：系統監視器
  - 可以用終端器直接看到系統目前的狀況。

#### 重新開機
```
# 離開 chroot
exit
# 離開 LiveCD，進入你自己打造的系統吧！
reboot
```

#### 接下來？
- 去看看 ArchWiki，這可以讓你受益良多。[→ 連結](https://wiki.archlinux.org)
- 看看 ArchWiki 的 [pacman 教學](https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。
- 大多數程式的說明文件可以透過 `man (程式名稱)` 取得，
而指令使用方式可以透過 `(程式名稱) --help` 取得。

### 進階使用
這不適合給剛入門 Arch 的使用者使用，
除非你想要創造一些不一樣的體驗。

#### 啟用 testing 與 kde-unstable 軟體庫
```
# 打開 /etc/pacman.conf
sudo nano /etc/pacman.conf
# 移除掉以下的註解：
# [testing]
# Include = /etc/pacman.d/mirrorlist
```
```
# 增加 kde-unstable 軟體庫
[testing]
Include = /etc/pacman.d/mirrorlist
# 的上面增加： (空一行)
[kde-unstable]
Include = /etc/pacman.d/mirrorlist
# 結果應為：
[kde-unstable]
Include = /etc/pacman.d/mirrorlist

[testing]
Include = /etc/pacman.d/mirrorlist
```
> Arch 的軟體庫當然不只這些，請參閱：
[Arch 的軟體庫列表](https://wiki.archlinux.org/index.php/official_repositories)

#### 把 bash 改成 zsh 吧！
```
# 進入你的使用者
su (使用者名稱)
# 首先安裝 zsh 與 git、curl
sudo pacman -S zsh git curl
# 接著下載 oh-my-zsh 的 sh 檔案
# 這可以改善 zsh 的使用體驗
# 這裡先把下載到的檔案儲存到 ohmyz.sh
curl -L http://install.ohmyz.sh >ohmyz.sh
# 接著執行剛下載的 ohmyz.sh，
# 開始安裝 oh-my-zsh 吧！
sh ohmyz.sh
# 到這裡你應該進入 zsh 了，
# 而接下來我們來把 zsh 弄漂亮點：
# 打開 .zshrc (zsh 的設定檔)
# Tips: ~/ 指家目錄
nano ~/.zshrc
# 編輯這行
ZSH_THEME="(主題名稱)"
# 上面的備註已經告訴你，你可以從
# oh-my-zsh 的官方 Git 庫找到
# 許多好看的主題，而我自己比較喜歡 agnoster.
ZSH_THEME="agnoster"
# 儲存！
# 離開 zsh
exit
# 回到 chroot
exit
```

### 讓 bash 更漂亮 -- bash-it
![bash with bash-it 截圖](https://i.imgur.com/4xVJMyJ.png)
```
# 登入自己的使用者
su (使用者名稱)
# 首先下載 git
sudo pacman -S git
# 然後複製 bash-it 的軟體庫
git clone --depth=1 http://github.com/Bash-it/bash-it ~/.bash_it
# 安裝 bash-it
# -s (silent) 不提示安裝模式
bash ~/.bash_it/install.sh -s
# 測試吧！
bash

# 我自己還蠻喜歡 powerline 這個主題，那就來設定吧！
# 主題列表
ls ~/.bash_it/themes
# 設定主題
nano .bashrc
# export BASH_IT_THEMES='主題名稱'
# 設定成 powerline 後，還需要下載字體。
# 複製 powerline fonts 軟體庫
git clone --depth=1 http://github.com/powerline/fonts ~/.plfont
# 安裝字體
bash ~/.plfont/install.sh
# 看看新主題吧！
bash
```

```
# 懶人指令
# 需先安裝 curl！
pacman -S curl
# 然後執行以下指令～
curl -L https://raw.githubusercontent.com/pan93412/LinuxManuals/master/ArchLinux/Extras/bash-it.sh >bash-it.sh
# 這樣你就可以下載到 bash-it.sh，看看 bash-it.sh 的說明吧！
bash bash-it.sh
# 安裝 bash-it
bash bash-it.sh install
# 移除 bash-it
bash bash-it remove
```

### 讓 pacman 多點顏色
```
# 開啟 pacman 設定檔案
sudo nano /etc/pacman.conf
# 找到 # Misc options
# 將下面的
# Color
# 改成
Color
# 儲存後就可以看到 pacman 多了不少顏色。
```

```
# 懶人指令
sudo sed -i 's/^#Color$/Color/g' /etc/pacman.conf
```

### 製作者
製作者：pan93412 <pan93412@gmail.com>

**請勿刪除作者訊息，也請留下原始 Github 庫連結。**

回報問題請透過 Github 上的 Issues。
