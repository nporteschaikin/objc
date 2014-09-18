//
//  DBObjectAccessorHelper.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/18/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import <objc/runtime.h>
#import "DBObjectAccessorHelper.h"
#import "DBObject.h"

static id getter(DBObject *object, SEL selector) {
    DBColumn *column = [[object class] columnWithGetterSelector:selector];
    return [object valueForColumn:column];
}

static void setter(DBObject *object, SEL selector, id value) {
    DBColumn *column = [[object class] columnWithSetterSelector:selector];
    [object setValue:value
           forColumn:column];
}

@implementation DBObjectAccessorHelper

+ (void)setAccessorForColumn:(DBColumn *)column {
    SEL getterSelector = column.getterSelector;
    SEL setterSelector = column.setterSelector;
    
    if (getterSelector) {
        class_addMethod(column.DBObjectClass,
                        getterSelector,
                        (IMP)getter,
                        NULL);
    }
    
    if (setterSelector) {
        class_addMethod(column.DBObjectClass,
                        setterSelector,
                        (IMP)setter,
                        NULL);
    }
}

@end
