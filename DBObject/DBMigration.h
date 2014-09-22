//
//  DBMigration.h
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/22/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBMigration : NSObject

@property (strong, nonatomic) NSString *upQuery;
@property (strong, nonatomic) NSString *downQuery;

- (id)initWithUp:(NSString *)upQuery
        withDown:(NSString *)downQuery;

@end
