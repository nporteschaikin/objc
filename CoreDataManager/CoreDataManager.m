#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (NSManagedObjectContext *) managedObjectContext;

+ (NSManagedObjectContext *) newManagedObjectContext;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                              withContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate
                              withContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                      withSortDescriptors:(NSArray *)sortDescriptors
                              withContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                      withSortDescriptors:(NSArray *)sortDescriptors;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate
                       andSortDescriptors:(NSArray *)sortDescriptors
                              withContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table
                       matchedByPredicate:(NSPredicate *)predicate
                       andSortDescriptors:(NSArray *)sortDescriptors;

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                               withContext:(NSManagedObjectContext *)context;

+ (NSManagedObject *)newObjectInTable:(NSString *)table;

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                           withValues:(NSDictionary *)values
                          withContext:(NSManagedObjectContext *)context;

+ (NSManagedObject *)newObjectInTable:(NSString *)table
                           withValues:(NSDictionary *)values;

+ (NSError *) saveContext:(NSManagedObjectContext *)managedObjectContext;

+ (NSError *) saveContext;

@end
