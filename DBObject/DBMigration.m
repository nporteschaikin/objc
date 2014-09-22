//
//  DBMigration.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/22/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBMigration.h"

@implementation DBMigration

@synthesize upQuery = _upQuery;
@synthesize downQuery = _downQuery;

- (id)initWithUp:(NSString *)upQuery
        withDown:(NSString *)downQuery {
    if (self = [super init]) {
        self.upQuery = upQuery;
        self.downQuery = downQuery;
    }
    return self;
}

@end
