//
//  DBObjectFetcher.h
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/17/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBObjectFetcher : NSObject

- (id)initWithDBObjectClass:(Class)DBObjectClass;
- (NSArray *)fetch;

- (void)setColumns:(id)arguments, ... NS_REQUIRES_NIL_TERMINATION;
- (void)setWhere:(id)arguments, ... NS_REQUIRES_NIL_TERMINATION;
- (void)setLimit:(NSNumber *)limit;
- (void)setOffset:(NSNumber *)offset;

@end
