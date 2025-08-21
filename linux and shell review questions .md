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
## 10、在 Linux 环境的环境设置中添加 MONITORING_DIR=/opt/monitoring
`export MONITORING_DIR=/opt/monitoring`

## 11、在Linux中写一个python脚本来验证安装了requests模块

```python
#!/usr/bin/python
import requests
print("Package installation verified successfully")
```

对于 Python 脚本，应该使用 `#!/usr/bin/env python` 或 `#!/usr/bin/python`。**`#!/usr/bin/env python`**：这行代码告诉系统使用 `env` 命令来查找 Python 解释器的路径，这样可以确保脚本在不同的环境中都能找到正确的 Python 解释器。**`#!/usr/bin/python`**：这行代码直接指定了 Python 解释器的路径。这种方法在某些情况下可能会导致问题，特别是如果你的系统中安装了多个版本的 Python（如 Python 2 和 Python 3）。

在 Python 中，`import` 语句用于导入模块。当你尝试导入一个模块时，Python 会尝试在已安装的模块中找到它。如果模块存在，导入成功；如果模块不存在，Python 会抛出一个 `ImportError` 异常。因此，`import requests` 这行代码可以用来验证 `requests` 包是否已经成功安装。

## 12、shell脚本之计算器

实现以下输出：

```shell
labex:project/ $ bash arithematic.sh 1 + 5
[OUTPUT] Arithematic operation performed is " +" [OUTPUT]
[OUTPUT] Therefore 1+5=6 [OUTPUT]
```

代码

```shell
#!/bin/bash

if [ "$2" = "+" ];then
    result=$(expr $1 + $3 )
elif [ "$2" = "x" ];then
    result=$(expr $1 \* $3 )
elif [ "$2" = "-" ];then
    result=$(expr $1 - $3 ) 
elif [ "$2" = "/" ];then
    result=$(expr $1 / $3 ) 
elif [ "$2" = "%" ];then
    result=$(expr $1 % $3 ) 
fi

echo "[OUTPUT] Arithematic operation performed is $2 [OUTPUT]"
echo "[OUTPUT] Therefore $1 $2 $3= $result [OUTPUT]"
exit 0
```

## 13、bubble_sort冒泡排序

```shell
labex:project/ $ bash sort.sh 1 5 4 3 6
inputcount : 5
content of inputValue 1 5 4 3 6
[Input] Enter your choice [Input]
1.Ascending
2.Descending
2
[OUTPUT] Descending Order [OUTPUT]
6 5 4 3 1
```

```shell
#!/bin/bash

# 读取定义数组
arr=($@)
#获取数组长度
n=${#arr[@]}
echo "inputcount : $n"
echo "content of inputValue $@"
echo "[input] Enter your choice [Input] 
1.Asecnding 
2.Descending "
read input
#bubble_sort
Asecnding_bubble_sort() {
    for (( i = 0 ;i < n-1 ; i++ )); do
        for ((j = 0;j < n-i-1; j++)); do
            if [[ ${arr[j]} -gt ${arr[j+1]} ]]; then
                #交换元素
                temp=${arr[j]}
                arr[j]=${arr[j+1]}
                arr[j+1]=$temp
            fi
        done
    done
}
Descending_bubble_sort() {
    for (( i = 0 ;i < n-1 ; i++ )); do
        for ((j = 0;j < n-i-1; j++)); do
            if [[ ${arr[j]} -lt ${arr[j+1]} ]]; then
                #交换元素
                temp=${arr[j]}
                arr[j]=${arr[j+1]}
                arr[j+1]=$temp
            fi
        done
    done
}

#执行方法
case $input in
    1)
        Asecnding_bubble_sort
        sort=Asecnding
        ;;
    2)
        Descending_bubble_sort
        sort=Descending
        ;;
esac
echo "[Output] $sort Order [Output]"
echo ${arr[*]}
```

## 14、取最大数

```shell
labex:project/ $ bash compareIntegers.sh 1 4 2 3
Largest number in the integer values is: 4
```

```shell
#!/bin/bash

# 读取定义数组
arr=($@)
#获取数组长度
n=${#arr[@]}

#function
Largest_number() {
    max=${arr[1]}
    for (( i = 2 ; i < n + 1 ; i++ )); do   
        if [[ $max -lt ${arr[i]} ]]; then
            max=${arr[i]}
        fi
    done
}

#执行方法
Largest_number
echo "Largest number in the integer values is: $max"
echo $max
```

${#array[i]}获取数组 array 中索引为 i 的元素的长度。${array[i]}访问数组 array 中索引为 i 的元素。

## 15、对文档字母做大小写转换

```shell
labex:project/ $ bash stringConv.sh input_file.txt

[INPUT] Please Select an option [INPUT]
1.TO_UPPER_CASE
2.to_lower_case
2
[OUTPUT] Content of Input File AFTER OPERATION [OUTPUT]
this program takes an input_file as an input
and converts the string into upper_case
and lower_case
```

```shell
#!/bin/bash

#定义方法
TO_UPPER_CASE() {
    cat "$@" | tr '[:lower:]' '[:upper:]'
}

to_lower_case() {
    cat "$@" | tr '[:upper:]' '[:lower:]'   
}
#读取用户选择并执行方法

read -p "[INPUT] Please Select an option [INPUT]
1.TO_UPPER_CASE
2.to_lower_case
" modle

case $modle in
    1)
        echo "[OUTPUT] Content of Input File AFTER OPERATION [OUTPUT]"
        TO_UPPER_CASE "$@"
        ;;
    2)
        echo "[OUTPUT] Content of Input File AFTER OPERATION [OUTPUT]"
        to_lower_case "$@"
        ;;
esac

```

函数调用中的 `$@`

当你在脚本中调用函数时，如果需要将命令行参数传递给函数，你需要显式地使用 `$@`。这是因为函数内部的 `$@` 只能访问传递给函数的参数，而不是脚本的命令行参数。

## 16、双层for循环

**外层循环**：控制外层迭代的次数。

**内层循环**：在每次外层迭代中，控制内层迭代的次数。

使用场景

**处理二维数组**：二维数组（如矩阵）需要双层循环来遍历每个元素。`rows` 代表二维数组的行数。`cols` 代表二维数组的列数。

**嵌套迭代**：当你需要对每个元素进行多次操作时，双层循环可以提供更细粒度的控制。

**生成组合**：当你需要生成两个集合的所有组合时，双层循环可以用来遍历每个可能的组合。

要求输入数字，显示以下输出：

```shell
1
2 3
4 5 6
7 8 9 10
11 12 13 14 15
```

```shell
#!/bin/bash

#prompt the user to get the value of N and store it in the variable
echo "[INPUT]Enter  the value of N[INPUT]"
read inputN

if [ $inputN -gt 0 ]; then
  count=1
  echo "[OUTPUT]The Patter is Executed as shown below[OUTPUT]"
  for ((row = 1; row <= $inputN; row++)); do
    for ((col = 1; col <= row; col++)); do
      echo -ne "$count\t"
      count=$(($count + 1))
    done
    echo " "
  done
else
  echo "[ERROR]Invalid Input[ERROR]"
fi
```

## 17、for-in-do，数组

```shell
labex:project/ $ bash dirList.sh ~/project ~/project/dir

[OUTPUT] CONTENT OF THE DIRECTORY [OUTPUT]
project
dir
dirList.sh

[OUTPUT] CONTENT OF THE DIRECTORY [OUTPUT]
dir
a.txt
b.sh
c.bat
```

```shell
#!/bin/bash

dirs=($@)
echo ${dirs[@]}

for dir in ${dirs[@]}; do
    echo "[OUTPUT] CONTENT OF THE DIRECTORY [OUTPUT]"
    cd $dir
    echo *
done
```

