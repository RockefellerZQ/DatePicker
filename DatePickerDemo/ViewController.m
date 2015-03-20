//
//  ViewController.m
//  DatePickerDemo
//
//  Created by Rocke on 3/20/15.
//  Copyright (c) 2015 Rocke. All rights reserved.
//

#import "ViewController.h"
#import "ZQDatePicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    ZQDatePicker *picker = [[ZQDatePicker alloc]
                            initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
    picker.backgroundColor = [UIColor colorWithRed:107/255.0 green:90/255.0 blue:161/255.0 alpha:1];
    [picker setSelectedColor:[UIColor colorWithRed:141/255.0 green:141/255.0 blue:196/255.0 alpha:1]];
    [picker setCurrentDate:[NSDate date]];
    [picker setSelectedBlock:^(NSDate *date) {
        NSLog(@"%@", date.description);
    }];
    [self.view addSubview:picker];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
