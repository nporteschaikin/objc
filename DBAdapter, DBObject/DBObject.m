//
//  DBObject.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/12/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <objc/runtime.h>
#import "DBObject.h"
#import "DBObjectAccessorHelper.h"
#import "DBColumnFetcher.h"
#import "DBObjectInsert.h"

@interface DBObject ()

@property (strong, nonatomic, readwrite) NSNumber *id;
@property (strong, nonatomic, readwrite) NSMutableSet *changedColumns;

@end

@implementation DBObject

+ (void)initialize {
    if ([self class] != [DBObject class]) {
        [self initializeAccessors];
    }
}

+ (void)initializeAccessors {
    for (DBColumn *column in [self columns]) {
        [DBObjectAccessorHelper setAccessorForColumn:column];
    }
}

+ (NSString *)tableName {
    static NSString *tableName;
    if (!tableName) {
        tableName = [NSStringFromClass([self class]) lowercaseString];
    }
    return tableName;
}

+ (DBColumnFetcher *)columnFetcher {
    DBColumnFetcher *columnFetcher = [[DBColumnFetcher alloc] initWithDBObjectClass:self];
    return columnFetcher;
}

+ (DBObjectFetcher *)objectFetcher {
    DBObjectFetcher *objectFetcher = [[DBObjectFetcher alloc] initWithDBObjectClass:self];
    return objectFetcher;
}

+ (NSSet *)columns {
    static NSSet *columns;
    if (!columns) {
        columns = [[self columnFetcher] fetch];
    }
    return columns;
}

+ (DBColumn *)columnNamed:(NSString *)columnName {
    for (DBColumn *column in [self columns]) {
        if ([column.name isEqualToString:columnName]) {
            return column;
        }
    }
    return nil;
}

+ (DBColumn *)columnWithSetterSelector:(SEL)setterSelector {
    for (DBColumn *column in [self columns]) {
        if (column.setterSelector == setterSelector) {
            return column;
        }
    }
    return nil;
}

+ (DBColumn *)columnWithGetterSelector:(SEL)getterSelector {
    for (DBColumn *column in [self columns]) {
        if (column.getterSelector == getterSelector) {
            return column;
        }
    }
    return nil;
}

- (void)setValue:(id)value forColumn:(DBColumn *)column {
    objc_setAssociatedObject(self, column.key, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (!self.changedColumns) {
        self.changedColumns = [NSMutableSet set];
    }
    [self.changedColumns addObject:column];
}

- (id)valueForColumn:(DBColumn *)column {
    return objc_getAssociatedObject(self, column.key);
}

- (void)save {
    if (self.id) {
        // update
    } else {
        DBObjectInsert *dbObjectInsert = [[DBObjectInsert alloc] initWithDBObject:self];
        self.id = [dbObjectInsert execute];
    }
}

@end
