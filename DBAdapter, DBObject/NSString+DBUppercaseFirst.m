//
//  NSString+DBUppercaseFirst.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "NSString+DBUppercaseFirst.h"

@implementation NSString (DBUppercaseFirst)

- (NSString *)stringWithUppercaseFirst {
    return [self stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                         withString:[[self substringToIndex:1] uppercaseString]];
}

@end
