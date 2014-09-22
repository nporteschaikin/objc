//
//  DBColumn.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBColumn.h"
#import "DBObject.h"

@interface DBColumn () {
    char *columnKey;
}

@property (strong, nonatomic, readwrite) Class DBObjectClass;
@property (strong, nonatomic, readwrite) NSString *name;
@property (strong, nonatomic, readwrite) NSString *type;
@property (nonatomic, readwrite) BOOL isPrimaryKey;

@end

@implementation DBColumn

- (id)initWithDBObjectClass:(Class)DBObjectClass
                   withName:(NSString *)name
                   withType:(NSString *)type
               isPrimaryKey:(BOOL)isPrimaryKey {
    if (self = [super init]) {
        self.DBObjectClass = DBObjectClass;
        self.name = name;
        self.type = type;
        self.isPrimaryKey = isPrimaryKey;
    }
    return self;
}

- (SEL)getterSelector {
    return NSSelectorFromString(self.name);
}

- (SEL)setterSelector {
    NSString *setterSelector = [NSString stringWithFormat:@"set%@:", [self.name stringWithUppercaseFirst]];
    return NSSelectorFromString(setterSelector);
}

- (char *)key {
    return (char *)[self.name UTF8String];
}

@end
