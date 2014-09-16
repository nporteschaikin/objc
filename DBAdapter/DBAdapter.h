//
//  DBAdapter.h
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/11/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBAdapter : NSObject

+ (DBAdapter *)dbAdapter;
- (BOOL)executeQuery:(NSString *)queryString;
- (NSArray *)rowsWithQuery:(NSString *)queryString;

@end
