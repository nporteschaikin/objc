//
//  NSManagedObject+Querying.h
//  Pluck
//
//  Created by Noah Portes Chaikin on 8/29/14.
//  Copyright (c) 2014 Pluck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NSManagedObject (Querying)

+ (NSFetchRequest *)fetchRequestMatchedByPredicate:(NSPredicate *)predicate
                               withSortDescriptors:(NSArray *)sortDescriptors;

+ (NSArray *)findAllMatchedByPredicate:(NSPredicate *)predicate
                   withSortDescriptors:(NSArray *)sortDescriptors
                             inContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSArray *)findAllMatchedByPredicate:(NSPredicate *)predicate
                   withSortDescriptors:(NSArray *)sortDescriptors;

+ (NSManagedObject *)findOneByPredicate:(NSPredicate *)predicate
                    withSortDescriptors:(NSArray *)sortDescriptors
                              inContext:(NSManagedObjectContext *)managedObjectContext
                                atIndex:(int)index;

+ (NSManagedObject *)findOneByPredicate:(NSPredicate *)predicate
                    withSortDescriptors:(NSArray *)sortDescriptors
                                atIndex:(int)index;

+ (NSManagedObject *)findFirstByPredicate:(NSPredicate *)predicate
                      withSortDescriptors:(NSArray *)sortDescriptors
                                inContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSManagedObject *)findFirstByPredicate:(NSPredicate *)predicate
                      withSortDescriptors:(NSArray *)sortDescriptors;

@end
