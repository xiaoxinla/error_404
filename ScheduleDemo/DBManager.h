//
//  DBManager.h
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/20.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskModel.h"

@interface DBManager : NSObject

- (void)insertTask:(TaskModel *)model;
- (void)updateTask:(TaskModel *)model;
- (void)deleteTaskById:(NSInteger)taskId;
- (NSArray *)queryAllTasks;
- (NSArray *)queryTasksByStatus:(TaskStatus)status;

+ (instancetype)manager;

@end
