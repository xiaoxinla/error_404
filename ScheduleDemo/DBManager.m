//
//  DBManager.m
//  ScheduleDemo
//
//  Created by LiuYihan on 15/8/20.
//  Copyright (c) 2015年 Xiaoxin. All rights reserved.
//

// TODO : 1.增加step表，属性包括： _id(INTEGER PRIMARY KEY AUTOINCREMENT), taskId(INTEGER)

#import "DBManager.h"
#import <FMDB/FMDB.h>

static NSString *scheduleDbName =  @"schedule.db";
static NSString *tastTableName = @"task";
static NSString *idColumn = @"_id";
static NSString *titleColumn = @"title";
static NSString *frequencyColumn = @"frequency";
static NSString *statusColumn = @"status";
static NSString *priorityColumn = @"priority";
static NSString *alerttimeColumn = @"alerttime";
@interface DBManager()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DBManager

- (instancetype)init {
    if (self = [super init]) {
        NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *dbpath   = [docsPath stringByAppendingPathComponent:scheduleDbName];
        self.db = [FMDatabase databaseWithPath:dbpath];
        [self createTable];
//        [self testSql];
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
//    [self deleteTaskById:2];
    NSArray *array = [self queryAllTasks];
    NSLog(@"arraySize=%lu",(unsigned long)[array count]);
    
}

#pragma mark - db operation

- (void)createTable {
    if ([self.db open]) {
        NSString *createSql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ INTEGER PRIMARY KEY AUTOINCREMENT, %@ TEXT, %@ TIMESTAMP, %@ INTEGER, %@ INTEGER, %@ INTEGER)", tastTableName, idColumn, titleColumn, alerttimeColumn, frequencyColumn, statusColumn, priorityColumn];
        BOOL res = [self.db executeUpdate:createSql];
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
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (%@, %@, %@, %@, %@) VALUES (?, ?, ?, ?, ?)", tastTableName, titleColumn, alerttimeColumn, frequencyColumn, statusColumn, priorityColumn];
        NSArray *paramArray = @[model.title, @(model.alertTime), @(model.frequency),@(model.status), @(model.priority)];
        BOOL res = [self.db executeUpdate:insertSql withArgumentsInArray:paramArray];
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
        NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = ?", tastTableName, idColumn];
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
        NSString *updateSql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ?, %@ = ?, %@ = ?, %@ = ?, %@ = ? WHERE _id = ?", tastTableName, titleColumn, alerttimeColumn, frequencyColumn, statusColumn, priorityColumn];
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
    NSArray *array = nil;
    if ([self.db open]) {
        NSString *querySql = [NSString stringWithFormat:@"SELECT * FROM %@",tastTableName];
        FMResultSet *result = [self.db executeQuery:querySql];
        array = [self getTaskResultFromResultSet:result];
        [self.db close];
    }
    return array;
}

- (NSArray *)queryTasksByStatus:(TaskStatus)status {
    NSArray *array = nil;
    if ([self.db open]) {
        NSString *queryString = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ?", tastTableName, statusColumn];
        FMResultSet *result = [self.db executeQuery:queryString];
        array = [self getTaskResultFromResultSet:result];
        [self.db close];
    }
    
    return array;
}

- (NSArray *)getTaskResultFromResultSet:(FMResultSet *)result {
    NSMutableArray *array = [[NSMutableArray alloc] init];
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
    return array;
}

@end
