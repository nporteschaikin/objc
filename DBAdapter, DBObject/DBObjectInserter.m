//
//  DBObjectInserter.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBObjectInserter.h"
#import "DBAdapter.h"

@interface DBObjectInserter () {
    DBObject * _DBObject;
}

@end

@implementation DBObjectInserter

- (id)initWithDBObject:(DBObject *)DBObject {
    if (self = [super init]) {
        _DBObject = DBObject;
    }
    return self;
}

- (NSNumber *)execute {
    NSString *sqlQuery = [self sqlQuery];
    if ([[DBAdapter dbAdapter] executeQuery:sqlQuery]) {
        return [[DBAdapter dbAdapter] lastInsertRowId];
    }
    return nil;
}

- (NSString *)sqlQuery {
    NSSet *columns = _DBObject.changedColumns;
    
    if (columns) {
        NSMutableArray *columnsSql = [NSMutableArray array];
        NSMutableArray *valuesSql = [NSMutableArray array];
        NSString *tableName = [[_DBObject class] tableName];
        
        for (DBColumn *column in columns) {
            [columnsSql addObject:column.name];
            [valuesSql addObject:[NSString stringWithFormat:@"\"%@\"", [_DBObject valueForColumn:column]]];
        }
        
        return [NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (%@);",
            tableName, [columnsSql componentsJoinedByString:@","], [valuesSql componentsJoinedByString:@","]];
        
    }
    return nil;
}

@end
