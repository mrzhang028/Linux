#!/bin/bash
# 一键开启 SSH 并允许 root 登录（跨 Linux 发行版）

# 检查是否 root
if [[ $EUID -ne 0 ]]; then
    echo "请使用 root 用户执行此脚本"
    exit 1
fi

# 检测 Linux 发行版
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "无法识别 Linux 发行版"
    exit 1
fi

echo "检测到系统: $OS"

# 安装 OpenSSH Server
case $OS in
    ubuntu|debian)
        apt update -y
        apt install -y openssh-server
        ;;
    centos|rhel|fedora)
        yum install -y openssh-server
        ;;
    arch)
        pacman -Sy --noconfirm openssh
        ;;
    *)
        echo "暂不支持该系统: $OS"
        exit 1
        ;;
esac

# 启动 SSH 并设置开机自启
systemctl enable ssh || systemctl enable sshd
systemctl start ssh || systemctl start sshd

# 配置 SSH 允许 root 登录
SSH_CONFIG="/etc/ssh/sshd_config"

if [ -f "$SSH_CONFIG" ]; then
    cp $SSH_CONFIG ${SSH_CONFIG}.bak
    if grep -q "^#PermitRootLogin" $SSH_CONFIG; then
        sed -i "s/#PermitRootLogin.*/PermitRootLogin yes/" $SSH_CONFIG
    elif grep -q "^PermitRootLogin" $SSH_CONFIG; then
        sed -i "s/^PermitRootLogin.*/PermitRootLogin yes/" $SSH_CONFIG
    else
        echo "PermitRootLogin yes" >> $SSH_CONFIG
    fi
else
    # 一些系统可能是 /etc/ssh/sshd_config
    echo "未找到 sshd 配置文件: $SSH_CONFIG"
    exit 1
fi

# 重启 SSH 服务
systemctl restart ssh || systemctl restart sshd

echo "SSH 已安装并启动，root 用户已允许登录"
echo "你可以通过: ssh root@服务器IP 登录"
