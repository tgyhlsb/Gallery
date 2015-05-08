//
//  GALogger.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GALogger.h"

#define ARCHIVE_PATH @"/archives/logs"

#define PRINT_LOGS YES

static GALogger *sharedLogger;

@interface GALogger() <NSCoding>

@property (strong, nonatomic) NSMutableArray *logs;
@property (strong, nonatomic) NSArray *sortedLogs;

@end

@implementation GALogger

#pragma mark - Singleton

+ (instancetype)sharedLogger {
    if (!sharedLogger) {
        sharedLogger = [GALogger loadFromDisk];
    }
    return sharedLogger;
}

+ (void)addEntryWithType:(GALogType)type andFormat:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [[GALogger sharedLogger] addMessage:message withType:type];
}

+ (void)addInformation:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [GALogger addEntryWithType:GALogTypeInfo andFormat:message];
}

+ (void)addWarning:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [GALogger addEntryWithType:GALogTypeWarning andFormat:message];
}

+ (void)addError:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    [GALogger addEntryWithType:GALogTypeError andFormat:message];
}

#pragma mark - NSKeyedArchiver

#define ENCODE_KEY_LOGS @"logs"

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.logs = [aDecoder decodeObjectForKey:ENCODE_KEY_LOGS];
        [self generateSortedLogs];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.logs forKey:ENCODE_KEY_LOGS];
}

- (void)synchronize {
    [NSKeyedArchiver archiveRootObject:self toFile:ARCHIVE_PATH];
}

+ (instancetype)loadFromDisk {
    GALogger *logger = [NSKeyedUnarchiver unarchiveObjectWithFile:ARCHIVE_PATH];
    if (!logger) logger = [GALogger new];
    return logger;
}

#pragma mark - Getters & Setters

- (NSArray *)sortedLogs {
    if (!_sortedLogs) {
        NSMutableArray *tempLogs = [NSMutableArray new];
        for (int i = 0; i <= GALogTypeError; i++) {
            [tempLogs addObject:[NSMutableArray new]];
        }
        _sortedLogs = [NSArray arrayWithArray:tempLogs];
    }
    return _sortedLogs;
}

- (NSMutableArray *)logsForType:(GALogType)type {
    return [self.sortedLogs objectAtIndex:type];
}

#pragma mark - Data structure

- (void)generateSortedLogs {
    for (GALog *log in self.logs) {
        [[self logsForType:log.type] addObject:log];
    }
}

- (void)addMessage:(NSString *)message withType:(GALogType)type {
    GALog *log = [GALog logWithMessage:message type:type];
    [self.logs addObject:log];
    [[self logsForType:type] addObject:log];
    [self synchronize];
    
    if (PRINT_LOGS) {
        NSLog(@"%@", log);
    }
}

@end
