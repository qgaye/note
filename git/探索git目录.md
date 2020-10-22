# 探索.Git目录

## `.Git`目录是什么

git仓库正常工作所需的信息全部存放在`.git`目录下

## `.Git`目录树形结构图

```text
.
└── .git
    │  
    ├── branches
    │  
    ├── COMMIT_EDITMSG    # 保存最新的commit message，Git系统不会用到这个文件，只是给用户一个参考。
    │  
    ├── config    # 仓库的配置文件。
    │  
    ├── description    # 仓库的描述信息，主要给gitweb等git托管系统使用。
    │  
    ├── HEAD    # 包含了一个分支的引用，通过这个文件Git可以得到下一次commit的parent，可以理解为指针。
    │  
    ├── hooks    # 存放一些shell脚本，可以设置特定的git命令后触发相应的脚本。
    │   │
    │   ├── applypatch-msg.sample
    │   ├── commit-msg.sample
    │   ├── post-update.sample
    │   ├── pre-applypatch.sample
    │   ├── pre-commit.sample
    │   ├── prepare-commit-msg.sample
    │   ├── pre-push.sample
    │   ├── pre-rebase.sample
    │   └── update.sample
    │
    ├── index    # 二进制暂存区（stage）。
    │  
    ├── info    # 仓库的其他信息。
    │   │  
    │   └── exclude
    │
    ├── logs    # 保存所有更新的引用记录。
    │   │
    │   ├── HEAD    # 最后一次的提交信息。
    │   └── refs
    │       ├── heads
    │       │   └── master
    │       └── remotes
    │           └── origin
    │               ├── HEAD
    │               └── master
    │  
    ├── objects    # 所有对象的存储，对象的SHA1哈希值的前2位是文件夹名称，后38位作为对象文件名。
    │   │  
    │   ├── [0-9A-F][0-9A-F]
    │   │   └── dbc3be082ca20a9d032c25623871f503e5797c
    │   ├── info    # 记录对象存储的附加信息
    │   └── pack    # 以压缩形式（.pack）存储许多对象的文件，附带索引文件（.idx）以允许它们被随机访问。
    │       ├── pack-a62b75ba184ef8686604b5f2f366f958022a2fb5.idx
    │       └── pack-a62b75ba184ef8686604b5f2f366f958022a2fb5.pack
    │  
    └── refs    # 具体的引用，Reference Specification。
        │
        ├── heads    # 记录commit分支的树根
        │   └── master    # 标识了本地项目中的master分支指向的当前commit的哈希值。
        ├── remotes    # 记录从远程仓库copy来的commit分支的树根
        │   └── origin
        │       ├── HEAD
        │       └── master    # 标识了远端项目中的master分支指向的当前commit的哈希值。
        └── tags    # 记录任何对象名称（不一定是提交对象或指向提交对象的标签对象）。
```

### `.Git`下常用文件

- `HEAD` 存放头指针`HEAD`指向的分支
- `config` 存放本地仓库（local）相关的配置信息
- `refs/heads/master` 存放`master`分支最后一次`commit`的引用
- `objects` 存储git中所有对象，对象的SHA1哈希值的前2位是文件夹名称，后38位作为对象文件名

## `git cat-file`命令详解

`git cat-file`显示版本库对象的内容、类型及大小信息

- `-t` 显示对象的类型
- `-s` 显示对象的大小
- `-e` 如果对象存在且有效，命令结束状态返回值为 0
- `-p` 根据对象的类型，以优雅的方式显式对象内容

## `Git`对象的三种类型

- `commit` 对象存储 git 中的提交信息
- `tree` 对象存储 git 仓库中的文件元数据信息, 包括文件名及目录结构信息等，即是文件的集合（相当于文件夹）
- `blob` 则对应的是 git 仓库中的文件内容（相当于文件内容）

### `commit`、`tree`和`blob`三个对象之间的关系

**git会将文件的内容保存为一个`blob`对象，而它的路径和文件名会保存在`tree`对象中**

**git对于内容相同的文件只会存一个`blob`（即使文件名不同），对于文件夹内的内容相同的文件夹也只会存一个`tree`（即使文件夹名不同），只有文件或文件夹中的内容发生改变，才会生成新的`blob`和`tree`，而重命名的操作是不会生成新的`blob`和`tree`的。每次提交都会生成新的`commit`和`tree`，其中`tree`会包括当前`commit`下的所有文件路径和文件名（包括未更改的）**

**由于`blob`和`tree`是完全和内容相关的，因此只要内容相同，即使名字不同，处于不同的文件夹，处在不同的`commit`中，他们都是相同的`blob`或`tree`**

![git的object对象关系](./pics/git_object.png)

## 参考

- [Git之对象](https://www.imooc.com/article/24881#)
