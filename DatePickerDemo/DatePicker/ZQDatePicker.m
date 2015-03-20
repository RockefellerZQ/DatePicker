//
//  ZQDatePicker.m
//  TestDatePicker
//
//  Created by Mr Chow on 14-5-3.
//  Copyright (c) 2014年 Ant. All rights reserved.
//

#import "ZQDatePicker.h"

@interface ZQDateCell : UICollectionViewCell

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *detailLabel;
@property (nonatomic) UIColor *selectedBackgroundColor;
@property (nonatomic) NSDate *date;
@property (nonatomic) NSCalendar *calender;

@end

@implementation ZQDateCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.detailLabel];
        self.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:0.6].CGColor;
        self.layer.borderWidth = 0.5;
        _calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [_calender setFirstWeekday:2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.detailLabel.textColor = [UIColor whiteColor];
    } else {
        self.titleLabel.textColor = [UIColor darkTextColor];
        self.detailLabel.textColor = [UIColor grayColor];
    }
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor darkTextColor]];
        [_titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (void)setDate:(NSDate *)date
{
    if (_date != date) {
        _date = date;
        self.titleLabel.text = [self titleForDate:_date];
        self.detailLabel.text = [self detailFromDate:_date];
    }
}

- (NSString *)titleForDate:(NSDate *)date
{
    NSDate *currentDate = [NSDate date];
    
    NSDateComponents *currentCom = [_calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:currentDate];
    
    NSDateComponents *dateCom = [_calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    
    NSString *string = nil;
    NSInteger dif = currentCom.day - dateCom.day;
    
    if (dif == 0) {
        string = @"今天";
    } else if (dif == 1) {
        string = @"昨天";
    } else if (dif == -1) {
        string = @"明天";
    } else {
        string = [self weekdayFromDate:date];
    }
    
    currentDate = nil;
    currentCom = nil;
    dateCom = nil;
    
    return string;
}

- (NSString *)detailFromDate:(NSDate *)date
{
    NSDate *currentDate = [NSDate date];
    
    
    NSDateComponents *currentCom = [_calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:currentDate];
    
    NSDateComponents *dateCom = [_calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    
    NSString *result = nil;
    NSInteger dif = currentCom.day - dateCom.day;
    
    if (dif == 0 || dif == 1 || dif == -1) {
        NSString *string = [self weekdayFromDate:date];
        result = [NSString stringWithFormat:@"%li-%li %@", (long)dateCom.month, (long)dateCom.day, string];
        string = nil;
    } else {
        result = [NSString stringWithFormat:@"%li-%li", (long)dateCom.month, (long)dateCom.day];
    }
    currentCom = nil;
    currentDate = nil;
    dateCom = nil;
    
    return result;
}

- (NSString *)weekdayFromDate:(NSDate *)date
{
    NSDateComponents *currentCom = [_calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:date];
    NSString *string = nil;
    switch (currentCom.weekday) {
        case 1:
            string = @"周日";
            break;
        case 2:
            string = @"周一";
            break;
        case 3:
            string = @"周二";
            break;
        case 4:
            string = @"周三";
            break;
        case 5:
            string = @"周四";
            break;
        case 6:
            string = @"周五";
            break;
        case 7:
            string = @"周六";
            break;
        default:
            break;
    }
    
    currentCom = nil;
    return string;
    
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    if (_selectedBackgroundColor != selectedBackgroundColor) {
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = selectedBackgroundColor;
        self.selectedBackgroundView = view;
        view = nil;
        _selectedBackgroundColor = selectedBackgroundColor;
    }
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel new];
        [_detailLabel setTextColor:[UIColor grayColor]];
        [_detailLabel setFont:[UIFont systemFontOfSize:12]];
        [_detailLabel setBackgroundColor:[UIColor clearColor]];
        [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _detailLabel;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    int space = 6;
    self.titleLabel.frame = CGRectMake(0, space, self.bounds.size.width, (self.bounds.size.height - space)/2);
    self.detailLabel.frame = CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), self.bounds.size.width, (self.bounds.size.height - space)/2);
}

- (void)dealloc
{
    _titleLabel = nil;
    _detailLabel = nil;
    _selectedBackgroundColor = nil;
    _date = nil;
    _calender = nil;
}

@end

static NSString *const dateCell = @"DateCellIndentifier";
@interface ZQDatePicker () <UICollectionViewDataSource, UICollectionViewDelegate>

{
    NSInteger itemWidth;
    NSInteger itemHeight;
    NSDate *minDate;
    CGRect middleRect;
}

@property (nonatomic) UICollectionView *collectionView;

@end

@implementation ZQDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _showMaxDays = 30;
        _onePageNumber = 3;
        _selectedColor = [UIColor cyanColor];
        self.clipsToBounds = YES;
        itemHeight = frame.size.height;
        itemWidth = frame.size.width / _onePageNumber;
        [self addSubview:self.collectionView];
        self.backgroundColor = [UIColor lightGrayColor];
        middleRect = CGRectMake(CGRectGetMidX(frame) - 5, 0, 10, frame.size.height);
        
    }
    return self;
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    if (_currentDate != currentDate) {
        _currentDate = currentDate;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        NSDateComponents *dateComplents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_currentDate];
        float middle = _showMaxDays / 2;
        NSInteger minDay = lrintf(middle);
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:minDay inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        dateComplents.day -= minDay;
        minDate = [calendar dateFromComponents:dateComplents];
        dateComplents = nil;
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, itemHeight) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        layout = nil;
        [_collectionView setClipsToBounds:NO];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setScrollEnabled:NO];
        [_collectionView registerClass:[ZQDateCell class] forCellWithReuseIdentifier:dateCell];
    }
    return _collectionView;
}

- (NSDate *)getDateFromMinDateWithDiffDays:(NSInteger)diffDays
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateCom = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:minDate];
    dateCom.day += diffDays;
    NSDate *date = [calendar dateFromComponents:dateCom];
    dateCom = nil;
    calendar = nil;
    return date;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _showMaxDays;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZQDateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:dateCell forIndexPath:indexPath];
    [cell setSelectedBackgroundColor:_selectedColor];
    NSDate *date = [self getDateFromMinDateWithDiffDays:indexPath.item];
    [cell setDate:date];
    date = nil;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZQDateCell *cell = (ZQDateCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _selectedDate = cell.date;
    NSInteger num = [self clickCell:cell IsInRightWithRect:middleRect];
    CGPoint currentPoint = collectionView.contentOffset;
    
    if (indexPath.item != 0) {
        if (num == 1) {
            [collectionView setContentOffset:CGPointMake(currentPoint.x + itemWidth, currentPoint.y) animated:YES];
        } else if (num == -1) {
            [collectionView setContentOffset:CGPointMake(currentPoint.x - itemWidth, currentPoint.y) animated:YES];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePickerView:didSelectedWithDate:)]) {
        [self.delegate datePickerView:self didSelectedWithDate:_selectedDate];
    }
    
    if (self.selectedBlock) {
        self.selectedBlock(_selectedDate);
    }
}

- (NSInteger)clickCell:(UICollectionViewCell *)cell IsInRightWithRect:(CGRect)rect
{
    CGRect cellFrame = cell.frame;
    CGRect new = [self convertRect:rect toView:self.collectionView];
    NSInteger result = 0;
    if (CGRectContainsRect(cellFrame, new)) {
        result = 0;
    } else {
        if (cellFrame.origin.x > new.origin.x) {
            result = 1;
        }
        
        if (cellFrame.origin.x < new.origin.x) {
            result = -1;
        }
    }
    // 0表示点击的是当前中间的这个cell， -1表示前一个， 1表示后一个
    
    return result;
}

- (void)dealloc
{
    _currentDate = nil;
    _selectedDate = nil;
    _selectedColor = nil;
    _selectedBlock = nil;
    minDate = nil;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
