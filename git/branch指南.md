# Branch指南

## 分支名称

若要使用`fetch`或`pull`的远程分支，该分支名为`远程仓库名/分支名`，例如`origin/dev`

## 分支查看

```bash
git branch  # 列出所有本地分支
git branch -r   # 列出所有远程分支
git branch -a  # 列出所有本地和远程的分支
git branch -v  # 显示分支最近一次的commit信息
git branch -vv  # 在-v的基础上显示对应的云上分支
```

## 切换分支

```bash
git checkout [branch]  # 切换到branch分支
git checkout -  # 切换到上一个分支
```

## 新建分支

```bash
git branch [branch]  # 新建branch的分支
git branch [branch] [commit]  # 基于commit新建branch分支
git checkout -b [branch]  # 新建branch分支，并切换到该分支
git checkout -b [new branch] [old branch]   # 基于指定分支新建分支，也可以基于远程分支origin/branch(需先fetch下来)来创建新本地分支
```

## 创建远程分支

```bash
git push [origin] [local branch]:[new remote branch]  # 将本地分支push到远程新创建的分支
git push [origin] [local branch(no same name branch on remote)]  # 将在远程创建同名的分支，并将本地分支push到远程创建的分支上
```

## 删除分支

不能删除当前所在分支，必须切换到其他分支后才能删除该分支

```bash
git branch -d [branch]  # 删除branch分支
git push origin --delete [branch]  # 删除远程分支branch
git push origin :[branch]  # 删除远程分支branch 
```

## 分支重命名

```bash
git branch -m [old] [new]
```

## 删除多余的fetch的remote的分支

将本地与远程分支清除后，使用`git branch -a`还是能看到一些`remote...`的分支存在

此时需要使用`git remote prune`命令来删除

```bash
git remote show [remote name]
git remote prune [remote name]
```

## 强制将分支指向某个commit

强制将[branch]分支指向[commit]该提交上

```bash
git branch -f [branch] [commit]
```
