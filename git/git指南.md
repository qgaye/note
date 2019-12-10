# Git指南

## `Git Config`配置

### 配置用户名和邮箱

```bash
git config [--local | --global | --system] user.name 'Your name'
git config [--local | --global | --system] user.email 'Your email'
```

### 查看配置信息

```bash
git config --list [--local | --global | --system]
```

#### 三个参数间的区别

- `--local` 仅对当前仓库有效，存储于`.git/conifg`
- `--global` 对该用户的所有仓库有效，存储于`~/.gitconfig`
- `--system` 对系统中的所有用户有效，存储于`etc/gitconfig`

## `Git`基础使用

### 1. 初始化`Git`仓库

```bash
git init [project folder name]  # 初始化git仓库
```

### 2. 查看工作目录与暂存区间的状态

```bash
git status
```

#### 三类状态信息

- `Changes to be committed`  已经在暂存区，但还未被提交的文件
- `Changes not staged for commit`  有修改, 但是没有被添加到暂存区的文件
- `Untracked files`  未被tracked的文件, 即从没有add过的文件

### 提交到暂存区

```bash
# 将指定文件从工作目录添加到暂存区
git add [file]   
# 将工作空间新增和修改的文件全部添加到暂存区
git add .   
# 将工作空间修改和删除的文件添加到暂存区(不包括新增的文件)
git add -u   
# 交互式模式一段段提示时候需要add
git add -p
```

### 停止追踪文件

```bash
git rm --cached [file]
```

### 对追踪的文件重命名

```bash
git mv [old file] [new file]   # 修改会直接影响暂存区
```

即使不使用`git mv`命令重命名文件，虽然会在工作区和暂存区显示删除和新建，但是在提交后`git`能识别出是`rename`的操作

### 删除被追踪的文件

```bash
git rm [file]    # 修改会直接影响暂存区
```

### 提交到版本库

```bash
# 提交暂存区文件，并添加相关更新信息
git commit -m "update info"  
# 将工作空间的文件(已被追踪的)跳过暂存区直接提交到仓库
git commit -a    
```

### 修改最近一次的提交

通过`--amend`参数可以将提交到暂存区的内容合并到上一个`commit`中，并且可以修改上一个提交中的`message`信息

```bash
git commit --amend
```

### 文件比较

```bash
# 比较暂存区与HEAD的文件差异
git diff --cached   
# 比较当前工作区与暂存区的文件差异
git diff   
# 比较指定文件的差异变化
git diff --[file]   
# 比较两个commit之间的文件差异
git diff [commit] [commit]   
# 两个commit之间哪些文件做了变动
git diff [commit] [commit] --stat
```

### 撤销修改

#### 1. 恢复暂存区

将已提交到暂存区的文件撤回，即撤销`add`操作，使得暂存区的内容与`HEAD`，即最后一次提交状态一致，**不影响工作区内容**

```bash
# 对暂存区的修改全部撤销，但不影响工作区
git reset HEAD   
# 对指定文件撤销暂存区的修改，但不影响工作区
git reset HEAD -- [file]   
```

#### 2. 恢复工作区

将工作区的文件恢复成暂存区的状态，当暂存区状态与`HEAD`一致，则就是恢复到`HEAD`状态

```bash
git checkout -- [file]   # 撤销工作区的修改，恢复到暂存区的状态
```

#### 3. 恢复到提交状态

撤销所有暂存区以及工作区的修改，使暂存区和工作区与最后一次提交状态一致

```bash
git reset --hard HEAD
```

#### 4. 删除所有未跟踪的文件

```bash
git clean -nfd   # 查看将会被删除的文件和文件夹
git clean -fd    # 删除所有未被跟踪的文件和文件夹
```

[reset的具体使用](./Reset指南.md)

### 查看提交日志

```bash
git log
```

### 汇总项目提交日志

```bash
git shortlog -sn    # -s 仅返回commit的简单统计  -n 按commit数排序
```

### 查看文件每行的作者

```bash
git blame [file]
```

[更多日志查看技巧](./Log指南.md)

## 忽略特殊文件

在工作根目录下创建`.gitignore`文件，将无需提交的文件名写入，git就会自动忽略这些文件

```text
*.class   # 忽略所有后缀为class的文件
doc    # 忽略文件名为doc的文件和名称为doc的文件夹
doc/    # 忽略名称为doc的文件夹，但不会忽略文件名doc的文件
```

除了指定文件，忽略其余所有文件

使用`!`来不忽略文件

```text
/*  # 忽略所有文件
!.gitignore   # 不忽略.gitinore文件
!/folder   # 不忽略folder文件夹
```

## 储藏未提交内容

保存未添加到暂存区和未提交的修改内容到堆栈中，使得可以切换到别的分支解决其他问题，并可以随时重新应用

应用储藏的内容时，存储和使用无需都在同一分支内，比如在`master`分支下的储藏可以应用于`dev`分支

```bash
# 储藏现有变更
git stash    
# 储藏现有变更，并给它附上一个message
git stash save "message"   
# 查看所有储藏
git stash list   
# 应用第一个储藏
git stash apply   
# 应用第二个储藏
git stash apply stash@{2}   
# 应用第一个储藏，并且原先处于暂存区的也会重新应用到暂存区
git stash apply --index   
# 应用第一个储藏，并且从堆栈中删除
git stash pop   
```

> `git stash apply`在应用储藏时，即使先前已经在暂存区中的文件是不会应用到暂存区的，只会在工作区，若要同时应用到暂存区，需使用`--index`参数

## `Git`命令流程

![git工作流程总示图](./pics/git.png)

## 参考

- [git官方教程](https://git-scm.com/book/zh/v2)
- [常用 Git 命令清单](http://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
- [深入浅出Git](https://blog.coding.net/blog/git-from-the-inside-out)
