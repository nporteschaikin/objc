//
//  DBObjectFetcher.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/17/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBObjectFetcher.h"
#import <objc/runtime.h>
#import "DBObject.h"
#import "DBDatabase.h"

@interface DBObjectFetcher () {
    Class _DBObjectClass;
    NSString * _selectStatement;
    NSString * _fromStatement;
    NSString * _whereStatement;
    NSNumber * _limitNumber;
    NSNumber * _offsetNumber;
}

@end

@implementation DBObjectFetcher

- (id)initWithDBObjectClass:(Class)DBObjectClass {
    if (self = [super init]) {
        _DBObjectClass = DBObjectClass;
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
    
    NSArray *records = [[DBDatabase sharedDatabase] executeQuery:[self sqlQuery]];
    for (NSDictionary *record in records) {
        object = (DBObject *)[[_DBObjectClass alloc] init];
        for (NSString *key in record) {
            DBColumn *column = [_DBObjectClass performSelector:@selector(columnNamed:)
                                                    withObject:key];
            id value = [record valueForKey:key];
            objc_setAssociatedObject(object,
                                     column.key,
                                     value,
                                     OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [collection addObject:object];
    }
    
    return collection;
}

- (NSString *)selectStatement {
    if (!_selectStatement) {
        _selectStatement = @"*";
    }
    return [NSString stringWithFormat:@"SELECT %@", _selectStatement];
}

- (NSString *)fromStatement {
    return [NSString stringWithFormat:@" FROM %@", [[_DBObjectClass class] performSelector:@selector(tableName)]];
}

- (NSString *)whereStatement {
    NSMutableString *statement = [NSMutableString string];
    if (_whereStatement) {
        [statement appendFormat:@" WHERE %@", _whereStatement];
    }
    return statement;
}

- (NSString *)limitStatement {
    NSMutableString *statement = [NSMutableString string];
    if (_limitNumber) {
        [statement appendFormat:@" LIMIT %@", _limitNumber];
    }
    return statement;
}

- (NSString *)offsetStatement {
    NSMutableString *statement = [NSMutableString string];
    if (_offsetNumber) {
        [statement appendFormat:@" OFFSET %@", _offsetNumber];
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
    _whereStatement = [sqlArguments componentsJoinedByString:@" AND "];
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
    _selectStatement = [sqlColumns componentsJoinedByString:@", "];
}

- (void)setLimit:(NSNumber *)limit {
    _limitNumber = limit;
}

- (void)setOffset:(NSNumber *)offset {
    _offsetNumber = offset;
}

@end
