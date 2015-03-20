//
//  ZQDatePicker.h
//  TestDatePicker
//
//  Created by Mr Chow on 14-5-3.
//  Copyright (c) 2014年 Ant. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedBlock)(NSDate *date);

@protocol ZQDatePickerDelegate;
@interface ZQDatePicker : UIView

@property (nonatomic) NSDate *currentDate;
@property (nonatomic, readonly) NSDate *selectedDate;
@property (nonatomic) UIColor *selectedColor;
@property (assign, nonatomic) NSInteger showMaxDays;
@property (assign, nonatomic) NSInteger onePageNumber;
@property (nonatomic, strong) SelectedBlock selectedBlock;
@property (nonatomic, weak) id <ZQDatePickerDelegate> delegate;
@end

@protocol ZQDatePickerDelegate <NSObject>

@optional
- (void)datePickerView:(ZQDatePicker *)picker didSelectedWithDate:(NSDate *)date;

@end
