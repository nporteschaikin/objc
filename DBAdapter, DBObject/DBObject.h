//
//  DBObject.h
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/12/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBColumn.h"
#import "DBObjectFetcher.h"

@interface DBObject : NSObject

@property (strong, nonatomic, readonly) NSMutableSet *changedColumns;

+ (NSString *)tableName;
+ (NSSet *)columns;
+ (DBColumn *)columnNamed:(NSString *)columnName;
+ (DBColumn *)columnWithSetterSelector:(SEL)setterSelector;
+ (DBColumn *)columnWithGetterSelector:(SEL)getterSelector;
+ (DBColumn *)primaryKeyColumn;

+ (DBObjectFetcher *)objectFetcher;

- (id)valueForColumn:(DBColumn *)column;
- (void)setValue:(id)value forColumn:(DBColumn *)column;
- (void)save;

@end
