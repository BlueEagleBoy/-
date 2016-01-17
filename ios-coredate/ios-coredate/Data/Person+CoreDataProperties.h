//
//  Person+CoreDataProperties.h
//  ios-coredate
//
//  Created by BlueEagleBoy on 16/1/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *birthday;
@property (nullable, nonatomic, retain) NSString *desc;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Title *title;

@end

NS_ASSUME_NONNULL_END
