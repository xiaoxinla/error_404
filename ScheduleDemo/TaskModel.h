//
//  TaskModel.h
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/20.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>

// 任务状态的枚举
typedef NS_ENUM(NSUInteger, TaskStatus) {
    TaskRunning = 0,    /**< 表示任务正在进行中*/
    TAskTodo,           /**< 表示任务还未开始*/
    TaskDone,           /**< 表示任务已经完成*/
};

@interface TaskModel : NSObject

@property (nonatomic) NSInteger taskId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) long long alertTime;
@property (nonatomic) NSInteger frequency;
@property (nonatomic) TaskStatus status;
@property (nonatomic) NSInteger priority;

@end
