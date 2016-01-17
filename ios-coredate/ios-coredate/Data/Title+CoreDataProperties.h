//
//  Title+CoreDataProperties.h
//  ios-coredate
//
//  Created by BlueEagleBoy on 16/1/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Title.h"

NS_ASSUME_NONNULL_BEGIN

@interface Title (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *titleName;
@property (nullable, nonatomic, retain) NSSet<Person *> *persons;

@end

@interface Title (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet<Person *> *)values;
- (void)removePersons:(NSSet<Person *> *)values;

@end

NS_ASSUME_NONNULL_END
