# Branch指南

## 分支名称

若要使用`fetch`或`pull`的远程分支，该分支名为`远程仓库名/分支名`，例如`origin/dev`

## 分支查看

```bash
git branch  # 列出所有本地分支
git branch -r   # 列出所有远程分支
git branch -a  # 列出所有本地和远程的分支
git branch -v  # 显示分支最近一次的commit信息
```

## 切换分支

```bash
git checkout [branch]  # 切换到branch分支
git checkout -  # 切换到上一个分支
```

## 新建分支

```bash
git branch [branch]  # 新建branch的分支
git branch [branch] [commit]  #基于commit新建branch分支
git checkout -b [branch]  # 新建branch分支，并切换到该分支
```

## 删除分支

不能删除当前所在分支，必须切换到其他分支后才能删除该分支

```bash
git branch -d [branch]  # 删除branch分支
git push origin --delete [branch]  # 删除远程分支branch
git push origin :[branch]  # 删除远程分支branch 
```
