//
//  ViewController.m
//  ios-coredate
//
//  Created by BlueEagleBoy on 16/1/14.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "ViewController.h"
#import "BLEDataManager.h"
#import "BLESaveController.h"
#import "Person.h"
#import <CoreData/CoreData.h>


@interface ViewController ()<NSFetchedResultsControllerDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic)NSFetchedResultsController *fetchedResultsController;


@end

@implementation ViewController

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController) return _fetchedResultsController;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Person"];
    
    
    NSSortDescriptor *sortTitleName = [[NSSortDescriptor alloc]initWithKey:@"title.titleName" ascending:YES];
    
    NSSortDescriptor *sortPerson = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    
    
    request.sortDescriptors = @[sortTitleName,sortPerson];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[BLEDataManager sharedManage].managedObjectContext sectionNameKeyPath:@"title.titleName" cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[BLESaveController class]]) {
        
        NSIndexPath *indexPath = (NSIndexPath *)sender;
        
        
        if (indexPath != nil) {
           
            BLESaveController *saveController = (BLESaveController *)segue.destinationViewController;
            
            saveController.person = [self.fetchedResultsController.sections[indexPath.section]objects][indexPath.row];
        }
    }
  
}


#pragma mark tableView的数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.fetchedResultsController.sections[section] objects].count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"cell_id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Person *person = [self.fetchedResultsController.sections[indexPath.section] objects][indexPath.row];
    
    cell.textLabel.text = person.name;

    return cell;
    
}

#pragma mark tableView的数据源方法
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    
    return [self.fetchedResultsController.sections[section] name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self performSegueWithIdentifier:@"segue_id" sender:indexPath];
    
}

#pragma mark searchBar的代理方法

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length >0 ) {
        
        //定义谓词
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS %@",searchText];
        
        //给查询控制器的请求赋值谓词
        self.fetchedResultsController.fetchRequest.predicate = predicate;
        
        [self.fetchedResultsController performFetch:NULL];
       
    }else {
        
        self.fetchedResultsController.fetchRequest.predicate = nil;
        
        [self.fetchedResultsController performFetch:NULL];
        
    }
    
     [self.tableView reloadData];
    
}



#pragma mark  上下文发生改变的代理方法
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [self.fetchedResultsController performFetch:NULL];
    
    [self.tableView reloadData];
    
}


- (IBAction)addPerson:(id)sender {
    
    [self performSegueWithIdentifier:@"segue_id" sender:nil];
    
}



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.searchBar.delegate = self;
    
    [self.fetchedResultsController performFetch:NULL];
}
@end
