# Go远程开发

## vscode

vscode的远程开发就完全依赖于[Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)插件，该插件通过SSH直接在本地打开服务器上的文件/目录，且不需要存储在本地，并且还可以为该远程服务器安装vscode的其他插件，这些插件都是直接运行在远程服务器上的

1. 安装Remote - SSH插件，按照指引配置远程服务器(或者直接配置在`~/.ssh/config`，无论通过命令行ssh还是vscode插件都更方便)
2. 连接到远程服务器并打开项目所在的远程文件夹
3. 安装其他插件，比如go/Thrift Syntax Support插件，如果你本地安装过这个插件，一定要到EXTENSIONS中选择Install in SSH:[remote name]，因为有些插件(比如go)是要运行在远程服务器上的
4. 在服务器上安装go(别忘了将`$GOPATH/bin`添加到`$PATH`中)，还有vscode的go插件依赖的工具(godef，golint等，这些可以从本地直接scp到服务器上，免得手动一个个下载)
5. 接着重启一下vscode，打开服务器上的项目，智能提示和跳转功能都支持了，就可以直接开始远程开发了(vscode还有一点好，就是命令行打开的直接是在服务器上的，而Goland还是在本地，需要自行ssh到服务器或者配置Start SSH Session)
6. 因为项目和vscode插件都是跑在远程服务器上的，因此debug时直接打上断点按下F5就能开始调试了，比Goland方便无数倍(但服务器上也需要装上[delve](https://github.com/go-delve/delve)

## goland

goland远程开发就是本地与远程服务器上的文件保持同步，使用delve做远程调试

### 本地与远程文件同步

在Tools -> Deployments -> Configration中新建一个SFTP服务

在SFTP服务中首先配置Connection，SSH configration配置为远程服务器，Test Connection查看是否连通

接着在该SFTP服务中配置Mappings，为Local path(即当前本地项目目录)配置一个服务器上的对应的目录

在Tools -> Deployments -> Automatic Upload(always)打上勾，以自动同步本地文件到对应服务器目录

可能配置完后需要手动先推到服务器上一次，选择Tools -> Deployment -> Upload to [SFTP server name]即可，以后文件修改后都能自动同步到服务器

如果有需要拉取远程服务器上的对应目录文件到本地，可以选择Tools -> Deployment -> Download from [SFTP server name]同步到本地

### 远程调试

在远程服务器上安装[delve](https://github.com/go-delve/delve)，`dlv version`查看是否安装成功(注意记得把`$GOPATH/bin`添加到`$PATH`)

本地Goland上打开该项目的Run/Debug Configrations(即右上角启动按钮旁的Edit Configurations)，新建一个Go Remote，只需在Configuration中Host修改为远程服务器ip即可

在远程服务器上执行`dlv debug --headless --listen=:2345 --api-version=2 --accept-multiclient`后(也可以自己build后dlv指定包，Go Remote中也有对应命令说明)，本地Goland上打上断点，点击debug按钮既可以进行远程调试了

注：

1. dlv的--accept-multiclient参数使得即使调试完成其不会自动推出，且还不能通过Ctrl + C退出，只能找到pid后手动kill
2. 每次开始调试都需要在服务器上重新执行dlv那一串命令，还是比较麻烦的，不知道还有没有更方便的方法

远程调试test文件

在远程服务器上执行`dlv test --headless --listen=:2345 --api-version=2 --accept-multiclient`后，本地在test文件上打上断点就可以开始调试了，但这会执行所有test文件，如果需要执行指定test文件只需在`dlv test`后加上test文件名即可(别忘了同时加上这个test文件依赖的其他文件，和本地go test一样)
