//
//  DBObjectInsert.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBObjectInsert.h"
#import "DBAdapter.h"

@interface DBObjectInsert () {
    DBObject * _DBObject;
}

@end

@implementation DBObjectInsert

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
    NSMutableArray *columnsSql = [NSMutableArray arrayWithCapacity:columns.count];
    NSMutableArray *valuesSql = [NSMutableArray arrayWithCapacity:columns.count];
    
    for (DBColumn *column in columns) {
        [columnsSql addObject:column.name];
        [valuesSql addObject:[NSString stringWithFormat:@"\"%@\"", [_DBObject valueForColumn:column]]];
    }
    
    return [NSString stringWithFormat:
            @"INSERT INTO %@ (%@) VALUES (%@)",
            [[_DBObject class] tableName],
            [columnsSql componentsJoinedByString:@","],
            [valuesSql componentsJoinedByString:@","]];
}

@end
