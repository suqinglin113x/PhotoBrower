//
//  OCViewController.m
//  PhotoBrower
//
//  Created by 苏庆林 on 2021/3/10.
//  Copyright © 2021 苏庆林. All rights reserved.
//

#import "OCViewController.h"
NSString *const kFosunholidayURL = @"https://admintest.fosunholiday.com";
@interface OCViewController ()

@end

@implementation OCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getNewToken];
    
}

- (NSString *)getNewToken {
//    NSString *token = @""
//    NSString *url = [NSString stringWithFormat:@"%@/usercenter/online/mem/getMemberDetails", kFosunholidayURL];
//    [[FLDURLSessionManager sharedManager] dataTaskWithHTTPMethod:@"POST" URLString:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
// 
//    return token;
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
