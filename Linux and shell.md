# 基础语法
ls -l中的ls是list的缩写，用于列出目录内容。-l是long的缩写，表示以长格式显示目录内容。长格式显示会提供更多详细信息，包括文件的权限、链接数、所有者、所属组、文件大小、最后修改时间和文件名。-d 是 --directory 的缩写

pwd 是 "print working directory" 的缩写。pwd -L，-L 是 --logical 的缩写，显示逻辑路径（符号链接路径）。pwd -P，-P 是 --physical 的缩写， 显示物理路径（实际路径）

在mkdir命令中，-m选项是--mode的缩写。它用于设置新创建目录的权限（模式）。mkdir -m 700 ~/project/digital_garden，-v选项是--verbose的缩写
-R选项表示递归操作。-R是--recursive的缩写

在tree命令中，-p选项是--perms的缩写。它用于在显示目录树时，显示每个文件和目录的权限。

mkdir -p parent/child，-p 选项的 p 是 "parents" 的缩写，这个选项的作用是允许创建多级目录结构，如果上级目录不存在，它会自动创建所需的父目录。

cp new.txt old.txt。如果old不存在，那么复制new到old文件此时有两个文件，如果两个文件都存在就是覆盖操作把new的内容覆盖到old中了。-r recursive允许您递归复制目录及其内容。这对于备份整个目录结构特别有用。 -p  preserve 它保留了原始文件的修改时间、访问时间和权限。

mv new.txt old.txt 把new移动到old。如果new和old在同一目录下，那么就是重命名把new文件重命名为old。

echo "Test content" > test.txt，在test.txt中写入Test content

cd 代表“更改目录”

rm 表示永久删除且只能删除文件，如果删除一个目录需要用到递归，rm -r 

cat 是 "concatenate" 的缩写，cat sales.txt marketing.txt > combined_report.txt将sales和marketing的内容顺序写入combined_report文件中，combined_report文件以前不存在通过这个命令会新建。cat -n daily_report.txt中-n会对输出的内容进行编号。-E 会在每行的末尾显示一个$。

| 命令 | 说明                                                         |
| ---- | :----------------------------------------------------------- |
| cat  | 查看文件内容：直接输出文件全部内容到终端。<br/>合并文件：可将多个文件内容合并输出（如 cat file1.txt file2.txt）。<br/>重定向：常配合 > 或 >> 创建/追加文件（如 cat > newfile.txt）。 |
| more | 分页查看文件：逐页显示文件内容，避免终端快速滚动。<br/>基本导航：支持按 空格键 向下翻页，Enter 逐行滚动，q 退出。 |
| less | more 的功能较为基础，现代系统更推荐使用 less 命令（支持前后滚动、搜索、跳转等）。<br/>示例：less large_log.txt（按 ↑/↓ 滚动，/keyword 搜索，q 退出）。 |

whereis 命令。该命令用于定位指定命令的二进制文件、源代码和手册页文件。

find . -name "a.txt" .表示当前目录，find . -name "*.txt" -exec cat {} \; find / -perm -4000 -exec ls -l {} \; find命令主要用于查找文件或目录本身，比如文件名、大小、修改时间、权限等进行搜索，不能搜索文件内的内容，如果查找文件内部的内容，需要用到grep命令。例如：find ~/project -readable -writable， find ~/project -user labex。find ~/project -type f | wc -l统计目录下文件的数量，find . -type f -not \(-name \`*.bat\` -or -name \`*.sh\`\) -delete

which 在path中查找路径，which 命令用于查找并显示可执行文件的路径。它通常用于确定在命令行中输入的命令是从哪个路径执行的。which 命令只会查找在 PATH 环境变量中定义的目录中的可执行文件。which python。which只会在$PATH变量指定的目录中查找命令的可执行文件，whereis会找到更多相关文件，比如可执行文件，源码，手册等。

grep 是 “global regular expression print” 的缩写，用于文本搜索和筛选。grep "ERROR" logs/server.log , grep "2023-[0-9][0-9]-[0-9][0-9]" logs/server.log

wc -l requirements.txt，word count，-l 是 "line" 的缩写。统计行数

cut -d ',' -f 2 customers.txt，-d 是 delimiter 的缩写，表示字段分隔符。-f 是 field 的缩写，表示要提取的字段。

head -n +2 会输出文件中的前两行内容，tail -n +2 会输出文件中从第二行到最后一行的所有内容，tail -n 5 logs/*.log，logs下所有的log文件的最后5行。

sort文件内容排序，sort -nr反序排序，sort -k1,1 -n time_anomaly.log > sorted_time_anomaly/log，-k1,1:指定怕挨挨徐的关键字（key)，这里表示只用第1列作为排序关键字。k：指定排序的起始和终止列。1,1:从第1列到第1列，即只用第一列。-n：按照数值大小排序（numeric)。

uniq文件内容 去重，只能去除相邻的重复行，如果要对整个文件去重，通常结合sort，sort filename.txt | uniq

diff file1.txt file2.txt对比两个文件

新建一个文件写入内容方式：1、cat > newfile.txt 命令的作用是创建一个名为 newfile.txt 的新文件，并准备接受用户输入的内容。输入完成后按 Ctrl + D 来结束输入并保存内容。2、echo "This is a file in dir1" > dir1/file.txt。如果已有file.txt，那么就会覆盖原来的内容。>> dir1/file.txt是追加。3、touch file.txt：只会创建一个空文件或更新现有文件的时间戳，不会写入任何内容。touch 命令主要用于文件的创建和时间管理，而不是用于写入内容。

join用于两个文件的内联查询，join -j 1file1.txt file2.txt > file3.txt，-j 1表示指定用第一列作为连接匹配字段。

cat fruits.txt | xargs echo，cat ~/project/books.txt | xargs -I {} touch ~/project/{}.txt，xargs 获取输入并将其用作后面命令的参数

awk '{print $1}' file.txt 打印每一行的第1列（以空格或Tab为分隔符）,awk -F ' ' '{print $2" - " $4}'data.txt > file1.txt ，-F ' ' 指定以空格作为分隔符，awk -F ' ' '/sith/{print $2" - " $4}'data.txt > file1.txt，/sith/表示只处理包含sith这一字符串的行。

paste army1.txt army2.txt > merged.txt表示把两个文件的内容一一对应的合并成一行。cat army1.txt army2.txt表示只把两个文件的内容连在一起输出。

nl file1.txt 为每行前面增加行号。

top 查看系统进程，cpu，内存等信息

free 系统内存使用情况概览

df 所有已挂载文件系统的快速快照

chmod +x，这里的x是execute，chmod：change mode更改文件/目录的权限模式，sudo：superuser do以超级用户身份执行命令，chown：change owner更改文件/目录的所有者和所属组

Shell 是操作系统的“壳”，它是用户与操作系统内核（Kernel）之间的桥梁。简单来说，Shell就是一个命令解释器，用户输入命令后，Shell会翻译并传递给操作系统去执行，然后把结果返回给用户。常见的Shell有：bash（最常用）、sh、zsh、csh等。export命令的作用就是把变量变成环境变量，从而让它能被子进程继承使用，这也是shell变量和环境变量的最重要区别。shell变量只在本进程中生效，而环境变量在所有进程中生效。

sudo useradd joker，sudo passwd  joker，

/etc/passwd：存储用户基本账号信息，不含真实密码。普通用户可见，内容：用户名:密码占位符:用户ID:组ID:描述:主目录:登录Shell。/etc/shadow：存储用户的加密密码和密码相关策略，只有 root 能查看。内容：用户名:加密密码:上次修改日期:最小间隔:最大间隔:警告期:禁用期:过期日期:保留。

把用户加入 sudo 组，是为了让该用户可以用 sudo 临时获得管理员权限。

echo 是英文单词“回声”，用来输出内容。

hello.sh它告诉系统在当前的 PATH 环境变量中查找名为 hello.sh 的可执行文件。./hello.sh 是一个带路径的命令。它告诉系统在当前目录下查找名为 hello.sh 的可执行文件。./ 表示当前目录。

tar -cvf test_archive.tar test_dir，tar命令是打包，类似于把文件放在同一个箱子里。-c(create)
tar -xzvf test_combined.tar.gz -C extracted，将 test_combined.tar.gz 文件里的内容提取到新建的 extracted 目录中。-x(extract)解包
tar -tvf test_archive.tar。列出test_archive.tar下所有文件的详细信息，-t(list),-v(verbose),-f(follow)
drwxrwxr-x labex/labex       0 2025-06-10 10:04 test_dir/
man tar 是在 Linux/Unix 系统下查看 tar 命令的帮助文档的命令。
gzip test_archive.tar，test_archive.tar 会被压缩为 test_archive.tar.gz 文件。原始的 test_archive.tar 文件会被删除，仅保留压缩后的 test_archive.tar.gz 文件。
zip -r test_archive.zip test_dir和zip  test_archive.zip test_dir的区别，后面只压缩目录，-r（recursive）会把目录下所有文件压缩。unzip -d unzipped_files test_archive.zip，unzip解压。-d(directory)

df，diskfree，df -h /dev，du ~，diskusage，df 用来看磁盘整体空间，du 用来看某个目录或文件的空间。

虚拟磁盘virtual disk，又称虚拟硬盘，是通过软件技术在物理存储设备之上抽象出来的逻辑存储设备。它表现为一个标准的磁盘设备，具有分区、格式化、挂载等全部磁盘操作能力，但其底层数据可以存储于文件、内存、网络或其他物理介质。虚拟磁盘是用软件方法在物理存储之上模拟出来的磁盘设备，比如磁盘镜像文件（.img、.vhd）、LVM逻辑卷、RAM Disk、网络块设备等。

操作系统把虚拟磁盘当作真实磁盘对待，可以进行分区、格式化、挂载等所有操作。

文件系统 ：将文件系统视为文件和文件夹在磁盘上的组织方式。它就像办公室中的归档系统 - 它决定了数据的存储和检索方式。常见的 Linux 文件系统包括 ext4（我们将使用）、XFS 和 btrfs。

挂载 ：挂载是使作系统可以访问文件系统的过程。当你挂载一个文件系统时，你是在告诉 Linux “使这个磁盘的内容在这个特定目录中可用”。

分区 ：分区是磁盘中被视为单独单元的部分。可以将其视为将一个大硬盘驱动器划分为更小的独立部分。分区是指把一块物理磁盘（如 /dev/nvme0n1）或虚拟磁盘划分成若干个逻辑区域，每个分区可以单独格式化、挂载和管理。分区让一个磁盘可以被操作系统识别为多个“逻辑磁盘”，比如 /dev/nvme0n1p1、/dev/nvme0n1p2 等。
创建使用虚拟磁盘：创建一个1GB的空镜像文件：dd if=/dev/zero of=virtual.img bs=1M count=256，格式化为 ext4 文件系统：sudo mkfs.ext4 virtual.img，新建/mnt/virtualdisk目录文件作为挂载点：sudo mkdir /mnt/virtualdisk，进行挂载：sudo mount -o loop virtual.img /mnt/virtualdisk，卸载虚拟磁盘：sudo umount /mnt/virtualdisk

which cowsay && cowsay "Hello, LabEx" || echo "cowsay is not installed"，&& 是一个逻辑 AND 运算符，只有在前一个命令成功时才执行下一个命令。|| 是一个逻辑 OR 运算符，仅当上一个命令失败时，它才执行下一个命令。

grep "PATH" ~/.zshrc | grep "HOME"只查找同时包含 "PATH" 和 "HOME" 的行。grep "PATH" ~/.zshrc && grep "HOME" ~/.zshrc查找包含 "PATH" 的行然后查找包含 "HOME" 的行。

tr translate命令用于字符转换、删除和压缩，只能处理标准输入，不能直接处理文件，需配合重定向或管道使用。只支持字符级别操作，不支持正则表达式。

realpath path_analysis.sh，顾名思义，查看一个文件的绝对路径。

Bash 脚本：:在终端中，使用 bash script.sh 或 ./script.sh（需要先给脚本可执行权限，chmod +x script.sh）。PowerShell 脚本：:在PowerShell 中，使用 .\script.ps1 或 C:\Path\To\Script\script.ps1。Python 脚本：:在终端中，使用 python script.py

重定向：echo 'hello labex' > redirect，> 符号将此输出重定向到名为 redirect 的文件。如果文件不存在，则将创建该文件。如果它已存在，则其内容将被覆盖。echo 'labex.io' >> redirect，>> 运算符类似于 >，但它不是覆盖文件，而是将新内容附加到现有文件的末尾。

| 语法                       | 是否支持多行 | 行为说明                            |
| -------------------------- | ------------ | ----------------------------------- |
| cat > 文件 << EOF ... EOF  | 支持多行     | 多行内容原样写入文件                |
| echo > 文件 << EOF ... EOF | 不支持多行   | 通常只写入空行或EOF，不适合多行写入 |

常见的重定向方式有输入重定向、输出重定向和错误重定向。

| 类型与解释                                                   | 命令                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| 输出重定向：覆盖写入（>）将命令的输出写入到指定文件，如果文件已存在，则会覆盖原内容。 | echo "hello world" > file.txt                                |
| 追加写入（>>）将命令的输出追加到指定文件末尾，不会覆盖原有内容。 | echo "hello again" >> file.txt                               |
| 输入重定向：标准输入重定向（<）将文件的内容作为命令的输入。  | wc -l < file.txt   # 统计 file.txt 的行数                    |
| 错误输出重定向：错误输出覆盖写入（2>）将命令的错误信息写入到指定文件（覆盖方式）。 | ls not_exist_file 2> error.log                               |
| 错误输出追加写入（2>>）将错误信息追加到文件末尾。            | ls not_exist_file 2>> error.log                              |
| 标准输出和错误输出同时重定向：标准输出和错误输出都写入同一个文件 | command > all.log 2>&1<br/>  或者<br/>command &> all.log<br>注意：2>&1 表示将标准错误（文件描述符2）重定向到标准输出（文件描述符1）的位置。 |
| Here Document（多行输入重定向）：用于将多行内容输入到命令或文件中。 | cat > file.txt << EOF<br/>line 1<br/>line 2<br/>EOF          |

ls -l > /dev/null：只丢弃正常输出，错误信息仍会显示。
ls -l nonexistent_directory > /dev/null 2>&1：所有输出（包括错误）都丢弃，终端不会有任何显示。
Standard Input (stdin)，这是默认输入源，通常是你的键盘。这是系统期望输入的来源。一般就是stdin。Standard Output (stdout):这是默认输出目标，通常是您的屏幕。这是系统发送正常输出的地方。Standard Error (stderr)：这是发送错误消息的地方，通常也是您的屏幕。一般stdout和stderr是一起出现的，两个都需要进行处理。

/dev/null，通常称为“位桶”或“黑洞”，是一个特殊文件，它会丢弃写入它的所有数据。一般可以使用 /dev/null 快速清除文件内容：cat /dev/null > combined_output.log

更新软件：sudo apt update更新包列表。sudo apt install w3m -y，在安装过程中自动对任何提示回答 “yes”。apt-cache search "text editor"在软件包描述中搜索单词 “text” 和 “editor”，sudo apt remove w3m -y，sudo apt purge w3m -y配置文件一同删除，sudo apt autoremove -y此命令将删除自动安装的包，以满足其他包的依赖关系，现在不再需要这些包。

/etc/passwd下内容：root:x:0:0:root:/root:/bin/bash
root：用户名（login name），这里是超级用户 root
 x：口令字段。x 表示密码存储在 /etc/shadow 文件中
 0 ： 用户ID（UID），0 代表 root 用户
0 ：组ID（GID），0 代表 root 组
root：用户全名或描述信息
/root ：用户主目录（home directory）
/bin/bash：用户登录后默认使用的 shell 程序

创建硬链接：ln 源文件 目标文件，创建软链接：ln -s 源文件 目标文件。ln -f 源文件 目标文件 -f 表示目标链接如已存在，先删除再创建。

readlink 链接

| 区别           | 硬链接（Hard Link） | 软连接（Soft Link/符号链接） |
| -------------- | ------------------- | ---------------------------- |
| 指向           | 同一个inode         | 目标文件路径                 |
| 是否可跨分区   | 否                  | 是                           |
| 是否可指向目录 | 否                  | 是                           |
| 删除原文件影响 | 不影响其他硬链接    | 软链接失效（变为死链接）     |
| 创建命令       | ln 源文件 目标文件  | ln -s 源文件 目标文件        |
| inode 关系     | 共享inode           | 有独立inode                  |

ps只显示当前终端下属于当前用户的进程，ps aux显示系统中所有用户的所有进程（无终端也显示），USER：进程所有者，PID：进程ID，%CPU：CPU使用率，%MEM：内存使用率，VSZ：虚拟内存集大小，RSS：常驻内存集大小，TTY：终端类型，STAT：进程状态，START：进程启动时间，TIME：进程占用CPU时间，COMMAND：启动命令。ps -e --foresr以树状结构展示进程之间的父子关系，便于观察进程的层级和归属。



# shell

#!/usr/bin/python3
#!/bin/bash
#!/解释器的路径
shebang 这个名字其实是英文单词 sharp（#号的非正式叫法）和 bang（感叹号的俚语）的组合。

bash hello.sh，不需要执行权限（x），需要读权限（r），由 Bash 解释器读取并执行脚本内容
./hello.sh，需要执行权限（x），需要读权限（r），由操作系统直接执行，必须有执行权限
~/project/hello.sh ，需要执行权限（x），需要读权限（r）           

shell中的${}和$
NAME="world"
echo "hello $NAME123"    # 输出 hello 
echo "hello ${NAME}123"  # 输出 hello world123

## 字符串与shell变量

定义变量（等号两边不能有空格）：NAME="honor"，AGE=20
引用变量： echo $NAME，echo ${AGE}
只读变量： readonly NAME
删除变量：unset AGE

## 字符串操作

字符串长度：
  STRING="hello"
echo ${#STRING}      # 输出 5
子串截取：
  STRING="hello world"
echo ${STRING:0:5}   # 输出 hello
查找子串位置：
  expr index "$STRING" o    # 返回 o 第一次出现的位置
字符串替换：
  STRING="hello world"
echo ${STRING/world/bash}     # hello bash
echo ${STRING//l/x}           # hexxo worxd（全部替换）
删除子串：
  STRING="abcABC123ABCabc"
echo ${STRING#a*C}   # 删除第一次a到C之间的内容及本身，输出123ABCabc
echo ${STRING##a*C}  # 删除最后一次a到C之间的内容及本身，输出abc
拼接字符串：
  STR1="hello"
STR2="world"
STR3="$STR1 $STR2"
echo $STR3

## 数组操作

定义数组：
  ARRAY=(apple banana cherry)
访问元素：
  echo ${ARRAY[0]}     # apple
echo ${ARRAY[1]}     # banana
获取所有元素：
  echo ${ARRAY[@]}     # apple banana cherry
echo ${ARRAY[*]}     # apple banana cherry
获取数组长度：
  echo ${#ARRAY[@]}    # 3
遍历数组：
  for ITEM in "${ARRAY[@]}"; do
 echo $ITEM
done
添加元素：
  ARRAY+=(date)
删除元素：
  unset ARRAY[1]    # 删除第二个元素

## 其他常见用法

变量默认值：
  echo ${VAR:-default}  # 如果VAR为空，则输出default
变量赋值默认值：
  echo ${VAR:=default}  # 如果VAR为空，则赋值为default，并输出
判断变量是否存在：

```shell
  if [ -z "$VAR" ]; then
    echo "VAR is empty"
fi
```

$(( ... )) 是算术运算并返回结果；(( ... )) 是只做运算，不返回结果（通常用于条件判断）。

## if-else语法

```shell
#!/bin/bash

echo "Enter the current temperature in Celsius: $temp"
read temp
if [ "$temp" -lt "0" ];then
    echo "It's freezing! Wear a heavy coat and gloves."
elif [ "$temp" -gt "0" ] && [ "$temp" -lt "10" ];then
    echo "It's cold. A warm jacket is recommended."
elif [ "$temp" -gt "10" ] && [ "$temp" -lt "20" ];then
    echo "It's cool. A light jacket should suffice."
else 
    echo "It's warm. Enjoy the pleasant weather!"
fi
```
-lt: less than 小于
-eq: equal to  等于
-gt: greater than大于
-le: less than or equal to小于或等于
-ge: greater than or equal to大于或等于
-ne: not equal to不等于
-z：检查字符串是否为空，如果字符串为空（长度为零），则为 true。

## for-in-done语法

```shell
#!/bin/bash

echo "Looping through an array:"
NAMES=("Alice" "Bob" "Charlie" "David")
for name in "${NAMES[@]}"; do
  echo "Hello, $name!"
done

echo # Print an empty line for readability
#Loop through a range of numbers
echo "Looping through a range of numbers:"
for i in {1..5}; do
  echo "Number: $i"
done
```

## while-do-done语法

```shell
#!/bin/bash

count=5
echo "Countdown:"
while [ $count -gt 0 ]; do
  echo $count
  count=$((count - 1))
  sleep 1 # Wait for 1 second
done
echo "Blast off!"
```

```shell
#!/bin/bash

count=1
echo "Counting up to 5:"
until [ $count -gt 5 ]; do
  echo $count
  count=$((count + 1))
  sleep 1 # Wait for 1 second
done
```

```shell
#!/bin/bash

echo "Demonstration of break:"
for i in {1..10}; do
  if [ $i -eq 6 ]; then
    echo "Breaking the loop at $i"
    break
  fi
  echo $i
done
#下面会输出一个空行，echo中的#后面部分为注释，不会执行。
echo # Print an empty line for readability 

#Using continue to skip iterations
echo "Demonstration of continue (printing odd numbers):"
for i in {1..10}; do
  if [ $((i % 2)) -eq 0 ]; then
    continue
  fi
  echo $i
done
```

## Shell Function（shell函数）

```shell
#!/bin/bash

greet() {
  echo "Hello, $1!"
}

calculate() {
  echo "The sum of $1 and $2 is $(($1 + $2))"
}

greet "Alice"
calculate 5 3
```

```shell
#!/bin/bash

ENGLISH_CALC() {
  local num1=$1
  local operation=$2
  local num2=$3
  local result

  case $operation in
    plus)
      result=$((num1 + num2))
      echo "$num1 + $num2 = $result"
      ;;
    minus)
      result=$((num1 - num2))
      echo "$num1 - $num2 = $result"
      ;;
    times)
      result=$((num1 * num2))
      echo "$num1 * $num2 = $result"
      ;;
    *)
      echo "Invalid operation. Please use 'plus', 'minus', or 'times'."
      return 1
      ;;
  esac
}
#Test the function
ENGLISH_CALC 3 plus 5
ENGLISH_CALC 5 minus 1
ENGLISH_CALC 4 times 6
ENGLISH_CALC 2 divide 2 # This should show an error message
```

## shell中的特殊变量

$0：此特殊变量保存脚本的名称。$1 和 $2：分别表示第一个和第二个命令行参数。$@：这表示传递给脚本的所有命令行参数。$#：这给出了命令行参数的计数。$$：这提供了当前 shell 的进程 ID。$？ 给出最后执行的命令的退出状态。0 通常表示成功，而非零值表示各种错误情况。$！ 提供最后一个后台命令的进程 ID。命令末尾的 & 在后台运行它。

| 写法 | 传递的参数         | 举例（参数 a "b c" d） | 实际效果 |
| ---- | ------------------ | ---------------------- | -------- |
| $@   | 所有参数，空格分隔 | a b c d                | 4 个参数 |
| $*   | 所有参数，空格分隔 | a b c d                | 4 个参数 |
| "$@" | 每个参数独立       | "a" "b c" "d"          | 3 个参数 |
| "$*" | 所有参数合成一个   | "a b c d"              | 1 个参数 |

trap cleanup_and_exit SIGINT SIGTERM
解释：trap：这是 Bash Shell 的一个内置命令，用于指定在接收到某些信号时要执行的命令。cleanup_and_exit：这是当接收到信号时将要执行的命令（通常是一个函数名，也可以是具体的命令）。比如你可以定义一个函数 cleanup_and_exit 来做清理工作和安全退出。SIGINT 和 SIGTERM：这两个是信号名。SIGINT：中断信号，通常是用户按下 Ctrl+C 时发出的信号。SIGTERM：终止信号，通常用于请求程序终止（不是强制终止，程序可以捕获这个信号并做善后处理）。

exit 0：表示成功，正常退出。exit 1：表示失败，异常退出。如果你需要检测脚本运行结果，可以通过 $? 获取上一条命令的退出码。例如：./your_script.sh    echo $?

