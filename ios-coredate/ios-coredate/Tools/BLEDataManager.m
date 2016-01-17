//
//  BLEDataManager.m
//  coredata Stack
//
//  Created by BlueEagleBoy on 16/1/12.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEDataManager.h"

static NSString *const modelName = @"Person";
static NSString *const storeName = @"my.db";

@interface BLEDataManager ()

@property (nonatomic)NSManagedObjectContext *privateContext;

@end
@implementation BLEDataManager

@synthesize  managedObjectContext = _managedObjectContext;

static id instance;

+ (instancetype)sharedManage {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    
    return instance;
}

- (NSManagedObjectContext *)managedObjectContext {
    
    //返回已经绑定到 “持久化存储调度器” 的管理对象上下文
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    //创建模型URL  momd是在bundle中编译后的二进制文件名
    NSURL *modelURL = [[NSBundle mainBundle]URLForResource:modelName withExtension:@"momd"];
    //根据url创建模型]
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];

    
    // 根据模型创建调度器
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //创建数据库存储路径
    NSURL *docURL = [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask]lastObject];
    NSURL *storeURL = [docURL URLByAppendingPathComponent:storeName];
    
    
    //调度器根据数据库存储路径 创建数据库
    if ([coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil] == nil) {
        
        NSLog(@"创建数据库失败");
        
        return nil;
        
    }
    
    _privateContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    
    [_privateContext setPersistentStoreCoordinator:coordinator];
    
    //创建管理对象上下文
//    NSPrivateQueueConcurrencyType		= 0x01, 私有队列－ 自定义队列使用后台线程
//    NSMainQueueConcurrencyType			= 0x02 主队列 使用住县城
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置上下文对应的数据库
    [_managedObjectContext setParentContext:_privateContext];
    
    
    return _managedObjectContext;
}

- (BOOL)saveContext {
    
    if (self.managedObjectContext == nil || self.privateContext == nil) {
        
        NSLog(@"上下文为nil 无非进行上下文操作");
        
        return NO;
    }
    

    if (!self.managedObjectContext.hasChanges && !self.privateContext.hasChanges ) {
        
        NSLog(@"没有数据更新");
        return YES;
    }
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        
        NSLog(@"数据保存失败 --%@",error);
        return NO;
    }
    
    [self.privateContext save:NULL];
    
    return YES;

}

@end
