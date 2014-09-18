//
//  DBColumnFetcher.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBColumnFetcher.h"
#import "DBColumn.h"
#import "DBAdapter.h"
#import "DBObject.h"
#import "DBColumnFetcher.h"
#import "DBObjectAccessorHelper.h"

@interface DBColumnFetcher () {
    Class _DBObjectClass;
}

@end

@implementation DBColumnFetcher

- (id)initWithDBObjectClass:(Class)DBObjectClass {
    if (self = [super init]) {
        _DBObjectClass = DBObjectClass;
    }
    return self;
}

- (NSMutableSet *)fetch {
    NSMutableSet *columns = [NSMutableSet set];
    NSString *sqlQuery = [NSString stringWithFormat:@"PRAGMA table_info('%@')", [_DBObjectClass performSelector:@selector(tableName)]];
    
    NSArray *sqlColumns = [[DBAdapter dbAdapter] recordsByQuery:sqlQuery];
    for (NSDictionary *sqlColumn in sqlColumns) {
        DBColumn *column = [[DBColumn alloc] initWithDBObjectClass:_DBObjectClass
                                                          withName:sqlColumn[@"name"]
                                                          withType:sqlColumn[@"type"]];
        [columns addObject:column];
        
    }
    return columns;
}

@end
