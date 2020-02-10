# PrepareInterviewTest
复习准备  

1、[markdown的基本使用](https://www.jianshu.com/p/12569740cc50#link "markdown使用")  
2、[git的常用命令](https://www.jianshu.com/p/628d1c40b501 "git命令")  

3、探索KVO底层
定义一个Person类，有name这个实例变量
定义Person实例p1和p2，p1 addObserver ,p2不添加，p1.name = @"111";p2.name = @"222";  
按理都是调用Person的setterName方法，为什么p1就会回调- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context,而p2不会?  

验证这个问题,可以尝试在addObserver 前后打印 [p1 class] 和 [p2 class] ，发现是一样的，，  
接着可以通过object_getClass(id)获取当前这个实例对象的isa指针，发现p1的isa 是指向一个NSKVONotifying_Person的类，而p2的isa是指向 Person类，  

然后，同一个方法的IMP指针地址是一样的，如果都是调用同一个setName方法，那IMP地址应该一样，但是addObserver之后imp1 和 imp2 不是同一个地址，证明两个setName的地址不一样，证明实现不一样，通过lldb 打印po imp1 和 po imp2 会发现imp1 对应的是 Foundation 框架里的 _NSSetObjectValueAndNotify 函数 ，而imp2 对应的是Person setName方法  ，证明p1 addObserver 后 修改 name的值 setName并不会调用Person setName方法。  

再接着为什么没有调用Person 的setName方法，但是p1.name 的值也会发生改变呢，p1也是Person的实例呀，然后就延伸出了
NSKVONotifying_Person 和 Person 有没有内在的联系呢?  

可以打印  
Class cls1 = object_getClass(p1)  
Class cls2 = object_getClass(p2)  

Class superCls1 = class_getSuperclass(cls1)  
Class superCls2 = class_getSuperclass(cls2)

发现NSKVONotifying_Person 的父类是Person 而Person的父类是NSObject

接着通过class_copyMethodList 获取NSKVONotifying_Person 和Person 的实例方法，发现 NSKVONotifying_Person 会有setName：isKVOA dealloc class4个方法，而person有name setName： 方法，而NSKVONotifying_Person 的setName实现就是_NSSetObjectValueAndNotify  

继续探究 NSKVONotifying_Person 子类 重写 setName 都做了什么?  
其实 setName 方法内部 是调用了 Foundation 的 _NSSetObjectValueAndNotify 函数 ,在 _NSSetObjectValueAndNotify 内部

1首先会调用 willChangeValueForKey  
2然后给 name 属性赋值  
3 最后调用 didChangeValueForKey  
4最后调用 observer 的 observeValueForKeyPath 去告诉监听器属性值发生了改变 .  

而通过重写Person的setName 和 willChangeValueForKey 和didChangeValueForKey 会发现，因为NSKVONotifying_Person也是Person的子类，p1 addObserver之后，p1.name 会先调用willChange ，再调用setName 再调用didChange，最后通知observe 属性值发生了变化。  

最后解释一下为什么p1 addobserve 后 [p1 class]  和 [p2 class]还是Person,因为 NSObject 实例对象默认的 class 方法是 object_getClass,默认是返回当前实例的isa ，而如果是类对象调用[Person class] 返回的是当前类对象，而p2 的isa就是Person，p1 的isa是NSKVONotifying_Person，但是NSKVONotifying_Person重写了class方法，通过返回class_getSuperclass(object_getClass(self)) 返回NSKVONotifying_Person 的父类，就是Person，所以[p1 class] 和 [p2 class]打印是一样的  

IMP 和 SEL 是一一对应的， IMP 是函数指针地址， SEL 是 函数符号标记，是通过一个表来保存的。


