//
//  GALogger.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GALogger.h"

static GALogger *sharedLogger;

@interface GALogger() <NSCoding>

@property (strong, nonatomic) NSMutableArray *logs;
@property (strong, nonatomic) NSArray *sortedLogs;

@end

@implementation GALogger

#pragma mark - Singleton

+ (instancetype)sharedLogger {
    if (!sharedLogger) {
        sharedLogger = [GALogger new];
    }
    return sharedLogger;
}

+ (void)addMessage:(NSString *)message withType:(GALogType)type {
    [[GALogger sharedLogger] addMessage:message withType:type];
}

+ (void)addInformation:(NSString *)message {
    [GALogger addMessage:message withType:GALogTypeInfo];
}

+ (void)addWarning:(NSString *)message {
    [GALogger addMessage:message withType:GALogTypeWarning];
}

+ (void)addError:(NSString *)message {
    [GALogger addMessage:message withType:GALogTypeError];
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
}

@end
