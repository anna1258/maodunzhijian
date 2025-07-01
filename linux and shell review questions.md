Shell  
练习题  
[root@684fc2081c0e35fea6d176e6 labex]#root：当前用户是 root（超级用户）。684fc2081c0e35fea6d176e6：主机名。labex：当前所在目录。#：提示符，以 # 结尾表示当前是 root 用户（普通用户是 $）
## 1、新增用户projectuser，新建jack用户设置主目录设置主要组为dev
sudo -i 直接切换到 root 的登录 shell  
useradd -m -d /projectuser projectuser 新建projectuser并设置主目录，-m会自动创建对应名字的主目录。-d为制定一个目录且-d的时候需要-m -d，不然-d只是制定没有创建。  
groupadd dev 新建dev分组  
groupdel dev 删除dev分组  
useradd -m -d /home/jack -g dev -G labex jack -s /bin/bash 新建jack用户设置主目录设置主要组为dev次要组为labex，shell为/bin/bash  
usermod -s /bin/bash jack ，usermod修改现有用户账户的属性。修改用户的登录 shell（如 -s /bin/bash）。  
usermod -aG admin jack 修改用户所属的组为 admin 。-a：append，-G：指定附加组。  
deluser jack admin 将jack从admin组中移除。  
usermod --expiredate 2025-12-31 jack，为jack设置过期时间  
Passwd projectuser 设置密码   
su - projectuser 切换用户   
exit 推出root 的shell  
  
sudo chown Alice:Bob example.txt更改example文件的属主为Alice，属组为Bob。  
## 2、gzip压缩/home目录，列出tar详情，并删除.gz压缩文件
 sudo tar cvfz home.tar.gz /home  
tar cvfz 中各参数的意义  
c：create，创建新的归档文件（archive）  
v：verbose，详细模式，显示处理的文件名  
f：file，指定归档文件的文件名（如 home.tar.gz）  
z：gzip，用 gzip 压缩归档文件  
sudo tar cvfz home.tar.gz /home，打包并压缩（gzip 格式）  
sudo tar cvf home.tar /home，只打包，不压缩  
tar -tvf home.tar.gz， 列出gzip压缩归档文件的内容  
tar xvfz home.tar.gz -C /home/labex/extracted， x（extract解包），C是change，指定解压到 /home/labex/extracted 目录下  
tar 命令不需要 root 权限，只有当你打包或解压的目标文件/目录超出你当前用户的访问权限时，才需要用 sudo 或切换到 root。  
zip同时压缩和打包，适用于Windows和linux，zip -r a.zip folder,unzip a.zip。tar用于打包归档，配合gzip、bzip2压缩，一般用于linux，tar czvf a.tar.gz folder，tar xzvf a.tar.gz  
## 3、更改target_file的所属组
chgrp group1 target_file  
## 4、显示文件中mystical出现的次数和行号
grep -c "mystical" mythical_text.txt  
grep -n "ancient" mythical_text.txt  
## 5、删除文件中的空白行
```shell
#!/bin/bash
sed -i '/^$/d' $1
```

sed 是一种流编辑器（stream editor），用于处理和转换文本数据。它的全称就是 stream editor，sed 是 “stream editor” 的缩写。sed语法 是类 Unix 系统（如 Linux）中常用的文本处理工具语法。它可以用来查找、替换、删除、插入文本行等，常见于 shell 脚本和命令行操作中。^$ 连在一起，表示从行首到行尾之间没有任何字符，也就是空行。d是 sed 的删除命令（delete）。
## 6、过滤文件中重复的内容并重定向输出
uniq input_file.txt > output_file.txt
## 7、将encrypted文件中按照'A-Za-z' 'N-ZA-Mn-za-m'的规则解密
tr 'A-Za-z' 'N-ZA-Mn-za-m' < /home/labex/project/encrypted_message.txt > /home/labex/project/decoded_message.txt
## 8、把alien_codex_part1.txt alien_codex_part2.txt按第一列内联合并，然后md5校验合并后的文件
join -j 1 alien_codex_part1.txt alien_codex_part2.txt > alien_codex_complete.txt，-j 1：指定用第1列作为连接字段（两个文件都用第1列匹配）。  
md5sum alien_codex_complete.txt > codex_checksum.txt
## 9、生成补丁文件，用于代码版本管理，提交补丁等。并将补丁应用于old_file以验证补丁
```shell
labex:project/ $ diff -uN old_file.txt new_file.txt > mysterious.patch
labex:project/ $ cat old_file.txt 
This is old content.
Please apply the patch.
labex:project/ $ cat new_file.txt 
This is old content.
This is the new content after the patch is applied.
labex:project/ $ cat mysterious.patch 
--- old_file.txt        2025-06-23 11:25:15.466512803 +0800
+++ new_file.txt        2025-06-23 11:25:15.466512803 +0800
@@ -1,2 +1,2 @@
 This is old content.
-Please apply the patch.
+This is the new content after the patch is applied.
labex:project/ $ patch -p0 < mysterious.patch
patching file old_file.txt
labex:project/ $ cat old_file.txt 
This is old content.
This is the new content after the patch is applied.
```
## 10、设置ssh公私钥

```shell
ssh-keygen -t rsa
```
`ssh-keygen`命令（用于生成密钥对）。id_rsa（私钥文件）id_rsa.pub（公钥文件）默认路径通常是 ~/.ssh/id_rsa
在有远程服务器密码或私钥的前提下，将公钥添加到远程服务器的 `~/.ssh/authorized_keys` 文件中，这样可以实现对远程服务器的ssh访问。

## 11、 netstat用法
**`netstat -tulpn`**：显示所有 TCP 和 UDP 的监听端口及其对应的进程信息。
`ss -tulpn`：`ss` 命令是 `netstat` 的现代替代品，功能更强大
**`netstat -a | grep :80`**：显示所有与端口 80 相关的网络连接。
**`netstat -tn | grep :443`**：显示所有与端口 443 相关的 TCP 网络连接。
**`-t`**：显示 TCP 端口。
**`-u`**：显示 UDP 端口。
**`-l`**：显示监听状态的端口。
**`-p`**：显示进程 ID 和进程名称。
**`-n`**：以数字形式显示 IP 地址和端口号，不进行域名解析。
**`-a`**：显示所有选项，默认不显示LISTEN相关。
**`grep :80`**：过滤出包含 `:80` 的行。
## 11、在 Linux 环境的环境设置中添加 MONITORING_DIR=/opt/monitoring
`export MONITORING_DIR=/opt/monitoring`
