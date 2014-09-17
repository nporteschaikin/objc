//
//  DBObject.h
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/12/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBObjectFetcher.h"
#import "DBAdapter.h"

@interface DBObject : NSObject

+ (NSString *)tableName;
+ (NSArray *)tableColumns;

+ (DBObjectFetcher *)objectFetcher;

- (BOOL)save;
- (BOOL)destroy;

@end
