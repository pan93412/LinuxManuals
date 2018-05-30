# 如何安裝 Arch Linux？
## 說明
有些人會以為 Arch Linux 十分困難、超級難安裝、
非常恐怖，\
但事實沒有這麼恐怖，頂多比 Debian
的安裝程式還要複雜一點點而已。

本教學會引導你學會安裝 Arch Linux，在其中你\
可以感受到安裝 Arch Linux 的自訂性與 DIY 的成就感。

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
進入網址後往下滑，會看到 HTTP Direct Downloads，\
從這一堆節點裡面找一個離你地區最近的國家位址。

當你下載完成之後，接下來是將得到的 ISO 刷入隨身碟。

### 刷入 Arch Linux ISO
#### Windows
先下載 Rufus [（點這裡下載！）](https://rufus.akeo.ie)，
找到 Download 後按下去最新版 (e.g Rufus 2.18 (945 KB))

打開之後選擇好自己的裝置、選擇好 ISO 映像檔案、\
把「使用映像檔建立開機片」旁邊的「ISO 映像」改成「DD 映像」，\
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

---


## 開始安裝
當你進入 Arch Linux LiveCD 後，選擇第一個選項開機。

### 磁碟分割與配置
#### 分割磁碟
輸入 `parted` 開始分割磁碟。輸入 `help` 得知
可以使用的指令。

其實比較建議在安裝前就處理好。

#### 格式化分割區
1. 查詢自己想要格式化的分割區：`lsblk -f`
2. 格式化分割區：`mkfs.ext4 /dev/sd(磁碟編號)(分割區編號)`\
   例如 mkfs.ext4 /dev/sda1

> Tips: 跟 mkfs 名字很像的功能為 fsck，\
  可以幫你檢查磁碟的錯誤與問題。

> Tips: 也可格式化成其他檔案系統類型，\
  例如 btrfs 就是 `mkfs.btrfs`、xfs 就是 `mkfs.xfs`

#### 掛載分割區
掛載分割區至 /mnt，開始安裝系統：`mount /dev/sda2 /mnt`

如果是 UEFI 使用者，還需要掛載 EFI 開機分區。

1. 建立 /mnt/boot 資料夾，以掛載 EFI 開機分區至此處：`mkdir /mnt/boot`
2. 掛載 EFI 開機分區 (通常為 /dev/sda1)：`mount /dev/sda1 /mnt/boot`

### LiveCD 網路與時間設定
請避免使用 Wi-Fi 連線！

1. 透過 ping 主機檢查網路：`ping www.archlinux.org`，
假如 ping 失敗，重插網路線。
2. 將本機時間與網路時間對時，防止憑證過期等錯誤：`timedatectl set-ntp true`。\
檢查目前時間：`timedatectl`

### 安裝基本系統
1. 一般使用者 (包含 Wi-Fi 使用者)：`pacstrap /mnt base base-devel`
2. 假如有 Wi-Fi 硬體，且需要使用 netctl，\
需要多執行這條指令：`pacstrap /mnt iw dialog wpa_supplicant wpa_actiond dhcpcd`
3. 為系統生成 fstab，讓系統準確的知道每個分割區的位置：\
   `genfstab -U /mnt >/mnt/etc/fstab`
4. 進入基礎系統：`arch-chroot /mnt`

> pacstrap 是 chroot 與 pacman 的組合。

> genfstab -U 代表告訴磁碟與分割區的方式為 UUID，\
而 UUID 比較不會發生什麼相容性問題

### 基本系統設定
#### 切換內核到 linux-lts 與安裝微碼(建議)
1. 安裝 linux-lts：`sudo pacman -S linux-lts`
2. 安裝 Intel 的微碼：`sudo pacman -S intel-ucode`\
   安裝 AMD 的微碼：`sudo pacman -S linux-firmware`
3. 移除 linux 原核心：`sudo pacman -Rs linux`

#### 時間設定
1. 設定時區
```
# 例如台灣的時區設定檔就在 /usr/share/zoneinfo/Asia/Taiwan
# /usr/share/zoneinfo/洲/地區
ln -sf /usr/share/zoneinfo/Asia/Taiwan /etc/localtime
```
2. 將系統時間設定為 UTC：`hwclock -w --utc`

#### 語系設定
1. 開啟 /etc/locale.gen：`nano /etc/locale.gen`
2. 解除註解 (#) 以下：
```
# en_US.UTF-8 UTF-8
# zh_TW.UTF-8 UTF-8
# zh_CN.UTF-8 UTF-8
```
3. 儲存檔案 (Ctrl-O)，生成語言：`locale-gen`
4. 開啟 /etc/locale.conf：`nano /etc/locale.conf`
5. 增加以下內容，將預設語系設定為正體中文。
```
LANG=zh_TW.UTF-8
LANGUAGE=zh_TW
```

#### 主機名稱
主機名稱取名規則：可亂取、但不要取中文、也不要取有特殊\
符號的主機名稱。且建議取英文字母為第一個字！設定指令：\
`echo "想要的主機名稱" >/etc/hostname`

#### GRUB 安裝
> 假如你打算 Windows + Linux 雙系統，請多安裝 os-prober，\
待進入桌面環境後再輸入 `grub-mkconfig` 就能取得其他系統的開機項。[待測試]

BIOS + MBR 環境：
1. 安裝 GRUB 主程式：`pacman -Sy grub`
2. 安裝 GRUB 開機管理程式，假設磁碟編號為 /dev/sda\
   可以透過輸入 lsblk 找到自己的磁碟編號。\
   `grub-install /dev/sda --recheck`
3. 建立 GRUB 設定檔：`grub-mkconfig -o /boot/grub/grub.cfg`

UEFI + **GPT** 環境：
> 此方法只支援 GPT 分區！

1. 安裝 GRUB 主程式與 UEFI 開機控制系統：`pacman -Sy grub efibootmgr dosfstools`
2. 安裝 GRUB 開機管理程式：`grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub --recheck`
3. 建立 GRUB 設定檔：`grub-mkconfig -o /boot/grub/grub.cfg`

外部連結：[ArchWiki 的 GRUB 條目](https://wiki.archlinux.org/index.php/GRUB)

#### 使用者建立
1. 建立使用者：`useradd -m -s /bin/bash (使用者名稱)`\
   -m 建立 (使用者名稱) 的家目錄\
   -s 設定 (使用者名稱) 的 Shell
2. 設定使用者密碼：`passwd (使用者名稱)`
3. 加入使用者至 wheel (管理員) 群組：`gpasswd -a (使用者名稱) wheel`

#### 開放管理員 (wheel) 使用 sudo 權限
讓加入 wheel 群組的使用者能使用 sudo 這個指令。

1. 開啟 sudoers - sudo 的設定檔：`sudo nano /etc/sudoers`
2. 找到以下部份：
```
## Uncomment to allow members of group wheel to execute any command

```
3. 將 `# %wheel ALL=(ALL) ALL` 取消註解為 `%wheel ALL=(ALL) ALL` 即可。

外部連結：[ArchWiki 的 sudo 條目](https://wiki.archlinux.org/index.php/Sudo)

#### NetworkManager 安裝
> 假如你打算使用 netctl 管理網路，請跳過這個部份。
1. 安裝 NetworkManager：`sudo pacman -Sy networkmanager`
2. 啟用 NetworkManager：`sudo systemctl enable NetworkManager`
3. 移除掉 netctl 與 dhcpcd 無用元件\
   以節省系統空間：`sudo pacman -Rcnsu netctl dhcpcd`

#### 桌面環境安裝 (選用)
> xorg 是每個桌面環境的底層基礎，少了
xorg 將無法啟動桌面環境。

安裝 xorg 環境：`sudo pacman -Sy xorg`\
若使用 Intel 內顯，需多安裝這個驅動：`
sudo pacman -Sy xf86-video-intel`
> 你也可以選擇改安裝比較精簡的 `xorg-server`，
但這比較建議給進階使用者。

> 假如你是 NVIDIA 卡：
>> 如果是單 NVIDIA 顯卡，[參閱此處](https://wiki.archlinux.org/index.php/NVIDIA)\
如果是 Intel + NVIDIA 或其他，[參閱此處](https://wiki.archlinux.org/index.php/NVIDIA_Optimus)

> 假如你是 AMD (ATI) 卡：[參閱此處](https://wiki.archlinux.org/index.php/ATI)

外部連結：[ArchWiki 的 Xorg 條目](https://wiki.archlinux.org/index.php/Xorg)

##### 字體
- noto-fonts-cjk：思源黑體 (中日韓字體) (推薦)
- noto-fonts-emoji：思源黑體 (Emoji) (推薦)
- wqy-microhei
- wqy-zenhei
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
1. 安裝 fcitx 框架與 chewing 新酷音：`sudo pacman -Sy fcitx-im fcitx-chewing`
2. 假如使用 KDE，安裝 fcitx 設定工具：`sudo pacman -Sy kcm-fcitx`
3. 進入自己的使用者，以進行接下來的步驟：`su 使用者名稱`
4. 建立 ~/.pam_environment 檔案：`touch ~/.pam_environment`
5. 開啟 ~/.pam_environment 檔案：`nano ~/.pam_environment`
6. 增加下列幾行至 ~/.pam_environment
```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
```
7. 儲存檔案，輸入 exit 回到 root 使用者

> 只能使用 .pam_environment，這是英文版 ArchWiki
提供的方法。
>> .xprofile 或者其他在 KDE 或大多數桌面環境
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
- reflector：Mirror 排名工具

#### 重新開機
1. 離開 chroot：`exit`
2. 離開 LiveCD，進入你自己打造的系統吧：`reboot`

#### 接下來？
- 去看看 ArchWiki，這可以讓你受益良多。[→ 連結](https://wiki.archlinux.org)
- 看看 ArchWiki 的 [pacman 教學](https://wiki.archlinux.org/index.php/Pacman_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))。
- 大多數程式的說明文件可以透過 `man (程式名稱)` 取得，
而指令使用方式可以透過 `(程式名稱) --help` 取得。

---

### 系統最佳化
Arch Linux 比較常用的最佳化。

#### 解決關機過久的問題
1. 開啟 `/etc/systemd/system.conf` 檔案。（須 root 權限）
2. 取消註解 (#) 以下三行：
```
# ShutdownWatchdogSec=10m
# DefaultTimeoutStartSec=180s
# DefaultTimeoutStopSec=180s
```
3. 將 ShutdownWatchdogSec 改成 30s\
   DefaultTimeoutStartSec 改成 30s\
   DefaultTimeoutStopSec 改成 15s 即可。

> 可以自由設定，但建議不要設得比以上的還短。
---

### 進階使用
這不適合給剛入門 Arch 的使用者使用，\
除非你想要創造一些不一樣的體驗。

#### 啟用 testing 軟體庫
1. 打開 /etc/pacman.conf\
`sudo nano /etc/pacman.conf`
2. 移除掉以下的註解
```
# [testing]
# Include = /etc/pacman.d/mirrorlist
```

> Arch 的軟體庫還有許多，請參閱：
[Arch 的軟體庫列表](https://wiki.archlinux.org/index.php/official_repositories)

#### 把 bash 改成 zsh 吧！
1. 開啟終端
2. 安裝 zsh、git 與 curl
3. 下載 oh-my-zsh 的 sh 檔案以改善 zsh 使用體驗，
此處將下載到的檔案儲存到 `ohmyz.sh`\
`curl -L -o ohmyz.sh http://install.ohmyz.sh`
4. 執行 ohmyz.sh，開始安裝 oh-my-zsh：`sh ohmyz.sh`

進入 zsh 後，你可以把你的 zsh 佈置的更漂亮些：
1. 開啟家目錄的 .zshrc - zsh 設定檔
nano ~/.zshrc
2. 將 `ZSH_THEME="(主題名稱)"` 中的 `(主題名稱)` 改成自己想要的主題名稱。
> 可以在 oh-my-zsh 的官方 Git 庫找到許多好看的主題。\
以 agnoster 為例： `ZSH_THEME="agnoster"`
3. Ctrl - O 儲存檔案，再輸入 `zsh` 即可。


### 讓 bash 更漂亮 -- bash-it
![bash with bash-it 截圖](https://i.imgur.com/4xVJMyJ.png)
1. 下載 git
2. 複製 bash-it 的 Git 庫：\
`git clone --depth=1 http://github.com/Bash-it/bash-it ~/.bash_it`
3. 安裝 bash-it (-s 安靜安裝)：`bash ~/.bash_it/install.sh -s`
4. 測試

設定主題：

1. 查看想要套用的主題名稱：`ls ~/.bash_it/themes`
2. 打開 .bashrc (bash 設定檔)
3. 把 `export BASH_IT_THEMES='(主題名稱)'` 中的 `(主題名稱)` 改成\
自己想要的主題名稱。

假如你安裝 Powerline，還需要安裝字體。

1. 複製 powerline fonts 的 Git 庫：\
`git clone --depth=1 http://github.com/powerline/fonts ~/.plfont`
2. 安裝字體：`bash ~/.plfont/install.sh`
3. 重新開啟 bash 套用主題：`bash`

快速安裝腳本：
1. 安裝 curl
2. 執行如下指令…
```
curl -L -o bash-it.sh https://raw.githubusercontent.com/pan93412/LinuxManuals/master/ArchLinux/Extras/bash-it.sh
```
3. 以下為 bash-it.sh 的使用方式
```
# bash-it.sh 的說明
bash bash-it.sh
# 安裝 bash-it
bash bash-it.sh install
# 移除 bash-it
bash bash-it remove
```

### 讓 pacman 多點顏色
1. 開啟 pacman 設定檔：`/etc/pacman.conf`
2. 找到 # Misc options
3. 取消註解 (#) `# Color` 即可發現到 pacman 多了不少色彩

```
# 懶人指令
sudo sed -i 's/^#Color$/Color/g' /etc/pacman.conf
```

### 製作者
製作者：pan93412 <pan93412@gmail.com>

**請勿刪除作者訊息，也請留下原始 GitHub 庫連結。**

回報問題請透過 GitHub 上的 Issues。
