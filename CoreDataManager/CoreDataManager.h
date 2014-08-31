//
//  CoreDataManager.h
//  Pluck
//
//  Created by Noah Portes Chaikin on 8/28/14.
//  Copyright (c) 2014 Pluck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (NSManagedObjectContext *) managedObjectContext;

+ (NSManagedObjectContext *) newManagedObjectContext;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                      withSortDescriptors:(NSArray *)sortDescriptors;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate
                       withSortDescriptors:(NSArray *)sortDescriptors;

+ (NSArray *)fetchFromTable:(NSString *)table
         matchedByPredicate:(NSPredicate *)predicate
        withSortDescriptors:(NSArray *)sortDescriptors
                  inContext:(NSManagedObjectContext *)context;

+ (NSArray *)fetchFromTable:(NSString *)table
         matchedByPredicate:(NSPredicate *)predicate
        withSortDescriptors:(NSArray *)sortDescriptors;

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                               inContext:(NSManagedObjectContext *)context;

+ (NSManagedObject *)newObjectInTable:(NSString *)table;

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                           withValues:(NSDictionary *)values
                          inContext:(NSManagedObjectContext *)context;

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                           withValues:(NSDictionary *)values;

+ (NSError *) saveContext:(NSManagedObjectContext *)context;

+ (NSError *) saveContext;

@end
