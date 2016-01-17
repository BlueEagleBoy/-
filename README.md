#CoreData
这里运用CoreData数据库实现了基本的数据添加与存储，并对CoreData封装成BLECoreDataManager工具类，可以直接使用此工具类的公共API直接进行数据的增删改。
<pre>
 //公共API
//上下文管理工具 可以增删改查
@property (nonatomic,readonly)NSManagedObjectContext *managedObjectContext;
//保存上下文API
- (BOOL)saveContext;
//创建工具对象
+ (instancetype)sharedManage;
</pre>

* NSManagedObjectContext管理上下文专门作为数据的增删改
* saveContext 用户数据改变后的保存
* sharedManage 创建管理工具对象

在使用的时候只需要根据manager对象调用方法进行数据的保存
<pre>
//添加实体之后做数据的保存
[[BLEDataManager sharedManage] saveContext];
</pre>

