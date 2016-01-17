//
//  BLETitleListTableViewController.m
//  ios-coredate
//
//  Created by BlueEagleBoy on 16/1/15.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLETitleListTableViewController.h"
#import "Title.h"
#import "BLEDataManager.h"

NSString *const HMSelectTitleNotification = @"HMSelectTitleNotification";

@interface BLETitleListTableViewController ()<NSFetchedResultsControllerDelegate>

@property (nonatomic)NSFetchedResultsController *fetchedResultsController;

@end

@implementation BLETitleListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.fetchedResultsController performFetch:NULL];

}

//懒加载NSFetchedResultsController  查询对象
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController) return _fetchedResultsController;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Title"];
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc]initWithKey:@"titleName" ascending:YES];
    
    request.sortDescriptors = @[sortDesc];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[BLEDataManager sharedManage].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;

}


#pragma mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.fetchedObjects count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [self.fetchedResultsController.fetchedObjects[indexPath.row] titleName];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    Title *title = self.fetchedResultsController.fetchedObjects[indexPath.row];
    //发送通知到savecontroller
    [[NSNotificationCenter defaultCenter]postNotificationName:HMSelectTitleNotification object:title];

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma  mark NSFetchedResultsController的代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.fetchedResultsController performFetch:NULL];
    
    [self.tableView reloadData];
}


#pragma mark 添加职称
- (IBAction)addTitle:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"职称" message:@"请输入职称" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入职称";
        
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alertController.textFields[0];
        
        if (!textField.hasText) {
            return;
        }
        
        Title *title = [NSEntityDescription insertNewObjectForEntityForName:@"Title" inManagedObjectContext:[BLEDataManager sharedManage].managedObjectContext];
        
        title.titleName = textField.text;
        
        
        [[BLEDataManager sharedManage] saveContext];
        
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
 
}

@end
