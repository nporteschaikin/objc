//
//  CoreDataManager.m
//  Here
//
//  Created by Noah Portes Chaikin on 9/1/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "CoreDataManager.h"

NSString * const databaseName = @"Here";

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

+ (NSFetchRequest *)fetchRequestFromEntityByName:(NSString *)entityName
                                       batchSize:(NSInteger)batchSize {
    return [self fetchRequestFromEntityByName:entityName
                           matchedByPredicate:nil
                          withSortDescriptors:nil
                                    batchSize:batchSize];
}

+ (NSFetchRequest *)fetchRequestFromEntityByName:(NSString *)entityName
                              matchedByPredicate:(NSPredicate *)predicate
                                       batchSize:(NSInteger)batchSize {
    return [self fetchRequestFromEntityByName:entityName
                           matchedByPredicate:predicate
                          withSortDescriptors:nil
                                    batchSize:batchSize];
}

+ (NSFetchRequest *)fetchRequestFromEntityByName:(NSString *)entityName
                             withSortDescriptors:(NSArray *)sortDescriptors
                                       batchSize:(NSInteger)batchSize {
    return [self fetchRequestFromEntityByName:entityName
                           matchedByPredicate:nil
                          withSortDescriptors:sortDescriptors
                                    batchSize:batchSize];
}

+ (NSFetchRequest *)fetchRequestFromEntityByName:(NSString *)entityName
                              matchedByPredicate:(NSPredicate *)predicate
                             withSortDescriptors:(NSArray *)sortDescriptors
                                       batchSize:(NSInteger)batchSize {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:entityName];
    request.predicate = predicate;
    request.sortDescriptors = sortDescriptors;
    request.fetchBatchSize = batchSize;
    return request;
}

+ (NSArray *)fetchFromEntityByName:(NSString *)entityName
                matchedByPredicate:(NSPredicate *)predicate
               withSortDescriptors:(NSArray *)sortDescriptors
                         inContext:(NSManagedObjectContext *)context
                         batchSize:(NSInteger)batchSize {
    NSFetchRequest *request = [self fetchRequestFromEntityByName:entityName
                                              matchedByPredicate:predicate
                                             withSortDescriptors:sortDescriptors
                                                       batchSize:(NSInteger)batchSize];
    return [managedObjectContext executeFetchRequest:request error:nil];
}

+ (NSArray *)fetchFromEntityByName:(NSString *)entityName
                matchedByPredicate:(NSPredicate *)predicate
               withSortDescriptors:(NSArray *)sortDescriptors
                         batchSize:(NSInteger)batchSize {
    return [self fetchFromEntityByName:entityName
                    matchedByPredicate:predicate
                   withSortDescriptors:sortDescriptors
                             inContext:[self managedObjectContext]
                             batchSize:(NSInteger)batchSize];
}

+ (NSManagedObject *)newObjectInEntityByName:(NSString *)entityName
                                   inContext:(NSManagedObjectContext *)context {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                                            inManagedObjectContext:context];
    return entity;
}

+ (NSManagedObject *)newObjectInEntityByName:(NSString *)entityName {
    return [self newObjectInEntityByName:entityName
                               inContext:[self managedObjectContext]];
}

+ (NSManagedObject *)newObjectInEntityByName:(NSString *)entityName
                                  withValues:(NSDictionary *)values
                                   inContext:(NSManagedObjectContext *)context {
    NSManagedObject *entity = [self newObjectInEntityByName:entityName
                                                  inContext:context];
    for (NSString *key in values.allKeys) {
        [entity setValue:[values valueForKey:key]
                  forKey:key];
    }
    return entity;
}

+ (NSManagedObject *)newObjectInEntityByName:(NSString *)entityName
                                  withValues:(NSDictionary *)values {
    return [self newObjectInEntityByName:entityName
                              withValues:values
                               inContext:[self managedObjectContext]];
}

+ (NSError *)saveContext:(NSManagedObjectContext *)managedObjectContext {
    NSError *error = nil;
    [managedObjectContext save:&error];
    return error;
}

+ (NSError *)saveContext {
    return [self saveContext:[self managedObjectContext]];
}

#pragma mark - Private methods

+ (NSManagedObjectModel *)managedObjectModel {
    if (!managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:databaseName
                                                  withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!persistentStoreCoordinator) {
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", databaseName]];
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:nil];
    }
    return persistentStoreCoordinator;
}

@end
