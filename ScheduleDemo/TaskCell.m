//
//  TaskCell.m
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/26.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

#import "TaskCell.h"

@interface TaskCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation TaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.titleLabel = [[UILabel alloc] initWithFrame:(CGRect){10,10,100,40}];
    self.titleLabel.text = @"This is title!";
    [self addSubview:self.titleLabel];
    self.timeLabel = [[UILabel alloc] initWithFrame:(CGRect){self.frame.size.width-50,10,50,40}];
    [self addSubview:self.timeLabel];
    self.timeLabel.text = @"12:20";
}

@end
