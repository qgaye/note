# 记Medis安装

- 安装时间2019/12/15
- Medis版本1.0.3
- node版本13.3.0

Medis官网 - https://github.com/luin/medis

Mac上在App Store里提供打包好的，但是是收费的，如果希望免费使用就必须手动安装

但是如果按照README里的步骤是无法成功的，但在PR和Issue里提供了解决方法，记录一下具体安装过程

- 首先通过[#170PR](https://github.com/luin/medis/pull/170)下载源码(主要解决了node-sass版本问题)
- 在[#172Issue](https://github.com/luin/medis/issues/172)中提供了具体的安装步骤
    - `npm run pack` 在浏览器打开后Ctrl+C终止命令行
    - `node bin/pack.js` 运行结果`Unhandled rejection Error: No identity found for signing.`报错不用理会
    - 软件已成功打包在了`dist/out/Medis-mas-x64/Medis.app`中
