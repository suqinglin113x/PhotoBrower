//
//  OCViewController.m
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/10.
//  Copyright © 2021 苏庆林. All rights reserved.
//

#import "OCViewController.h"

#import "PhotoBrower-Swift.h"

NSString *const kFosunholidayURL = @"https://admintest.fosunholiday.com";
@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TestModel *model = [TestModel new];
    model.name = @"sda";
    model.age = @"30";
    NSLog(@"%@", model.age);
    
    TCIMCustomerModel *model2 = [TCIMCustomerModel new];
    model2.name = @"sda";
    model2.isChatted = NO;
//    NSLog(@"%@", model.age);
}

- (void)dealloc {
    NSLog(@"假按揭啊");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
