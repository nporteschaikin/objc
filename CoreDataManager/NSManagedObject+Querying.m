//
//  NSManagedObject+Querying.m
//  Pluck
//
//  Created by Noah Portes Chaikin on 8/29/14.
//  Copyright (c) 2014 Pluck. All rights reserved.
//

#import "NSManagedObject+Querying.h"
#import "CoreDataManager.h"

static NSInteger batchSize = 10;

@implementation NSManagedObject (Querying)

+ (NSString *)entityName {
    return NSStringFromClass([self class]);
}

+ (void)setBatchSize:(NSInteger)size {
    @synchronized(self) {
        batchSize = size;
    }
}

+ (NSFetchRequest *)fetchRequestMatchedByPredicate:(NSPredicate *)predicate
                              withSortDescriptors:(NSArray *)sortDescriptors {
    return [CoreDataManager fetchRequestFromEntityByName:[self entityName]
                        matchedByPredicate:predicate
                                     withSortDescriptors:sortDescriptors
                                               batchSize:batchSize];
}

+ (NSArray *)findAllMatchedByPredicate:(NSPredicate *)predicate
                 withSortDescriptors:(NSArray *)sortDescriptors
                           inContext:(NSManagedObjectContext *)managedObjectContext {
    return [CoreDataManager fetchFromEntityByName:[self entityName]
                               matchedByPredicate:predicate
                              withSortDescriptors:sortDescriptors
                                        inContext:managedObjectContext
                                        batchSize:batchSize];
}

+ (NSArray *)findAllMatchedByPredicate:(NSPredicate *)predicate
                   withSortDescriptors:(NSArray *)sortDescriptors {
    return [self findAllMatchedByPredicate:predicate
                       withSortDescriptors:sortDescriptors
                                 inContext:[CoreDataManager managedObjectContext]];
}

+ (NSManagedObject *)findOneByPredicate:(NSPredicate *)predicate
                 withSortDescriptors:(NSArray *)sortDescriptors
                           inContext:(NSManagedObjectContext *)managedObjectContext
                                     atIndex:(int)index {
    return [[CoreDataManager fetchFromEntityByName:[self entityName]
                               matchedByPredicate:predicate
                              withSortDescriptors:sortDescriptors
                                         inContext:managedObjectContext
                                         batchSize:batchSize] objectAtIndex:index];
}

+ (NSManagedObject *)findOneByPredicate:(NSPredicate *)predicate
                    withSortDescriptors:(NSArray *)sortDescriptors
                                atIndex:(int)index {
    return [self findOneByPredicate:predicate
                withSortDescriptors:sortDescriptors
                          inContext:[CoreDataManager managedObjectContext]
                            atIndex:index];
}

+ (NSManagedObject *)findFirstByPredicate:(NSPredicate *)predicate
        withSortDescriptors:(NSArray *)sortDescriptors
                  inContext:(NSManagedObjectContext *)managedObjectContext {
    return [self findOneByPredicate:predicate
                     withSortDescriptors:sortDescriptors
                               inContext:managedObjectContext
                                 atIndex:0];
}

+ (NSManagedObject *)findFirstByPredicate:(NSPredicate *)predicate
                      withSortDescriptors:(NSArray *)sortDescriptors {
    return [self findOneByPredicate:predicate
                withSortDescriptors:sortDescriptors
                          inContext:[CoreDataManager managedObjectContext]
                            atIndex:0];
}

@end
