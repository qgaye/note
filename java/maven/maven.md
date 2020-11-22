# Maven

## mvn运行指定类

最简单的执行主类的方法就是`java -jar [jar]`(需要在打包jar包的时候指定主类)，maven中通过exec-maven-plugin插件来提供该功能

方法一：

直接在命令行中指定要运行的主类`mvn exec:java -Dexec.mainClass="class path"`

方法二：

在pom文件中配置要运行的主类，然后在命令行中通过`mvn exec:java`运行

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>exec-maven-plugin</artifactId>
            <version>1.6.0</version>
            <configuration>
                <mainClass>class path</mainClass>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## <optional>

pom中对dependency设置`<optional>true</optional>`声明当前依赖是可选的，默认情况下也不会被其他项目继承。比如A项目中的pom依赖了B项目，且将B项目设为可选的依赖，在别的项目pom中依赖A项目后是不会继承对B项目的依赖，如果需要依赖必须手动在当前项目的pom文件中添加B项目的依赖

比如在netty中coder编解码的包中所有的依赖的协议包都是optional的，如果你用到了某个协议就导入对应的依赖包即可，从而打包时不会打包进不依赖的包从而造成包大小膨胀

## 
