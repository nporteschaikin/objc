//
//  DBMigrator.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/22/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBMigrator.h"

@interface DBMigrator () {
    DBDatabase *database;
    NSMutableDictionary *migrations;
}

@end

@implementation DBMigrator

- (id)initWithDatabase:(DBDatabase *)aDatabase {
    if (self = [super init]) {
        database = aDatabase;
        migrations = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)insertMigration:(DBMigration *)migration
              atVersion:(int)version {
    [migrations setObject:migration
                  forKey:[NSNumber numberWithInt:version]];
}

- (void)migrate {
    if ([self databaseVersion] < [self schemaVersion]) {
        DBMigration *migration;
        int version = 0;
        for (int i = [self databaseVersion] + 1; i<=[self schemaVersion]; i++) {
            migration = [self migrationAtVersion:i];
            if (migration) {
                if ([database executeUpdate:migration.upQuery]) {
                    version = i;
                } else {
                    break;
                }
            }
        }
        [self setDatabaseVersion:version];
    }
}

- (int)schemaVersion {
    return [[[[migrations allKeys] sortedArrayUsingSelector:@selector(compare:)] lastObject] intValue];
}

- (int)databaseVersion {
    NSArray *queryResult = [database executeQuery:@"PRAGMA user_version;"];
    return [[[queryResult firstObject] valueForKey:@"user_version"] intValue];
}

- (void)setDatabaseVersion:(int)databaseVersion {
    NSString *query = [NSString stringWithFormat:@"PRAGMA user_version = %d", databaseVersion];
    NSLog(@"Migrated database to version %d.", databaseVersion);
    
    [database executeQuery:query];
}

- (DBMigration *)migrationAtVersion:(int)version {
    return [migrations objectForKey:[NSNumber numberWithInt:version]];
}

@end
