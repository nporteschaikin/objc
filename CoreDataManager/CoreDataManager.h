#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (NSManagedObjectContext *) managedObjectContext;
+ (NSError *)saveContext;
+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table;
+ (NSFetchRequest *)fetchRequestFromTable:(NSString *)table matchedByPredicate:(NSPredicate *)predicate;
+ (NSFetchRequest *)fetchRequestFromTable: (NSString *)table matchedByPredicate:(NSPredicate *)predicate andSortDescriptors:(NSArray *)sortDescriptors;
+ (id)insertNewObjectToTable:(NSString *)table withValues:(NSDictionary *)values;

@end
