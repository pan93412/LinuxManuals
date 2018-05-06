# 1-1：如何安裝 Arch Linux？
## 說明
有些人會以為 Arch Linux 十分困難、超級難安裝、
非常恐怖，但事實沒有這麼恐怖，頂多比 Debian
的安裝程式還要複雜一點點而已。

本教學會引導你學會安裝 Arch Linux，在其中你
可以感受到安裝 Arch Linux 的自訂性與 DIY 的
成就感。

這是一本面向 Arch Linux 初心者的說明書。

## 準備
-  **有一定的電腦、Linux 基礎**
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
> 你知道 macOS 要怎麼把 ISO 刷入
USB 嗎？歡迎發 PR 補全這個部份！

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
> Tips: 跟 mkfs 很像的功能為 fsck，可以幫你檢查磁碟的錯誤與問題。

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
# 假設磁碟分割區為 /dev/sda1
mount /dev/sda1 /mnt
```
```
# 安裝基本系統，就可以進入基本系統囉！
# 普通版（不需要 Wi-Fi 的使用者）
pacstrap /mnt base base-devel
# Wi-Fi 版
pacstrap /mnt base base-devel iw dialog wpa_supplicant wpa_actiond dhcpcd netctl
# 依照你的需求，任選一個你要的指令。
# 接著告訴系統磁碟與分割區的位置
genfstab -U /mnt >/mnt/etc/fstab
# 最後進入基本系統
arch-chroot /mnt
# 開始處理基本系統吧！
```
> pacstrap 是 chroot 與 pacman 的組合。
> genfstab -U 代表告訴磁碟與分割區的方式為 UUID，UUID 比較不會發生什麼相容性問題

### 基本系統設定

### 感謝
製作者：pan93412 <pan93412@gmail.com>

**請勿刪除作者訊息，也請留下原始 Github 庫連結。**
