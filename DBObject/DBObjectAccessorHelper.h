//
//  DBObjectAccessorHelper.h
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBColumn.h"

@interface DBObjectAccessorHelper : NSObject

+ (void)setAccessorForColumn:(DBColumn *)column;

@end
