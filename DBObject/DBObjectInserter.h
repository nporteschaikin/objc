//
//  DBObjectInserter.h
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBObject.h"

@interface DBObjectInserter : NSObject

- (id)initWithDBObject:(DBObject *)dbObject;
- (NSNumber *)execute;

@end
