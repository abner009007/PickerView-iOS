//
//  ViewController.m
//  PickerView
//
//  Created by abner on 16/8/18.
//  Copyright © 2016年 abner. All rights reserved.
//

#import "ViewController.h"

#import "PickerView.h"
#import "CityListModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    PickerView * pickerView = [[PickerView alloc]initWithFrame:self.view.bounds];
    pickerView.enter_block = ^(NSString *province, NSString *city) {
        NSLog(@"------------%@--------%@",province,city);
    };
    [self.view addSubview:pickerView];
    
}




@end
