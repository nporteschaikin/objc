//
//  DBObjectUpdater.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBObjectUpdater.h"
#import "DBAdapter.h"

@interface DBObjectUpdater () {
    DBObject * _DBObject;
}

@end

@implementation DBObjectUpdater

- (id)initWithDBObject:(DBObject *)DBObject {
    if (self = [super init]) {
        _DBObject = DBObject;
    }
    return self;
}

- (BOOL)execute {
    if ([_DBObject.changedColumns count]) {
        NSString *sqlQuery = [self sqlQuery];
        if ([[DBAdapter dbAdapter] executeQuery:sqlQuery]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)sqlQuery {
    NSString *tableName = [[_DBObject class] tableName];
    DBColumn *primaryKeyColumn = [[_DBObject class] primaryKeyColumn];
    NSNumber *primaryKeyValue = [_DBObject valueForColumn:primaryKeyColumn];
    NSMutableArray *sqlArguments = [NSMutableArray array];
    
    for (DBColumn *column in _DBObject.changedColumns) {
        [sqlArguments addObject:[NSString stringWithFormat:@"%@ = \"%@\"",
                                    column.name, [_DBObject valueForColumn:column]]];
    }
    
    return [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = %@",
                tableName, [sqlArguments componentsJoinedByString:@", "], primaryKeyColumn.name, primaryKeyValue];
}

@end
