//
//  myDB.h
//  TaiQi-ExamQuestionBank
//
//  Created by cui wang on 13-7-10.
//  Copyright (c) 2013年 cui wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"


@interface myDB : NSObject
@property (retain, nonatomic) FMDatabase *DB;

//+ (id)modelWithDBName:(NSString *)dbName;
- (id)initWithDBName:(NSString *)dbName;
// 删除数据库
- (void)deleteDatabse:(NSString *)dbname;
//关闭数据库
- (void) close;
// 判断是否存在表
- (BOOL) isTableOK:(NSString *)tableName;
// 获得表的数据条数
- (int) getTableItemCount:(NSString *)tableName;
// 创建表
- (BOOL) createTable:(NSString *)tableName withArguments:(NSString *)arguments;
// 删除表-彻底删除表
-(void)deleteTable:(NSString *)tableName;
// 清除表-清数据
- (BOOL) eraseTable:(NSString *)tableName;
// 插入数据
- (BOOL)insertTable:(NSString*)tbName Where:(NSString *)where Values:(NSArray *)value Num:(NSString *)num;
//删除数据
-(BOOL)deleteTableValue:(NSString *)tbName Where:(NSString *)where IS:(NSString *)value And:(BOOL)and Where2:(NSString *)where2 IS2:(NSString *)value2;
// 修改数据
-(BOOL)updateTable:(NSString *)tbname SetName:(NSString *)setName WhereName:(NSString *)whereName UserValue:(NSArray *)value;
// 查询数据
-(FMResultSet *)findinTable:(NSString *)sql;

// 整型
- (NSInteger)getDb_Integerdata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 布尔型
- (BOOL)getDb_Booldata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 字符串型
- (NSString *)getDb_Stringdata:(NSString *)tableName withFieldName:(NSString *)fieldName;
// 二进制数据型
- (NSData *)getDb_Bolbdata:(NSString *)tableName withFieldName:(NSString *)fieldName;

@end
