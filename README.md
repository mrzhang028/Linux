直接下载脚本
# Debian/Ubuntu
sudo apt update -y && sudo apt install -y curl
# CentOS/RHEL
sudo yum install -y curl

# 下载并执行
curl -O https://raw.githubusercontent.com/你的用户名/enable-ssh/main/enable_ssh.sh
chmod +x enable_ssh.sh
sudo ./enable_ssh.sh


或者用一行命令直接执行（推荐测试环境用，风险自负）：

sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/你的用户名/enable-ssh/main/enable_ssh.sh)"
