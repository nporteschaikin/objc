#import "CoreDataManager.h"

NSString * const databaseName = @"Pluck";

static NSManagedObjectModel *managedObjectModel;
static NSPersistentStoreCoordinator *persistentStoreCoordinator;
static NSManagedObjectContext *managedObjectContext;

@implementation CoreDataManager

+ (NSManagedObjectModel *)managedObjectModel {
    if (!managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:databaseName withExtension:@"momd"];
        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return managedObjectModel;
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!persistentStoreCoordinator) {
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", databaseName]];
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return persistentStoreCoordinator;
}

+ (NSManagedObjectContext *) managedObjectContext {
    if (!managedObjectContext) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        managedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinator];
    }
    return managedObjectContext;
}

+ (NSError *)saveContext {
    NSError *error = nil;
    [[self managedObjectContext] save:&error];
    return error;
}

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table {
    return [[NSFetchRequest alloc] initWithEntityName:table];
}

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table matchedByPredicate:(NSPredicate *)predicate {
    NSFetchRequest *request = [self fetchRequestFromTable:table];
    request.predicate = predicate;
    return request;
}

+ (NSFetchRequest *)fetchRequestFromTable: (NSString *)table matchedByPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *request = [self fetchRequestFromTable:table matchedByPredicate:predicate];
    request.sortDescriptors = sortDescriptors;
    return request;
}

+ (id)insertNewObjectToTable:(NSString *)table withValues:(NSDictionary *)values {
    NSManagedObject *entity = [NSEntityDescription insertNewObjectForEntityForName:table inManagedObjectContext:[self managedObjectContext]];
    for (NSString *key in values.allKeys) {
        [entity setValue:[values valueForKey:key] forKey:key];
    }
    [self saveContext];
    return entity;
}

@end
