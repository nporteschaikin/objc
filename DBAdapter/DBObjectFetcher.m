//
//  DBObjectFetcher.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/17/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBObjectFetcher.h"
#import "DBObject.h"
#import "DBAdapter.h"

@interface DBObjectFetcher () {
    NSString *selectStatement;
    NSString *fromStatement;
    NSString *whereStatement;
    NSNumber *limitNumber;
    NSNumber *offsetNumber;
}

@end

@implementation DBObjectFetcher

- (id)initWithDBObject:(Class)DBObject {
    if (self = [super init]) {
        if (![DBObject isSubclassOfClass:[DBObject class]]) {
            return nil;
        }
        self.DBObject = DBObject;
    }
    return self;
}

- (NSString *)sqlQuery {
    NSMutableString *sqlQuery = [NSMutableString string];

    [sqlQuery appendString:[self selectStatement]];
    [sqlQuery appendString:[self fromStatement]];
    [sqlQuery appendString:[self whereStatement]];
    [sqlQuery appendString:[self limitStatement]];
    [sqlQuery appendString:[self offsetStatement]];

    return sqlQuery;
}

- (NSArray *)fetch {
    NSMutableArray *collection = [NSMutableArray array];
    DBObject *object;

    NSArray *records = [[DBAdapter dbAdapter] recordsByQuery:[self sqlQuery]];
    for (NSDictionary *record in records) {
        object = [[self.DBObject alloc] init];
        for (NSString *key in record) {
            id value = [record valueForKey:key];
            [object setValue:value forKey:key];
        }
        [collection addObject:object];
    }

    return collection;
}

- (NSString *)selectStatement {
    if (!selectStatement) {
        selectStatement = @"*";
    }
    return [NSString stringWithFormat:@"SELECT %@", selectStatement];
}

- (NSString *)fromStatement {
    return [NSString stringWithFormat:@" FROM %@", [self.DBObject performSelector:@selector(tableName)]];
}

- (NSString *)whereStatement {
    NSMutableString *statement = [NSMutableString string];
    if (whereStatement) {
        [statement appendFormat:@" WHERE %@", whereStatement];
    }
    return statement;
}

- (NSString *)limitStatement {
    NSMutableString *statement = [NSMutableString string];
    if (limitNumber) {
        [statement appendFormat:@" LIMIT %@", limitNumber];
    }
    return statement;
}

- (NSString *)offsetStatement {
    NSMutableString *statement = [NSMutableString string];
    if (offsetNumber) {
        [statement appendFormat:@" OFFSET %@", offsetNumber];
    }
    return statement;
}

- (void)setWhere:(id)firstCondition, ... {
    NSMutableArray *sqlArguments = [NSMutableArray array];

    va_list arguments;
    va_start(arguments, firstCondition);
    id condition = firstCondition;

    while (condition) {
        if ([condition isKindOfClass:[NSDictionary class]]) {
            for (NSString *key in (NSDictionary *)condition) {
                id value = [condition objectForKey:key];
                [sqlArguments addObject:[NSString stringWithFormat:@"%@ = \"%@\"", key, value]];
            }
        } else if ([condition isKindOfClass:[NSString class]]) {
            [sqlArguments addObject:(NSString *)condition];
        }
        condition = va_arg(arguments, id);
    }

    va_end(arguments);
    whereStatement = [sqlArguments componentsJoinedByString:@" AND "];
}

- (void)setColumns:(id)firstColumn, ... {
    NSMutableArray *sqlColumns = [NSMutableArray array];

    va_list arguments;
    va_start(arguments, firstColumn);
    id column = firstColumn;
    while (column) {
        [sqlColumns addObject:column];
        column = va_arg(arguments, id);
    }

    va_end(arguments);
    selectStatement = [sqlColumns componentsJoinedByString:@", "];
}

- (void)setLimit:(NSNumber *)limit {
    limitNumber = limit;
}

- (void)setOffset:(NSNumber *)offset {
    offsetNumber = offset;
}

@end
