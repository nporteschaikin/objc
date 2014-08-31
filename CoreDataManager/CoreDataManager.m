//
//  CoreDataManager.m
//  Pluck
//
//  Created by Noah Portes Chaikin on 8/28/14.
//  Copyright (c) 2014 Pluck. All rights reserved.
//

#import "CoreDataManager.h"

NSString * const databaseName = @"Pluck";

static NSManagedObjectModel *managedObjectModel;
static NSPersistentStoreCoordinator *persistentStoreCoordinator;
static NSManagedObjectContext *managedObjectContext;

@implementation CoreDataManager

+ (NSManagedObjectContext *)managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [self newManagedObjectContext];
    }
    return managedObjectContext;
}

+ (NSManagedObjectContext *)newManagedObjectContext {
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = [self persistentStoreCoordinator];
    return context;
}

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table {
    return [self fetchRequestFromTable:table
                    matchedByPredicate:nil
                   withSortDescriptors:nil];
}

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate {
    return [self fetchRequestFromTable:table
                    matchedByPredicate:predicate
                   withSortDescriptors:nil];
}

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                      withSortDescriptors:(NSArray *)sortDescriptors {
    return [self fetchRequestFromTable:table
                    matchedByPredicate:nil
                   withSortDescriptors:sortDescriptors];
}

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate
                       withSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:table];
    request.predicate = predicate;
    request.sortDescriptors = sortDescriptors;
    return request;
}

+ (NSArray *)fetchFromTable:(NSString *)table
         matchedByPredicate:(NSPredicate *)predicate
        withSortDescriptors:(NSArray *)sortDescriptors
                  inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *request = [self fetchRequestFromTable:table
                                       matchedByPredicate:predicate
                                      withSortDescriptors:sortDescriptors];
    return [managedObjectContext executeFetchRequest:request error:nil];
}

+ (NSArray *)fetchFromTable:(NSString *)table
         matchedByPredicate:(NSPredicate *)predicate
        withSortDescriptors:(NSArray *)sortDescriptors {
    return [self fetchFromTable:table
             matchedByPredicate:predicate
            withSortDescriptors:sortDescriptors
                      inContext:[self managedObjectContext]];
}

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                               inContext:(NSManagedObjectContext *)context {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:table
                                  inManagedObjectContext:context];
    return entity;
}

+ (NSManagedObject *)newObjectInTable:(NSString *)table {
    return [self newObjectInTable:table
                      inContext:[self managedObjectContext]];
}

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                           withValues:(NSDictionary *)values
                          inContext:(NSManagedObjectContext *)context {
    NSManagedObject *entity = [self newObjectInTable:table
                              inContext:context];
    for (NSString *key in values.allKeys) {
        [entity setValue:[values valueForKey:key]
                  forKey:key];
    }
    return entity;
}

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                           withValues:(NSDictionary *)values {
    return [self newObjectInTable:table
                       withValues:values
                      inContext:[self managedObjectContext]];
}

+ (NSError *) saveContext:(NSManagedObjectContext *)managedObjectContext {
    NSError *error = nil;
    [managedObjectContext save:&error];
    return error;
}

+ (NSError *) saveContext {
    return [self saveContext:[self managedObjectContext]];
}

#pragma mark - Private methods

+ (NSManagedObjectModel *) managedObjectModel {
    if (!managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:databaseName
                                                  withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if (!persistentStoreCoordinator) {
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", databaseName]];
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    }
    return persistentStoreCoordinator;
}

@end
