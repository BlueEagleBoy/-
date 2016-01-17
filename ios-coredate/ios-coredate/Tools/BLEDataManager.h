//
//  BLEDataManager.h
//  coredata Stack
//
//  Created by BlueEagleBoy on 16/1/12.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BLEDataManager : NSObject

//公共API
//上下文管理工具 可以增删改查
@property (nonatomic,readonly)NSManagedObjectContext *managedObjectContext;

//保存上下文API
- (BOOL)saveContext;

//创建工具对象
+ (instancetype)sharedManage;

@end
