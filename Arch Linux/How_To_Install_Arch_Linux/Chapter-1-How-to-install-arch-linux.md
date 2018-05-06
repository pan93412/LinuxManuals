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

## 開始安裝
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

### 感謝
製作者：pan93412 <pan93412@gmail.com>
**請勿刪除作者訊息，也請留下原始 Github 庫連結。**
