//
//  DBManager.m
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/20.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

#import "DBManager.h"
#import <FMDB/FMDB.h>
#import "TaskModel.h"

NSString *dbpath = @"/tmp/tmp.db";

@interface DBManager()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DBManager

- (instancetype)init {
    if (self = [super init]) {
        self.db = [FMDatabase databaseWithPath:dbpath];
        [self createTable];
        [self testSql];
    }
    return self;
}

+ (instancetype)manager {
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

- (void)testSql {
    TaskModel *model1 = [[TaskModel alloc] init];
    model1.title = @"title1";
    model1.alertTime = [[NSDate date] timeIntervalSince1970];
    model1.frequency = 1;
    model1.status = 1;
    model1.priority = 1;
    [self insertTask:model1];
    [self deleteTaskById:2];
    NSArray *array = [self queryAllTasks];
    NSLog(@"array=%lu",(unsigned long)[array count]);
    
}

#pragma mark - db operation

- (void)createTable {
    if ([self.db open]) {
        NSString *tableCreateSql = @"CREATE TABLE IF NOT EXISTS task(_id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, alerttime TIMESTAMP, frequency INTEGER, status INTEGER, priority INTEGER);";
        BOOL res = [self.db executeUpdate:tableCreateSql];
        if (!res) {
            NSLog(@"create error");
        } else {
            NSLog(@"create success");
        }
        [self.db close];
    }
}

- (void)insertTask:(TaskModel *)model {
    if ([self.db open]) {
        NSString *insertSql = @"INSERT INTO task (title, alerttime, frequency, status, priority) VALUES (?, ?, ?, ?, ?)";
        NSArray *paramArray = @[model.title, @(model.alertTime), @(model.frequency),@(model.status), @(model.priority)];
        BOOL res = [self.db executeQuery:insertSql withArgumentsInArray:paramArray];
        if (res) {
            NSLog(@"insert success");
        } else {
            NSLog(@"insert error");
        }
        [self.db close];
    }
}


- (void)deleteTaskById:(NSInteger)taskId {
    if ([self.db open]) {
        NSString *deleteSql = @"DELETE FROM task WHERE _id = ?";
        BOOL res = [self.db executeUpdate:deleteSql,[NSNumber numberWithInteger:taskId]];
        if (res) {
            NSLog(@"delete success");
        } else {
            NSLog(@"delete error");
        }
        [self.db close];
    }
}

- (void)updateTask:(TaskModel *)model {
    if ([self.db open]) {
        NSString *updateSql = @"UPDATE task SET title = ?, alerttime = ?, frequency = ?, status = ?, priority = ? WHERE _id = ?";
        NSArray *paramArray  = @[model.title, @(model.alertTime), @(model.frequency), @(model.status), @(model.priority), @(model.taskId)];
        BOOL res = [self.db executeUpdate:updateSql withArgumentsInArray:paramArray];
        if (res) {
            NSLog(@"update success");
        } else {
            NSLog(@"update error");
        }
        [self.db close];
    }
}


- (NSArray *)queryAllTasks {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if ([self.db open]) {
    NSString *querySql = @"SELECT * FROM task";
    FMResultSet *result = [self.db executeQuery:querySql];
    while ([result next]) {
        TaskModel *model = [[TaskModel alloc] init];
        model.taskId = [result intForColumn:@"_id"];
        model.title = [result stringForColumn:@"title"];
        model.alertTime = [result longLongIntForColumn:@"alerttime"];
        model.frequency = [result intForColumn:@"frequency"];
        model.status = [result intForColumn:@"status"];
        model.priority = [result intForColumn:@"priority"];
        [array addObject:model];
    }
        [self.db close];
    }
    return array;
}

@end
