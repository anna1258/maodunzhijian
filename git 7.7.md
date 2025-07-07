# 创建目录并初始化

cd ~/project 

mkdir git-staging-lab 

cd git-staging-lab

git init

# 基础配置

git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

**目的**：设置全局的用户名。

**作用**：当你提交代码时，Git 会记录这个用户名作为提交的作者。这个信息会显示在提交历史中，帮助你和其他人识别是谁提交了代码。

如果配置时没有global，那么当前仓库的 `.git/config` 文件中设置用户信息，而不是全局配置文件中。

如果配置了global，那么配置信息存储在用户的主目录中的 `.gitconfig` 文件中（Windows 系统中通常是 `C:\Users\username\.gitconfig`）。

git config --global http.proxy 127.0.0.1:10809设置代理

git config --global --unset http.proxy 取消代理

git config --global --get http.proxy 查看代理



# 查看配置

git config --global --list

git config --local --list

git config --global --get user.name

# 常见用法add、commit、diff、rm

echo "hello git" > hello.txt  新增文件

git add hello.txt 放到缓存区

git status 查看可提交文件

git diff --staged 查看缓存区的文件变化

git commit -m "Initial commit: Create the multiverse hub" 提交更改，-m表示本次提交的注释

git branch feature-dimension 创建新的分支

git branch 查看分支，带*的是当前工作的分支

git checkout feature-dimension 切换到feature-dimension分支。现在更多用git switch feature-dimension来切换分支

git checkout master    git merge feature-dimension  需要先切换到master然后再从 `feature-dimension` 中获取所有更改并将它们应用于 `master`

git branch -d feature-dimension  `-d` 标志告诉 Git 删除该分支，但前提是该分支已完全合并。这是一种防止意外丢失未合并更改的安全措施。

# 常见用法

## git revert HEAD

 撤销上一次的commit

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