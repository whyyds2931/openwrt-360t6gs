# OpenWrt 360 T6GS 一键编译

基于 P3TERX/Actions-OpenWrt 模板，适配 Qihoo 360 T6GS (MT7621 + MT7915)。

## 设备信息
- 芯片：MediaTek MT7621AT
- WiFi：MediaTek MT7915 (PCIe)
- 闪存：NAND 125MB
- 网口：3 LAN + 1 WAN (千兆)

## 包含插件
- luci-app-sqm（网络拥堵优化，CAKE 算法）
- luci-app-ua3f（User-Agent 伪造）
- luci-app-srun（深澜校园网认证）
- 中文界面

## 使用方法
1. Fork 本仓库（或 Use this template）
2. 进入 Actions → Build OpenWrt → Run workflow
3. 等待 1-2 小时编译完成
4. 在 Actions 运行记录的 Artifacts 下载固件

## 固件输出
- `openwrt-ramips-mt7621-qihoo_360t6gs-squashfs-sysupgrade.bin`
- `openwrt-ramips-mt7621-qihoo_360t6gs-firmware.bin`
