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
