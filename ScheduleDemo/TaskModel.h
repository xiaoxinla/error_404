//
//  TaskModel.h
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/20.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (nonatomic) NSInteger taskId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) long long alertTime;
@property (nonatomic) NSInteger frequency;
@property (nonatomic) NSInteger status;
@property (nonatomic) NSInteger priority;

@end
