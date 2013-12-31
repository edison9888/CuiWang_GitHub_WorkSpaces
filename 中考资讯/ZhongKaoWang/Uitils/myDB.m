//
//  myDB.m
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-10.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import "myDB.h"


@interface myDB ()

@end

@implementation myDB

@synthesize DB;

static myDB * _sharedInstance = nil;
//方法实现
+ (id) sharedInstance
{
    @synchronized ([myDB class])
    {
    if (_sharedInstance == nil)
        {
        _sharedInstance = [[myDB alloc] init];
        }
    }
    return _sharedInstance;
}

// 打开数据库
- (id)initWithDBName:(NSString *)dbName
{
    DB= [FMDatabase databaseWithPath:[self getPath:dbName]] ;
    
    if (![DB open])
    {
        DLog(@"Could not open db.  %@",dbName);
    } else {
        DLog(@"数据库 %@  正常打开!",dbName);
    }
    return self;
}

// 数据库存储路径(内部使用)
- (NSString *)getPath:(NSString *)dbName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:dbName];
}

#pragma mark 删除数据库
// 删除数据库
- (void)deleteDatabse:(NSString *)dbname
{
    BOOL success;
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    dbname = [self getPath:dbname];
   
        success = [fileManager removeItemAtPath:dbname error:&error];
        DLog(@"成功删除数据库? %@",success?@"YES":@"NO");
        if (!success) {
            DLog( @"删除数据库失败 '%@'.", [error localizedDescription]);
        }

}
// 删除表
-(void)deleteTable:(NSString *)tableName
{
    NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@",tableName];
    if ([DB executeUpdate:sql])
    {
        DLog(@"删除表 %@ 成功",tableName);
    }
    else
        {
            DLog(@"删除表 %@ 失败",tableName);
        }
}
//判断是否存在数据库
-(BOOL)isDBOK:(NSString *)dbName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    dbName = [self getPath:dbName];
    if ([fileManager fileExistsAtPath:dbName]) {
        return YES;
    } else {
        return NO;
    }
}
// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName
{
    if ([DB tableExists:tableName]) {
        return YES;
    }
    return NO;
}

// 获得表的数据条数
- (int) getTableItemCount:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"SELECT COUNT(*)  FROM %@", tableName];
    FMResultSet *rs = [DB executeQuery:sqlstr];
    while ([rs next])
        {
        int count = [rs intForColumnIndex:0];
        DLog(@"TableItemCount %d", count);
        return count;
        }
    return 0;
}

// 创建表
- (BOOL) createTable:(NSString *)tableName withArguments:(NSString *)arguments
{
    NSString *sqlstr = [NSString stringWithFormat:@"CREATE TABLE %@ (%@)", tableName, arguments];
    if (![DB executeUpdate:sqlstr])
        //if ([DB executeUpdate:@"create table user (name text, pass text)"] == nil)
        {
        DLog(@"创建表 %@ 失败",tableName);
        return NO;
        }
    else
        {
            DLog(@"创建表 %@ 成功",tableName);
        }
    
    return YES;
}

// 清除表
- (BOOL) eraseTable:(NSString *)tableName
{
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![DB executeUpdate:sqlstr])
        {
        DLog(@"Erase table error!");
        return NO;
        }
    
    return YES;
}

// 插入数据
- (BOOL)insertTable:(NSString*)tbName Where:(NSString *)where Values:(NSArray *)value Num:(NSString *)num
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@)",tbName,where,num];
      if(![DB executeUpdate:sql withArgumentsInArray:value])
          {
          DLog(@"表 %@ 数据插入失败!",tbName);
          return NO;
          }
      else{
          DLog(@"表 %@ 数据插入成功!",tbName);
      }
    return YES;
}
//删除数据
-(BOOL)deleteTableValue:(NSString *)tbName Where:(NSString *)where IS:(NSString *)value And:(BOOL)isand Where2:(NSString *)where2 IS2:(NSString *)value2
{
    NSString *sql;
    if (isand) {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%@ AND %@=%@",tbName,where,value,where2,value2];
        DLog(@"%@",sql);
    } else {
        sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@=%@",tbName,where,value];
        DLog(@"%@",sql);
    }
    if(![DB executeUpdate:sql])
        {
        DLog(@"表 = %@    %@ =   %@ 删除失败!",tbName,where,value);
        return NO;
        }else
            {
             DLog(@"表 = %@    %@ =   %@ 删除成功!",tbName,where,value);
            }
    return YES;
}
// 修改数据
-(BOOL)updateTable:(NSString *)tbname SetName:(NSString *)setName WhereName:(NSString *)whereName UserValue:(NSArray *)value
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ? ",tbname,setName,whereName];
    if(![DB executeUpdate:sql withArgumentsInArray:value])
        {
            DLog(@"表 %@ 数据更新失败!",tbname);
        return NO;
        }
    else
        {
             DLog(@"表 %@ 数据更新成功! 把 %@ 更新成了 %@",tbname,setName,value);
        return YES;
        }
    return YES;
}
//查询数据
-(FMResultSet *)findinTable:(NSString *)sql
{
    DLog(@"findinTable sql:  \n %@",sql);
    return  [DB executeQuery:sql];
}
// 暂时无用

#pragma mark 获得单一数据

// 整型
- (NSInteger)getDb_Integerdata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    NSInteger result = NO;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [DB executeQuery:sql];
    if ([rs next])
        result = [rs intForColumnIndex:0];
    [rs close];
    
    return result;
}

// 布尔型
- (BOOL)getDb_Booldata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    BOOL result;
    
    result = [self getDb_Integerdata:tableName withFieldName:fieldName];
    
    return result;
}

// 字符串型
- (NSString *)getDb_Stringdata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    NSString *result = NO;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [DB executeQuery:sql];
    if ([rs next])
        result = [rs stringForColumnIndex:0];
    [rs close];
    
    return result;
}

// 二进制数据型
- (NSData *)getDb_Bolbdata:(NSString *)tableName withFieldName:(NSString *)fieldName
{
    NSData *result = NO;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT %@ FROM %@", fieldName, tableName];
    FMResultSet *rs = [DB executeQuery:sql];
    if ([rs next])
        result = [rs dataForColumnIndex:0];
    [rs close];
    
    return result;
}
/// 关闭连接
- (void) close {
	[DB close];
}
@end
