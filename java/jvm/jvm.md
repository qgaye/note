# JVM

## Java基本类型

![Java基本类型](../pics/java_basic_type.png)

对于CPU而言其只关心01数据并不关心数据类型，数据类型是编译器提供的能力。比如boolean类型在Java中规定了只有true和false两个值，但在JVM中将boolean类型映射为了int类型，即true为整数1，false为整数0，然后布尔判断也通过整数的比较实现(比如`a == true`即`a == 1`)，因此在编译后的.class文件中几乎看不出boolean类型的痕迹了

Java的基本类型都有对应的值域和默认值，图中byte，short，int，long，float，double值域依次扩大即前面的值域被后面的值域所包含，因此从前面的基本类型转化到后面的基本类型无需强制转换，此外所有基本类型的默认值看起来不同但在内存中都是0

在堆上Java基本类型的大小是我们熟知的，比如boolean占1字节，char占2字节，int占4字节等，即是变长的，但在JVM中每调用一个Java方法都会创建一个栈帧(类似操作系统上调用函数的栈帧，但JVM中的栈帧不在整个内存的栈区域而是JVM在由操作系统分配给其的内存中划分出来的一块内存区域中)，这种栈帧(解释栈帧，interpreted frame)主要由局部变量区(除了普遍意义下的局部变量外，还包括this指针和方法接受的参数等)和字节码的操作数栈。在JVM中局部变量区等价于一个数组，boolean，byte，char，int等在栈帧中所占的空间和引用类型是一样的，即32位中占4字节，64位中占8字节(32位中这个数组每项占4字节，因此long和double需要数组中的两项来存储)，通过定长的数组项的方式虽然增大了空间占用但不再需要维护变长数组并且访问时直接通过下标来计算地址。当将局部变量区即数组中的项存储到对应类型中(可以理解为存储到堆中，堆上的类型所占字节数是变长的)就需要做一次隐式的掩码操作，比如byte在数组中占4字节(32位)，但byte类型只占1字节，因此隐式掩码操作就将高位的3字节截取掉只存入最低位的1字节，像boolean最特殊的类型，其类型占1字节但正真有效的就1字节中最低的一位(因为只要表示1/true和0/false)，因此在隐式掩码操作中只截取最低1字节的最低1位，这是类型的存储过程，而相对应的加载过程，因为JVM中所有的运算都依赖于操作数栈，然后将操作数栈的值当作4字节/8字节来运算，因此加载过程就伴随着零扩展和符号扩展，比如boolean和char这种无符号类型高字节就会以0填充即零扩展，而byte，short这种有符号的类型则负数高位以1填充非负则已0填充，即符号扩展

```java
static boolean flag1 = true;
public static void main(String[] args) {
    boolean flag2 = true;
    if (flag1) System.out.println("flag1");   // flag会编译为flag != false即flag != 0
    if (flag2) System.out.println("flag2");
    if (flag1 == true) System.out.println("flag1 == true");   // flag == true会编译为flag == 1
    if (flag2 == true) System.out.println("flag2 == true");
}
```

尝试将boolean类型的flag2的值改为2，于是`if (flag2)`就被编译为`flag2 != 0`即`2 != 0`，因此还是true能输出"flag2"，但`if (flag2 == true)`被编译为`flag2 == 1`即`2 == 1`因此是false即无法输出"flag2 == true"

flag1和flag2的区别在于flag2是局部变量，因此只会存在于栈帧上，而flag1则是static的全局变量因此是存储在堆上的，故而需要做一次掩码操作，boolean类型即只截取最后一位，尝试修改flag1的值为2和flag2为2的效果相同，即只会输出"flag1"，但如果将flag1的值修改为3，因为3的二进制为`11`，在掩码操作后截取最后一位得`1`，于是`if (flag1 == true)`被编译为`1 == 1`也就是"flag1"和"flag1 == true"两个都能输出

## 类加载

JVM将.class文件转化为内存中Java类过程分为加载，链接，初始化三步

加载：查找字节流(可以来自本地/网络/动态代理实时编译等皆可)并创建类的过程，JVM通过类加载器按照双亲委派模型进行加载

双亲委派模型：在类加载时如果该类未被加载过则会递归的委派给其类加载器的父类加载器要求进行加载，直到委派到BootstrapClassLoader(启动类加载器)(该类加载器由C++实现)为止，当启动类加载器无法加载时则会再委派给其子类加载器(即委派上来的类加载器)，一层层委派下去直到某个类加载器加载成功

链接：
    验证：校验加载类是否符合JVM约束条件
    准备：为加载类的静态字段分配内存(静态字段的具体初始化则在初始化的步骤进行)
    解析：编译阶段对于一个方法调用编译器会生成个符号引用代替(符号引用包括目标方法所在类名，目标方法名，接受参数类型，返回类型)，解析即负责将符号引用转化为实际引用(JVM并未要求在链接过程中完成解析，只要在执行这些字节码前完成这些符号引用的解析即可)

初始化：(初始化一个静态字段，可以在声明时直接赋值也可以在静态代码块中进行赋值)对于被final修饰的直接赋值的静态字段，且类型为基本类型或字符串时，那么该字段会被编译器标记为常量值(ConstantValue)由JVM完成初始化，除此之外的直接赋值操作及所有静态代码块中代码会被编译器置于`<clint>`方法中。初始化即为标记为常量值的字段进行赋值以及执行`<clint>`方法，JVM会通过加锁(系统锁)确保`<clint>`方法仅被执行一次

类何时被触发加载：加载的类中符号引用指向未被加载的类或未被加载的类中的方法/字段时，那么在解析这个步骤时会触发未被加载过的这个类的加载(但未必触发这个类的链接及初始化)

类何时被触发初始化(也包括加载，因为初始化是在加载之后的步骤)：
- JVM启动时初始化用户指定主类
- 遇到新建目标实例的new指令时，初始化new指令的目标类
- 遇到调用/访问静态方法/字段指令时，初始化该静态方法/字段所在类
- 子类初始化会触发父类初始化
- 如果接口定义default方法，那么直接实现或间接实现该接口的类的初始化会触发该接口的初始化
- 当反射API对某个类进行反射调用时初始化该类
- 当初次调用MethodHandle实例时初始化MethodHandler指向方法所在类

## JVM方法调用

在Java中同一个类中出现同名且参数数量/类型不同的方法即称为重载，Java编译器会在编译时根据传入的参数类型来确定重载的方法
1. 在不考虑基本类型的自动拆装箱(auto-boxing，auto-unboxing)以及可变长参数的情况下选取重载方法
2. 如果在第一步中没有找到适配的方法，那么在允许基本类型的自动拆装箱，但不允许可变长参数的情况下选取重载方法
3. 如果在第二步中没有找到适配的方法，那么在允许基本类型的自动拆装箱和可变长参数的情况下选取重载方法
如果编译器在同一步中找到多个适配方法，会根据参数类型的继承关系进行选择，即方法的参数类型越是子类的选作

注：父类和子类中的同名方法，如果两个方法都是静态的，那么子类中的方法就隐藏了父类中的方法，如果两个方法都不是静态的且不是私有的，那么就是子类中的方法重写了父类中的方法

JVM中识别方法的关键在于类名，方法名以及方法描述符(method descriptor，即方法的参数类型和返回类型)，在JVM中对方法的重载的判定基于方法描述符，因此对于JVM来说同一个类中出现同名且参数相同的方法，只要返回类型不同都是合法的，但Java编译器中同一个类中只要方法名和参数相同即不合法，即不符合重载的规则

重载其实关键点在于在编译期编译器如何确定调用的目标方法究竟是目标类中的哪个重载方法，找到后用符号引用表示，而重写则是在编译期非常明确要调用的方法的符号引用，但关键点在于这个符号引用在运行时究竟指向的是哪个实际引用即调用哪个类中的方法

Java字节码中调用相关的指令共有5种：
- `invokestatic`：调用静态方法
- `invokespecial`：调用私有的实例方法，构造器，super关键词调用父类的实例方法，构造器，及所实现的接口的默认方法
- `invokevirtual`：调用非私有的实例方法
- `invokeinterface`：调用接口的方法
- `invokedynamic`：调用动态的方法

对于`invokestatic`和`invokespecial`而言，JVM能够直接直接识别具体的目标方法，称为静态绑定(static binding)，而对于`invokevirtual`和`invokeinterface`而言，JVM需要在运行过程中根据调用者的动态类型来确定目标方法，称为动态绑定(dynamic binding)

在编译期是并不知道目标方法的具体内存地址，因此Java编译器会使用符号引用来表示目标方法(符号引用包括目标方法所在的类或接口的名字，以及目标方法的方法名和方法描述符)，符号引用存储在.class文件的常量池中

JVM在执行字节码前需要解析符号引用并替换为实际引用，对于静态绑定的方法调用而言实际引用是个指向方法的指针，对于动态绑定而言实际引用则是个方法表的索引

对于非接口符号引用：假定该符号引用指向的类为C，则JVM按如下步骤进行查找
1. 在C类中查找符合名字和描述符的方法
2. 如果没有找到则到C的父类中继续查找直到Object类
3. 如果还没找到则到C类直接实现或间接实现的接口中查找，这一步查找的目标方法必须是非私有的，非静态的

对于接口符号引用：假定该符号引用指向的接口为I，则JVM按如下步骤进行查找
1. 在I接口中查找符合名字及描述符的方法
2. 如果没有找到则到Object类的共有实例方法中查找
3. 如果还没有找到则到接口I的超接口中进行查找

JVM通过方法表的方式实现动态绑定，比如invokevirtual指令会生成虚方法表(virtual method table，vtable)而invokeinterface指令会生成接口方法表(interface method table，itable)

注：JVM中调用静态方法的invokestatic指令和调用构造函数，私有实例方法，超类非私有实例方法的invokespecial指令和虚方法调用指向final标记的方法都是静态绑定，剩下的则是动态绑定

方法表本质是个数组，每个数组元素指向一个当前类及其祖先类中的非私有的实例方法，方法表满足两个特质：
- 子类方法表中包含父类方法表中的所有方法
- 子类方法在方法表中的索引值与他重写的父类方法的索引值相同(比如子类重写了toString方法，假设toString方法在Object类的方法表中索引值为10，则子类的方法表中toString所在索引值也为10，即重写了父类的方法)

动态绑定的方法表调用过程：首先访问栈上的调用者，读取调用者的动态类型，读取该类型的方法表，读取方法表中对应的索引着所对应的目标方法

通过方法表实现的动态绑定毫无疑问是增大性能消耗，在即时编译中还有内联缓存(inlining cache)和方法内联(method inlining)的优化手段

内联缓存是一种加快动态绑定速度的优化手段，其能够缓存调用虚方法的调用者的动态类型及该类型对应的目标方法，在之后的执行过程中如果调用者的类型是已缓存的类型，就可以直接调用目标方法不再需要通过对应的方法表通过索引值确定目标方法

JVM采用单态(monomorphic)内联缓存，即只缓存一种状态，如果发现新的调用者类型未能命中缓存，则回退到通过方法表索引值的方式来查找目标方法

## JVM处理异常

try-catch-finally捕获异常：
- 如果异常被catch代码块捕获，finally代码块则在catch代码块后运行
- 如果catch代码块中也发生异常，那么finally代码块也会运行，并只会抛出catch代码块中的异常，而try代码块中的异常将被忽略
- 如果finally代码块中发生异常，那么就中断当前当前finally代码块的执行并抛出该异常

在进行异常实例构造时(比如`new Exception`)，JVM需要生成该异常的栈轨迹(stack trace)，该操作会逐一访问当前现场的Java栈帧，并记录下各种调试信息，包括栈帧所指向方法的名字，方法所在的类名，文件名，以及在代码中的第几行触发该异常，因此不适合将抛出异常作为业务上逻辑错误的返回方式

try-catch-finally在JVM中的实现：

在编译生成的字节码中，每个方法都附带一个异常表，异常表中每一项都代表一个异常处理器，其由from指针，to指针，target指针以及所捕获的异常类型构成，指针的值是字节码索引(bytecode index，bci)，用于定位字节码
其中from和to指针标示了该异常处理器所监控的范围，下例中from到to即0-3就是try所在代码块，target指针指向异常处理器的其实位置，即catch处的位置，type表明该异常处理器所捕获的异常类型

```java
public static void main(String[] args) {
    try {
        myFunction();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
// 字节码
public static void main(java.lang.String[]);
Code:
    0: invokestatic myFunction:()
    3: goto 8
    6: invokevirtual java.lang.Exception.printStackTrace
    8: return
Exception table:
    from   to   target   type
     0      3     6      Class java/lang/Exception
```

当程序异常时，JVM会在当前方法的异常表中从上到下遍历所有条目，当触发异常的字节码所在索引在某个异常表记录监控的范围内JVM就会判断抛出的异常和该条目要捕获的异常类型是否匹配，如果匹配JVM会跳转到target指针指向的字节码处，反之如果遍历完当前异常表的所有条目仍未匹配到异常处理器则会弹出当前方法的栈帧，并遍历上一个栈帧的方法的异常表，在最坏情况下需要遍历当前线程Java栈上所有方法的异常表

finally可以保证在try和catch代码块出现异常后都一定执行finally代码块，其原理也是生成异常表中的一条记录，该记录监控try和catch代码块范围的索引，对任何异常(any)进行捕获然后跳转到异常处理器，即finally代码块进行执行。此外还需要保证正常执行下try和catch代码块后也需要执行finally块，因此Java编译器在编译时会在try代码块和catch代码块下各自复制一份finally代码块，从而保证正常执行下(即顺序执行)也能执行到finally代码块

![try-catch-finally字节码](../pics/try_catch_finally_bytecode.png)

因为catch代码块抛出异常后，在finally代码块中只会抛出catch抛出的异常而丢弃了try代码块中抛出的异常，因此在Java7中引入Suppressed异常来允许抛出的异常可以附带多个异常的信息，但因为finally代码块中并没有来自try代码块中的异常引用，因此就需要在catch代码块中完成异常信息的附带，使用起来非常繁琐

Java7新增了个try-with-resources的语法糖，在字节码的层面自动使用了Suppressed异常，当然其最大的作用是精简了资源打开关闭的方式，在Java7之前对于打开的资源要关闭就必须包裹在一个try-catch-finally代码块中，当要关闭的资源很多时就需要大量的try-catch-finally代码块的嵌套，而在Java7中在try关键字后声明并实例化实现了AutoCloseable接口的类，编译器会自动添加对应的close()方法来实现关闭资源的功能

## 反射原理

在`Method.invoke`进行反射调用时，实际上是委派给MethodAccessor这个接口对象来处理，其有两种具体实现，一个是通过native的本地C++代码进行反射调用(本地实现)，另一个则会动态生成字节码来完成方法调用(动态实现)，通过委派实现以便在本地实现和动态实现间切换

```java
// Method.class
Method root;   // MethodAccessor是各自独有的，但真正类中的方法对象只会存在一个对象，是共有的，即root。同一类的两个getMethod得到的Method对象中的root对象是相同的
public Object invoke(Object obj, Object... args) {
    MethodAccessor ma = methodAccessor;   // MethodAccessor是个接口
        if (ma == null) {
            ma = acquireMethodAccessor();   // acquireMethodAccessor()中主要调用reflectionFactory.newMethodAccessor()反射工厂完成MethodAccessor的创建
        }
    return ma.invoke(obj, args);
}

// ReflectionFactory.class
private static boolean noInflation        = false;   // 是否当调用次数达到阈值后动态生成字节码
private static int     inflationThreshold = 15;   // 调用次数的阈值，默认15
public MethodAccessor newMethodAccessor(Method method) {
    checkInitted();   // checkInitted主要读取并设置noInflation和inflationThreshold配置项
    if (noInflation && !ReflectUtil.isVMAnonymousClass(method.getDeclaringClass())) {
        return new MethodAccessorGenerator().   // 调用次数达到阈值后，动态为该方法自动生成一个类的字节码，该类名为GeneratedMethodAccessor和一个数字的组合，该类有个invoke方法，该invoke方法就是对应的要调用的方法，基本就是new一个要调用的类对象，然后实例化参数并完成强转，然后直接通过new出来的对象完成对应方法的调用，所有都能通过Java字节码实现，不再依赖C++的Native代码
            generateMethod(method.getDeclaringClass(),
                            method.getName(),
                            method.getParameterTypes(),
                            method.getReturnType(),
                            method.getExceptionTypes(),
                            method.getModifiers());
    } else {
        // 未达到阈值时，通过委派实现，调用C++代码完成
        NativeMethodAccessorImpl acc = new NativeMethodAccessorImpl(method);
        DelegatingMethodAccessorImpl res = new DelegatingMethodAccessorImpl(acc);
        acc.setParent(res);
        return res;
    }
}
```

```java
// 动态生成的字节码，其也有个invoke方法，invoke方法实际调用了原本反射想要调用的类的方法  
public class GeneratedMethodAccessor1 extends MethodAccessorImpl {      
    public GeneratedMethodAccessor1() { super(); }
    public Object invoke(Object obj, Object[] args) throws IllegalArgumentException, InvocationTargetException {  
        if (obj == null) throw new NullPointerException();  
        try {  
            A target = (A) obj;   // 创建反射方法所在类的对象
            if (args.length != 1) throw new IllegalArgumentException();  
            String arg0 = (String) args[0];   // 准备调用反射方法所需参数
        } catch (ClassCastException e) {  
            throw new IllegalArgumentException(e.toString());  
        } catch (NullPointerException e) {  
            throw new IllegalArgumentException(e.toString());  
        }  
        try {  
            target.foo(arg0);   // 调用该对象的方法，即反射所要调用的方法
        } catch (Throwable t) {  
            throw new InvocationTargetException(t);  
        }  
    }  
} 
```

动态实现相较于本地实现运行效率快上20倍，这是因为动态实现无需再经过Java到C++再到Java的切换，但是动态生成字节码十分耗时，因此如果仅调用一次反而是本地实现来的效率更高，这也就是为什么在调用次数超过阈值后才切换成动态实现的原因，这个过程称作Inflation

`Class.getMethod()`会遍历该类的所有公有方法，如果未匹配到将遍历其父类的公有方法，因此操作是很耗时的，此外`Class.getMethod()`会返回查找到结果的一份拷贝，从而造成堆空间的消耗，所以在实际应用程序中需要缓存`Class.forName`和`Class.getMethod`的结果

反射是效率是比较低的，主要原因是：
- 每次调用都需要校验调用方法的可见性
- invoke是个变长参数的方法，Java编译器生成Object[]数组来存储这些传入的参数，且还需要对参数数量和参数类型进行校验
- 由于Object[]无法存储基本类型，因此需要做自动的拆箱装箱的工作
- 当调用次数达到阈值后转换为动态实现后，理论上可以通过内联的方式将热点代码内联到`Method.invoke()`处，但因为所有反射的调用都是`Method.invoke()`作为入口，因此在这上面收集到的类型信息十分混乱从而影响内联，使得`Method.invoke()`难以被内联

![关于反射调用方法的一个log](https://www.iteye.com/blog/rednaxelafx-548536)
![JAVA深入研究——Method的Invoke方法。](https://www.cnblogs.com/onlywujun/p/3519037.html)

## invokedynamic

invokedynamic底层依赖于方法句柄(MethodHandle)，MethodHandle是个强类型，能够被直接被执行的引用，其仅关心所指向方法的参数类型以及返回类型，而不关心方法所在的类以及方法名

在第一次执行invokedynamic时，JVM会执行对应的启动方法(Bootstrap Method)，通过Bootstrap Method得到动态的调用点(CallSite)，这个对象表示一个函数调用，可以从这个对象中获得待调用函数MethodHandle，之后再执行invokedynamic指令就可以直接调用绑定了的调用点链接方法

Lambda到函数式接口间的转换就是通过invokedynamic实现的

## 对象头

JVM中每个对象都有一个对象头(object header)，对象头包括两部分：
- 标记信息：包括哈希值，锁信息，GC信息等，占8字节
- 类型指针：指向这个对象的Class，占8字节
每个对象都额外占用16字节的内存空间存放对象头，像Integer类的对象，真正的数据只占4字节，而对象头却占了16字节，因此这也就是为什么JVM需要基本类型

为了减少对象头对内存的占用，64位JVM引入压缩指针的概念，将堆中原本64位的对象指针压缩成32位，从而使得对象头从16字节减少为12字节(8 + 4)，此外压缩指针不仅用于对象头中的类型指针，还可以用于引用类型字段和引用类型数组

压缩指针原理：通过要求JVM中对象起始地址为对齐至8的倍数(通过-XX:ObjectAlignmentInBytes设置，默认8字节)，这样32位的指针能寻址范围为8 * (2^32)即32G内存，当对压缩指针解引用时，将其左移3位(代表8字节，2^3)再加上个固定偏移量便能得到64位的指针(当超过32G后则会关闭压缩指针)

```txt
// 没有内存对齐，8个字节需要8个地址
byte:    x x x x x x x x
address: 0 1 2 3 4 5 6 7 
// 有了内存对齐，8个字节只需1个地址
byte:    xxxxxxxx xxxxxxxx xxxxxxxx
address:        0        1        2
```

JVM中的内存对齐其实和操作系统中的内存对齐差不多，操作系统中的内存对齐主要是因为某些CPU只能从对齐的地址读取数据，但JVM中的内存对齐更多是因为通过对齐的方式固定每个地址能表示的字节数，从而用更少的地址位数来表示更多的地址空间即字节数(个人认为JVM中内存对齐了那么对应到操作系统中也内存对齐了，也加速了内存读取速度)

JVM中的内存对齐也存在着一个对象占用不到8倍字节数空间，导致剩下的空间被浪费的现象，这些浪费的空间称为对象间的填充(padding)，Java编译器也提供了字段重排的能力来减少浪费的空间以更好实现内存对齐

## 垃圾回收

引用计数法(reference counting)：为每个对象添加个引用计数器用来统计该对象的引用数，当引用数为0即表明该对象该被回收了。但是该方法需要额外的空间存储引用计数，繁琐的更新操作，并且无法处理循环引用对象(对象A和B互相引用，此外无其他引用指向A和B，这种情况下A和B理论上该被回收了，但因为引用计数器不为0，因此无法被回收)

可达性分析算法：从GC Roots出发将所有被GC Roots引用到的对象进行标记(被标记的就是存活的)，未被标记的就是该被回收的

GC Roots代表着必须/应该存活的对象集合，包括：
- Java方法栈桢中的局部变量
- 已加载类的静态变量
- JNI handles(Java本地方法接口)
- 已启动且未停止的Java线程

在多线程环境下，可达性分析算法存在回收掉存活的对象的问题，因为可达性分析算法中标记和清理的步骤是分开的，在标记完后，在清理线程并行的其他线程将某个标记存活的对象的引用替换成了个新的对象，这个对象理论上应该也是存活的，但因为没人将它进行标记，于是在清理线程就会将这个对象进行回收，最后造成并行的其他线程无法访问到这个对象

既然在多线程环境下存在问题，那么最简单的方法就是Stop-the-world，即停止所有非垃圾回收的线程直到完成垃圾回收。JVM中Stop-the-world通过安全点(safepoint)机制来实现
，当JVM收到Stop-the-world请求后便会等待所有的线程都达到安全点后才允许垃圾回收的线程进行独占工作

安全点的真正目的不是让其他线程都停下来，而是能达到一个稳定的执行状态，即在这个执行状态下JVM的堆栈不再会发生变化，从而使得垃圾回收的线程能够安全完成清理工作(比如线程阻塞就是安全的状态)

为了能在可预见的时间内进入安全点，从而降低垃圾回收线程等待其他线程进入安全点的时间，因而在解释执行的代码来说，字节码和字节码之间皆可作为安全点，JVM中当有安全点请求时执行一条字节码便进行一次安全点检查；对于即时编译生成的代码来说，就比较复杂因为这些代码直接跑在硬件上不受JVM控制，因此在生成机器码时就需要插入安全点检测，JVM会在生成代码的出口和非计数循环的循环回边处插入安全点检测

为什么不在即时编译生成的机器码的每条机器码间插入安全点检测？因为安全点检测本身也有一定开销(HotSpot将安全点检测简化为一次内存访问操作，在安全点请求下会将安全点检测访问的内存设为不可读，然后截获访问该不可读内存的线程将他们挂起)，此外因为即时编译生成的机器码打乱了原本栈帧上的对象分布情况，因此进入安全点前机器码需要提供额外的信息表明哪些寄存器，栈帧上的内存空间存放着对象引用，以便垃圾回收线程将他们作为GC Roots进行可达性分析

垃圾回收内存共有三种方式：
- 清除(sweep)：将死亡对象所占内存空间标记为空闲内存，并记录在空闲列表中，在创建新对象时遍历空闲列表找到空闲内存进行分配，但存在内存碎片问题
- 压缩(compact)：将存活的对象聚集到内存区域的起始位置，从而留下连续的内存空间，但是压缩算法性能开销大，但解决了内存碎片问题
- 复制(copy)：垃圾回收时将存活的对象复制到另一块空间中，因此需要将这个内存等分为两份，空间利用效率低，但解决了内存碎片问题

如何保证多线程情况下new指令分配内存不会出现两个线程被分配到了同一块内存的问题？通过TLAB(Thread Local Allocation Buffer)，每个现场可以向JVM申请一段连续的内存作为线程私有的TLAB，这个申请的操作需要加锁，线程需要维护两个指针，一个指向TLAB中空闲的内存的起始位置，一个指向TLAB末尾，当new指令分配内存就可以通过指针加法(bump the pointer)来实现，即将指向TLAB空闲的内存的起始位置的指针加上所请求的字节数，如果此时还小于TLAB末尾则分配成功，否则线程就需要重新申请新的TLAB

### 新生代垃圾回收

JVM就堆空间分为新生代和老年代，其中新生代又被分为Eden区和两个大小相同的Survivor区

默认情况下JVM采用动态分配的策略，根据新对象生成速率及Survivor区使用情况动态调整Eden区和Survivor区比例，当然也可以通过-XX:SurvivorRatio来固定Eden和Survivor区比例，但是Survivor区比例越高就代表着被浪费的空间比例就越高因为必定有一个Survivor区是空闲着的

当new指令请求内存时，会在Eden区进行分配，当Eden区空间耗尽后JVM就会触发一次Minor GC进行新生代的垃圾回收

新生代中有两个Survivor区，分别用from和to指代，其中to指向的Survivor区一定是空的，当Minor GC时会将Eden区和from指向的Survivor区中的存活的对象复制到to指向的Survivor区，然后交换from和to的指针，以保证to指向的Survivor区一定是空的

JVM会记录Survivor区中的对象一共被来回复制了几次，当一个对象被复制次数达到15次(通过-XX:+MaxTenuringThreshold设置，默认15，HotSpot在对象头中记录年龄的字段被分配到的空间最多4位，因此最多记录到15，一旦配置超过15就会被认为是无穷大)，那么该对象将被晋升到老年代，另外如果单个Survivor区已被占用50%(通过-XX:TargetSurvivorRatio设置)，那么较高复制次数的对象也会被晋升至老年代

Minor GC应用的是标记-复制算法，因为大部分新的对象存活时间很短，因此每次复制到另一个Survivor区中的对象很少，大部分在Eden区中的对象都已经死了，非常适合标记-复制算法

老年代中的对象也引用着新生代的对象，也就是Minor GC时需要将老年代中的对象作为GC Roots进行可达性分析，而将所有老年代对象作为GC Roots就需要全部遍历一次老年代。HotSpot使用卡表(Card Table)技术来避免老年代的全表遍历，卡表技术将老年代划分为一个个大小为512字节的卡，并且维护一个卡表用来存储每张卡的标示位，如果这个卡可能指向存有新生代对象的引用，就在卡表中对该卡的标示位进行标示，认为这个卡是脏的

在Minor GC中不再需要遍历所有的老年代对象，只需在卡表中遍历找出脏卡，然后将脏卡中的对象加入到GC Roots进行可达性分析，当完成所有脏卡的扫描后JVM将所有脏卡的标示位清零，Minor GC伴随着存活对象的复制，而复制也就是会更新指向该对象的引用，因此在复制更新引用的同时也会将引用所在卡设置为脏卡，确保老年代中引用新生代对象所在卡已被标记为脏卡

JVM会截获每个引用类型实例变量的写操作，然后将对应所在卡进行标记，在解释执行中比较容易实现，但在即时编译生成的机器码中就需要在引用变量前插入额外操作，即写屏障，为了使得写屏障插入的额外指令尽可能精简，所有不再判断引用对象是在新生代还是老年代，只要引用就当作指向新生代标记为脏卡，虽然这增加额外的开销，但对于Minor GC吞吐率(应用运行时间 / (应用运行时间 + 垃圾回收时间))还是有很大提升

##
