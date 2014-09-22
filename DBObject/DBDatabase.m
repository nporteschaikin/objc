//
//  DBDatabase.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/22/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBDatabase.h"
#import <sqlite3.h>

@interface DBDatabase () {
    NSString *fileName;
    sqlite3 *database;
}

@end

@implementation DBDatabase

+ (DBDatabase *)sharedDatabase {
    // Soon, make this zero-config.
    static DBDatabase *sharedDatabase;
    if (!sharedDatabase) {
        sharedDatabase = [[self alloc] initWithFileName:@"test.sql"];
    }
    return sharedDatabase;
}

- (id)initWithFileName:(NSString *)aFileName {
    if (self = [super init]) {
        fileName = aFileName;
        [self createDatabaseFileIfNeeded];
        [self openDatabaseFile];
    }
    return self;
}

- (NSString *)databasePath {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (void)createDatabaseFileIfNeeded {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self databasePath]]) {
        [fileManager createFileAtPath:[self databasePath]
                             contents:nil
                           attributes:nil];
    }
}

- (void)openDatabaseFile {
    sqlite3_open([[self databasePath] UTF8String], &database);
}

- (BOOL)executeUpdate:(NSString *)query {
    char *error;
    
    if (sqlite3_exec(database, [query UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        return YES;
    }
    
    [self logError:error
         withQuery:query];
    return NO;
}

- (NSArray *)executeQuery:(NSString *)query {
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        NSMutableArray *rows = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            [rows addObject:[self rowDictionaryFromStatement:statement]];
        }
        return rows;
    }
    
    [self logError:(char *)sqlite3_errmsg(database)
         withQuery:query];
    return nil;
}

- (void)logError:(char *)error
       withQuery:(NSString *)query {
    NSLog(@"Error with query \"%@\": \"%s\"", query, error);
}

- (NSDictionary *)rowDictionaryFromStatement:(sqlite3_stmt *)statement {
    NSMutableDictionary *rowDictionary = [NSMutableDictionary dictionary];
    int columnsCount = sqlite3_column_count(statement);
    for (int x=0; x<columnsCount; x++) {
        NSString *columnName = [NSString stringWithCString:sqlite3_column_name(statement, x)
                                           encoding:NSUTF8StringEncoding];
        id columnValue;
        switch (sqlite3_column_type(statement, x)) {
            case SQLITE_INTEGER: {
                columnValue = [NSNumber numberWithInt:sqlite3_column_int(statement, x)];
                break;
            }
            case SQLITE_FLOAT: {
                columnValue = [NSNumber numberWithFloat:sqlite3_column_double(statement, x)];
                break;
            }
            case SQLITE_TEXT: {
                columnValue = [NSString stringWithCString:(const char *)sqlite3_column_text(statement, x)
                                                 encoding:NSUTF8StringEncoding];
                break;
            }
            case SQLITE_BLOB: {
                int bytes = sqlite3_column_bytes(statement, x);
                if (bytes > 0) {
                    const void *value = sqlite3_column_blob(statement, x);
                    if (value != NULL) {
                        columnValue = [NSData dataWithBytes:value length:bytes];
                    }
                }
            }
            case SQLITE_NULL: {
                columnValue = [NSNull null];
                break;
            }
        }
        if (columnValue) {
            [rowDictionary setObject:columnValue
                              forKey:columnName];
        }
    }
    return rowDictionary;
}

- (NSNumber *)lastInsertPrimaryKey {
    return [NSNumber numberWithLongLong:sqlite3_last_insert_rowid(database)];
}

@end
