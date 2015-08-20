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
#define dbpath @"/db/schedule.db"

@interface DBManager()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation DBManager

- (instancetype)init {
    if (self = [super init]) {
        self.db = [FMDatabase databaseWithPath:@"/tmp/tmp.db"];
        [self createTable];
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

- (void)insert:(TaskModel *)model {
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO task (title, alerttime, frequncy, status, priority) VALUES (%@, %lld, %ld, %ld, %ld)", model.title,model.alertTime,(long)model.frequency,(long)model.status,(long)model.priority];
    BOOL res = [self.db executeUpdate:insertSql];
    if (res) {
        NSLog(@"insert success");
    } else {
        NSLog(@"insert error");
    }
}

@end
