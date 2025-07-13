# 本地创建目录并初始化

cd ~/project 

mkdir git-staging-lab 

cd git-staging-lab

git init

# 本地基础配置

git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

**目的**：设置全局的用户名。

**作用**：当你提交代码时，Git 会记录这个用户名作为提交的作者。这个信息会显示在提交历史中，帮助你和其他人识别是谁提交了代码。

如果配置时没有global，那么当前仓库的 `.git/config` 文件中设置用户信息，而不是全局配置文件中。

如果配置了global，那么配置信息存储在用户的主目录中的 `.gitconfig` 文件中（Windows 系统中通常是 `C:\Users\username\.gitconfig`）。

git config --global http.proxy 127.0.0.1:10809设置代理

git config --global --unset http.proxy 取消代理

git config --global --get http.proxy 查看代理

git config --global help.autocorrect 1 开启自动更正命令，很好用，有必要设置。

git config --global core.editor "vim" 设置默认的编辑器为vim。

# 本地查看编辑配置

git config --global --list

git config --local --list

git config --global --get user.name

git config --global -e  编辑配置

git config --global push.default current

`push.default` 的可能值

- **`nothing`**：不推送任何分支。
- **`matching`**：推送所有匹配的分支（默认行为，但不推荐）。
- **`current`**：仅推送当前分支到远程仓库的同名分支。
- **`upstream`**：推送当前分支到其上游分支（即跟踪的远程分支）。
- **`simple`**：如果当前分支有上游分支，则推送当前分支到其上游分支；否则，推送当前分支到远程仓库的同名分支（推荐）

# 本地仓常见用法add、commit、diff

echo "hello git" > hello.txt  新增文件

git add hello.txt 放到缓存区

git status 查看可提交文件

git diff --staged 查看缓存区的文件变化

git commit -m "Initial commit: Create the multiverse hub" 提交更改，-m表示本次提交的注释

git branch feature-dimension 创建新的分支

git branch 查看所有分支，带*的是当前工作的分支

git branch --show-current  直接输出当前分支

git checkout feature-dimension 切换到feature-dimension分支。现在更多用git switch feature-dimension来切换分支

git checkout master    git merge feature-dimension  需要先切换到master然后再从 `feature-dimension` 中获取所有更改并将它们应用于 `master`

git checkout def5678  切换到def5678这次的commit，def5678的一次提交的hash。

git branch -d feature-dimension  `-d` 标志告诉 Git 删除该分支，但前提是该分支已完全合并。这是一种防止意外丢失未合并更改的安全措施。

git branch -m master main 修改当前分支名为main

# 常见用法

## .gitignore

echo "*.log" > .gitignore   .gitignore 该文件告诉 Git 忽略任何扩展名为 `.log` 的文件。

## `git cherry-pick` 

`git cherry-pick` 命令用于将一个或多个提交从一个分支应用到当前分支。它实际上是将指定提交的更改重新应用到当前分支，创建一个新的提交。

```bash
git cherry-pick <commit-hash>
```

假设你有一个分支 `feature-branch`，其中包含一个提交 `abc1234`，你希望将这个提交应用到当前分支（如 `main`）：

```bash
git cherry-pick abc1234
```

- **作用**：将 `abc1234` 提交的更改应用到当前分支，并创建一个新的提交。
- **结果**：当前分支会包含 `abc1234` 提交的更改，但不会合并整个分支。

## `git merge`

`git merge` 命令用于将一个分支的更改合并到当前分支。它会将整个分支的更改合并到当前分支，生成一个新的合并提交。

```shell
git merge <branch-name>
```

## `git stash`

```shell
git stash ##  只存储跟踪文件（Git 已在跟踪的文件）的更改，没有add的文件不存储。
git stash -u ##没有add的文件也暂存。
git stash list ## 列举暂存列表
git stash apply  ## 恢复暂存的隐藏文件，如果有多次暂存，只恢复最新一次的暂存。
git stash pop ## apply 和 pop 的区别在于 apply 保留暂存中的更改，而 pop 在应用后将其从暂存中删除。
git stash drop stash@{2} ## 这会从我们的列表中移除第三个储藏。
git stash clear ## 移除你所有的储藏，并且无法撤销。
git stash branch feature-branch ## 创建新的分支并应用这些暂存，暂存随后会从你的暂存列表中移除。从暂存创建分支后，如果你希望保留这些更改，你需要提交它们（add和commit）
```

## git diff

git diff 只显示未暂存的更改，即还没有add的文件的内容对比。

git diff greet.js 只看没有add的greet.js文件的

`git diff --staged` 已暂存的更改

git diff master feature-branch  比较两个分支内容，需要分支中的内容已经add和commit了。

git diff master  比较当前分支与master，需要分支中的内容已经add和commit了。

git diff master feature-branch -- numbers.js  比较两个分支内容中的numbers.js文件，需要分支中的numbers.js文件内容已经add和commit了。

## git reset/restore/rm

git reset --soft HEAD~2  此命令将 HEAD 移回两个提交。`~2` 表示“在当前 HEAD 之前的两个提交”。你可以使用 `~N` 回溯 `N` 个提交。这种方法叫软重置，将当前分支的指针回退到指定的提交，但保留工作目录和暂存区中的更改。

git reset HEAD  用于取消暂存区的更改，但保留工作目录中的更改。它将暂存区的内容重置为当前分支的最新提交（`HEAD`），但不会影响工作目录中的文件。工作目录（Working Directory）是指你当前操作的文件系统中的项目目录，也就是你实际存放代码和文件的地方。它是你进行开发工作的本地目录，包含了项目的源代码、配置文件、资源文件等。

git reset --hard HEAD~1  硬重置会移动 HEAD，更新暂存区，并且更新工作目录以匹配。这意味着它会丢弃自你重置到的提交以来的所有更改。

git reset --hard master@{"1 hour ago"}  基于时间的重置

| 命令                      | 仓库            | 暂存区                 | 工作目录               |
| ------------------------- | --------------- | ---------------------- | ---------------------- |
| `git reset --soft HEAD~2` | 回退到 `HEAD~2` | 保留所有更改           | 保留所有更改           |
| `git reset HEAD`          | 不改变          | 取消所有暂存的更改     | 保留所有未暂存的更改   |
| `git reset --hard HEAD~1` | 回退到 `HEAD~1` | 重置为 `HEAD~1` 的状态 | 重置为 `HEAD~1` 的状态 |

保留所有更改的意思是：假设你正在开发一个项目，当前的提交历史如下：

```
A -> B -> C (HEAD)
```

你在 `C` 提交后修改了 `file1.txt`。那么执行`git reset --soft HEAD~2`后暂存区依然是修改后的file1.txt。

git restore file.txt 将工作目录中的file.txt恢复到最近一次的提交状态。

git rm file.txt 在暂存区删除了文件，然后执行git commit 把删除提交到仓库，一般用户删除仓库上的文件。

## git reflog

git reflog  会列出最近采取的所有操作的列表，包括重置。每个条目都有一个 HEAD@{n} 标识符。要恢复丢失的提交，你可以重置到硬重置之前的状态：git reset --hard HEAD@{1}。用于记录分支头（HEAD）的所有引用操作，包括 `git reset`、`git checkout`、`git merge` 等操作。

## tag

git tag v1.0

git tag -a <tagname> -m "注释信息" 带注释信息

git tag  查看所有tag

git show v1.0  查看特定标签的详细信息

git tag -d v1.0  删除标签

git push origin --delete v1.0  删除远程标签

git push origin v1.0  推送标签到远程库

实际使用场景：

1. 版本发布：在发布新版本时，通常会创建一个带注释的标签，以便记录版本信息和发布日期

   ```shell
   git tag -a v2.0 -m "Release version 2.0"
   git push origin v2.0
   ```

2. 回溯到特定版本，如果需要回溯到某个特定版本，可以检出对应的标签：

   ```shell
   git checkout v1.0
   ```

3. 基于标签创建新分支，如果需要基于某个标签创建一个新的分支，可以使用以下命令：

   ```shell
   git checkout -b release-v1.0 v1.0
   ```

## Fast Forward Merging

在 Git 中，合并（Merge）是指将一个分支的更改合并到另一个分支。通常情况下，合并会创建一个新的合并提交（Merge Commit），这个提交有两个父提交：一个是当前分支的最新提交，另一个是被合并分支的最新提交。然而，在某些情况下，Git 可以通过一种更简单的方式完成合并，而不需要创建新的合并提交。这种合并方式就是 Fast Forward Merging。

原理：假设 Anna 有一个主分支 `main` 和一个功能分支 `feature`。`feature` 分支是从 `main` 分支创建的，并且在 `feature` 分支上进行了一些开发。如果在合并 `feature` 分支到 `main` 分支时，`main` 分支没有任何新的提交，那么 Git 可以直接将 `main` 分支的指针向前移动到 `feature` 分支的最新提交。这种操作称为 **Fast Forward Merging**。这样做的优势是效率高。

fast forward merging是默认开启的，但为了预防多成员协作可能导致冲突，会禁用这个共功能，使用： git config --global --add merge.ff false

## git shorlog b00b937..d22f46b

查看b00b937到d22f46b之间两次commit的区别。b00b937到d22f46b是两次commit的hash值，可以通过git log --oneline查看。

# clone一个仓库到本地后想清晰看到历史提交和版本情况

`git log --pretty=oneline --graph --decorate --all` 是一个非常实用的命令组合，它提供了以下功能：

- **`--pretty=oneline`**：将每个提交显示在一行中。
- **`--graph`**：显示图形化的提交历史。
- **`--decorate`**：显示分支名、标签名等引用信息。
- **`--all`**：显示所有分支的提交历史。

# 本地与远程仓对应

在 Git 中，本地分支和远程分支的名称可以一一对应，也可以不对应。默认情况下，Git 会尝试保持本地分支和远程分支的名称一致，但你可以根据需要自定义这些名称。确立本地分支和远程分支之间的跟踪关系是通过 `git branch` 和 `git checkout` 命令完成的。

默认情况下本地和远程分支的名称对应关系，当你克隆一个远程仓库时，Git 会自动创建一个本地分支（通常是 `main` 或 `master`），并将其设置为跟踪远程仓库的默认分支。例如：

```bash
git clone https://github.com/username/repository.git
```

这将克隆远程仓库，并创建一个本地分支 `main`（如果远程仓库的默认分支是 `main`），并将其设置为跟踪远程分支 `origin/main`。

如何确立本地和远程分支之间的跟踪关系

1. 使用 `git branch` 命令创建一个本地分支，并指定它跟踪远程分支。

```bash
git branch <local-branch> <remote>/<remote-branch>
```

- **`<local-branch>`**：本地分支的名称。
- **`<remote>`**：远程仓库的名称（通常是 `origin`）。
- **`<remote-branch>`**：远程分支的名称。

示例

假设远程仓库中有一个分支 `feature-branch`，你希望创建一个本地分支 `feature` 并跟踪远程分支 `feature-branch`：

```bash
git branch feature origin/feature-branch
```

2. 使用 `git checkout` 命令创建并切换到一个新的本地分支，并指定它跟踪远程分支。

```bash
git checkout -b <local-branch> <remote>/<remote-branch>
```

- **`<local-branch>`**：本地分支的名称。
- **`<remote>`**：远程仓库的名称（通常是 `origin`）。
- **`<remote-branch>`**：远程分支的名称。

示例

假设远程仓库中有一个分支 `feature-branch`，你希望创建一个本地分支 `feature` 并跟踪远程分支 `feature-branch`：

```bash
git checkout -b feature origin/feature-branch
```

查看跟踪关系，可以使用以下命令查看当前分支的跟踪关系：

```bash
git branch -vv
```

这将显示所有本地分支及其跟踪的远程分支。

示例输出

```shell
* feature   1234abcd [origin/feature-branch] Add new feature
  main      5678efgh [origin/main] Initial commit 
```

# 拿到电脑时的git-github从头配置

## 安装git（ubuntu下）

```shell
# 更新 apt 包数据库，确保我们使用的是最新的软件列表
sudo apt-get update

# 使用 apt-get 安装 Git
sudo apt-get install git
```

## 新建git工作目录并设置git信息

```shell
sudo mkdir /home/labex-git
# 设置你的 Git 用户名
git config --global user.name "labex"

# 设置你的 Git 邮箱
git config --global user.email "labex@labex.io"
```

## 生成ssh密钥连接远程GitHub

```shell
# 生成一个 SSH 密钥对
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"

# 查看公钥内容
cat ~/.ssh/id_rsa.pub

# 公钥放到GitHub上
登录到 GitHub，进入 Settings 页面，找到 SSH and GPG keys 部分，点击 New SSH key。粘贴你刚刚复制的公钥到 Key 栏，给它起一个名字（比如：My Laptop），然后点击 Add SSH key。

# 添加远程仓库，并将远程仓库用origin代指
git remote add origin git@github.com:username/repository.git
```



## 测试

```shell
#创建新分支：在本地创建一个新的分支 my-branch。设置上游分支：将新分支的上游分支设置为 origin/main。按需看是否需要这一步。
git checkout -b my-branch origin/main

# 创建一个测试文档
echo "I am Labex Readme Doc" > readme.md

# 将所有更改添加到暂存区
git add .

# 提交更改
git commit -m "Initial commit"

# 推送远程仓main分支
git push
```

# 远程

## 远程拉取

在本地与远程仓库已绑定的前提下：

```shell
git pull origin main
```

## 远程clone

clone就是复制一份到本地，所有本地不需要有git环境，甚至说啥环境都不需要，因为这只是复制操作。

```shell
git clone https://github.com/github/gitignore
# clone深度为 1 个提交（commit）
git clone --depth=1 https://github.com/github/gitignore
```

## submodule

Git 子模块（Submodule）允许你将一个 Git 仓库作为子模块嵌入到另一个 Git 仓库中。子模块本质上是一个独立的 Git 仓库，但它被嵌入到父仓库中，并且可以通过父仓库的版本控制来管理。例如，一个常用的工具库可以作为一个子模块嵌入到多个项目中。一个项目可能依赖于多个第三方库，这些库可以作为子模块嵌入到项目中。

```shell
git submodule add <upstream-path> <local-path>
git submodule add https://github.com/labex-labs/git-playground.git ./git-playground
```

