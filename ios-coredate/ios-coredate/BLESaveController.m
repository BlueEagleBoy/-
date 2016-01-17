//
//  BLESaveController.m
//  ios-coredate
//
//  Created by BlueEagleBoy on 16/1/14.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLESaveController.h"
#import "Person.h"
#import "BLEDataManager.h"
#import "Title.h"
#import "BLETitleListTableViewController.h"

@interface BLESaveController ()<UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *birthdayField;
@property (nonatomic)NSDateFormatter *dateFormatter;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *descField;

@property (nonatomic)Title *selectedTitle;


@end

@implementation BLESaveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameField.text = self.person.name;
    self.birthdayField.text = [self.dateFormatter stringFromDate:self.person.birthday];
    self.descField.text = self.person.desc;
    self.titleField.text = self.person.title.titleName;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSelectedTitle:) name:HMSelectTitleNotification object:nil];
    
    
    [self setupBirthdayFeildMode];
    
}

- (void)didSelectedTitle:(NSNotification *)notify {
    
    self.selectedTitle = notify.object;
    self.titleField.text = [notify.object titleName];
    
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//由于formatter和calender初始化比较消耗性能的 所以我们应该设置一个懒加载 不能重复初始化
- (NSDateFormatter *)dateFormatter {
    
    if (!_dateFormatter ) {
        
        _dateFormatter = [[NSDateFormatter alloc]init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd";
  
    }
    return _dateFormatter;
}

- (void)setupBirthdayFeildMode {
    
    //创建datepicker 修改生日textFeild 的弹出视图
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    //监听datepicker的改变
    [datePicker addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
    self.birthdayField.inputView = datePicker;

}
//监听datapicker改变的方法
- (void)didChangeValue:(UIDatePicker *)picker {
    NSString *dateString = [self.dateFormatter stringFromDate:picker.date];
    self.birthdayField.text = dateString;
}

- (IBAction)save:(id)sender {
    
    Person *person;
    if (self.person == nil) {
        person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:[BLEDataManager sharedManage].managedObjectContext];

    }else {
        
        person = self.person;
        
    }

    person.name = self.nameField.text;
    person.birthday = [self.dateFormatter dateFromString:self.birthdayField.text];
    person.desc = self.descField.text;

    person.title = self.selectedTitle;
    
    if (self.nameField.text == nil && self.selectedTitle.titleName == nil) {

        [[BLEDataManager sharedManage] saveContext];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"pop_identifier"]) {
        
        UIPopoverPresentationController *popover = segue.destinationViewController.popoverPresentationController;
        
        popover.delegate = self;
        
    }
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
    

}







@end
