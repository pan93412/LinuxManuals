# Arch Linux 個人優化
## 程式類
### 主題
- numix 主題
    - numix-gtk-theme：Numix GTK 主題
    - numix-icon-theme-git：Numix 基本圖示 *[AUR] [archlinuxcn]*
    - numix-circle-icon-theme-git：Numix 圓形圖示 *[AUR] [archlinuxcn]*

## 優化類
### 增加 archlinuxcn 軟體來源
1. 新建並打開 /etc/pacman.d/archlinuxcn
2. 於檔案增加以下幾行，並儲存。
```
# Archlinuxcn Mirror
Server = http://cdn.repo.archlinuxcn.org/$arch
```
3. 在 /etc/pacman.conf 的這個步驟
   ```
   [community]
   Include = /etc/pacman.d/mirrorlist
   ```
   底下增加
   ```
   [archlinuxcn]
   Include = /etc/pacman.d/archlinuxcn
   ```
4. 儲存後輸入 `sudo pacman -Syu` 即可

### 設定 numia 主題 *[MATE]*
1. 上方功能列 - 「系統」 - 「偏好設定」 - 「外觀與感覺」 - \
   「外觀」 - 選擇 「Numix」
2. 按下「自訂」 - 「圖示」 - 選擇「Numix Circle」 - 「關閉」