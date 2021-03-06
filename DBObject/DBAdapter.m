//
//  DBAdapter.m
//  Flyer
//
//  Created by Noah Portes Chaikin on 9/11/14.
//  Copyright (c) 2014 Noah Portes Chaikin. All rights reserved.
//

#import "DBAdapter.h"

static NSString * const databaseFile = @"flyer.sqlite3";

@interface DBAdapter () {
    sqlite3 *_database;
}
@end

@implementation DBAdapter

+ (DBAdapter *)dbAdapter {
    static DBAdapter *_dbAdapter;
    if (!_dbAdapter) {
        _dbAdapter = [[self alloc] init];
    }
    return _dbAdapter;
}

- (id)init {
    if (self = [super init]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [searchPaths lastObject];
        NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:databaseFile];
        if (![fileManager fileExistsAtPath:databasePath]) {
            [fileManager createFileAtPath:databasePath
                                 contents:nil
                               attributes:nil];
        }
        sqlite3_open([databasePath UTF8String], &_database);
    }
    return self;
}

- (BOOL)executeQuery:(NSString *)queryString {
    char *error;
    NSLog(@"%@", queryString);
    if (sqlite3_exec(_database, [queryString UTF8String], NULL, NULL, &error) == SQLITE_OK) {
        return YES;
    }
    return NO;
}

- (NSArray *)recordsByQuery:(NSString *)queryString {
    sqlite3_stmt *statement;
    NSLog(@"%@", queryString);
    NSMutableArray *rows = [[NSMutableArray alloc] init];
    if (sqlite3_prepare_v2(_database, [queryString UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        int columns = sqlite3_column_count(statement);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableDictionary *row = [[NSMutableDictionary alloc] initWithCapacity:columns];
            for (int x=0; x<columns; x++) {
                NSString *name = [NSString stringWithCString:sqlite3_column_name(statement, x)
                                                    encoding:NSUTF8StringEncoding];
                int type = sqlite3_column_type(statement, x);
                switch (type) {
                    case SQLITE_INTEGER: {
                        int value = sqlite3_column_int(statement, x);
                        [row setObject:[NSNumber numberWithInt:value]
                                forKey:name];
                        break;
                    }
                    case SQLITE_FLOAT: {
                        float value = sqlite3_column_double(statement, x);
                        [row setObject:[NSNumber numberWithFloat:value]
                                forKey:name];
                        break;
                    }
                    case SQLITE_TEXT: {
                        const char *value = (const char *)sqlite3_column_text(statement, x);
                        [row setObject:[NSString stringWithCString:value
                                                          encoding:NSUTF8StringEncoding]
                                forKey:name];
                        break;
                    }
                    case SQLITE_BLOB: {
                        int bytes = sqlite3_column_bytes(statement, x);
                        if (bytes > 0) {
                            const void *value = sqlite3_column_blob(statement, x);
                            if (value != NULL) {
                                [row setObject:[NSData dataWithBytes:value length:bytes]
                                        forKey:name];
                            }
                        }
                    }
                    case SQLITE_NULL: {
                        [row setObject:[NSNull null]
                                forKey:name];
                    }
                }
            }
            [rows addObject:row];
        }
        return rows;
    }
    return nil;
}

- (NSNumber *)lastInsertRowId {
    return [NSNumber numberWithLongLong:sqlite3_last_insert_rowid(_database)];
}

- (void)dealloc {
    sqlite3_close(_database);
}

@end
