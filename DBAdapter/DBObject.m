//
//  DBObject.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/12/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBObject.h"

@implementation DBObject

+ (void)initialize {
    [super initialize];
}

+ (DBAdapter *)dbAdapter {
    return [DBAdapter dbAdapter];
}

+ (NSString *)tableName {
    static NSString *tableName;
    if (!tableName) {
        tableName = [NSStringFromClass(self) lowercaseString];
    }
    return NSStringFromClass(self);
}

+ (NSArray *)tableColumns {
    static NSArray *tableColumns;
    if (!tableColumns) {
        NSString *queryString = [NSString stringWithFormat:@"PRAGMA table_info(%@)", [self tableName]];
        tableColumns = [[self dbAdapter] recordsByQuery:queryString];
    }
    return tableColumns;
}

+ (DBObjectFetcher *)objectFetcher {
    DBObjectFetcher *objectFetcher = [[DBObjectFetcher alloc] initWithDBObject:[self class]];
    return objectFetcher;
}

@end
