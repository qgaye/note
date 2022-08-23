# Git杂录

## 命令行中文乱码问题

```bash
git config --global core.quotepath false
```

## log、diff、branch分页展示

在git高版本中`log`、`diff`、`branch`默认都使用了`pager`，默认的`pager`使用了`less`

在命令后添加`--no-pager`参数

```bash
git --no-pager log/diff/branch
```

配置pager选项

```bash
# branch命令不再使用pager
git config --global pager.branch false   
# status命令使用pager 
git config --global pager.status true    
```

## push指定commit

有时希望不将本地所有commit推到远端，可以在原先分支的参数中填写commit

```bash
git push origin [commit]:dev
```

## pretty log

`git lg` 代替 `git log`

```bash
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

## alias

在`~/.gitconfig`配置文件中，如果alias以`!`作为前缀，则其将会被视作为bash命令

```bash
[alias]
    br = branch
    br = "!git branch"
```
