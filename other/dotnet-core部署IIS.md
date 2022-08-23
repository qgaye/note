# 记dotnet core部署IIS

总体步骤
1. 安装dotnet core的runtime环境
2. 安装并启动IIS
3. 新建一个网站并配置其的物理路径

主要的坑有两个个
1. 在新建网站的时候IIS会帮你自动新建一个应用程序池，而dotnet core的应用程序池的.NET CLR版本是无代码托管，因此需要更改成无代码托管
2. 需要给网站配置的物理路径的文件夹配置安全组和用户的权限，即添加IIS_IUSRS该用户
3. 项目的csproj中`<AspNetCoreHostingModel>OutOfProcess</AspNetCoreHostingModel>`要使用OutOfProcess而不是默认的InProcess
