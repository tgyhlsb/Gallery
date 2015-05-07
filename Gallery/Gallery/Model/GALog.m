//
//  GALog.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GALog.h"

@interface GALog() <NSCoding>

@property (strong, nonatomic, readwrite) NSString *message;
@property (strong, nonatomic, readwrite) NSDate *creationDate;
@property (nonatomic, readwrite) GALogType type;

@end

@implementation GALog

#pragma mark - Constructors

+ (instancetype)logWithMessage:(NSString *)message type:(GALogType)type{
    GALog *log = [[GALog alloc] initWithMessage:message type:type];
    return log;
}

- (id)initWithMessage:(NSString *)message type:(GALogType)type {
    self = [super init];
    if (self) {
        self.creationDate = [NSDate date];
        self.message = message;
        self.type = type;
    }
    return self;
}

#pragma mark - NSKeyedArchiver

#define ENCODE_KEY_MESSAGE @"message"
#define ENCODE_KEY_DATE @"creationDate"
#define ENCODE_KEY_TYPE @"type"

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.message = [aDecoder decodeObjectForKey:ENCODE_KEY_MESSAGE];
        self.creationDate = [aDecoder decodeObjectForKey:ENCODE_KEY_DATE];
        self.type = [[aDecoder decodeObjectForKey:ENCODE_KEY_TYPE] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.message forKey:ENCODE_KEY_MESSAGE];
    [aCoder encodeObject:self.creationDate forKey:ENCODE_KEY_DATE];
    [aCoder encodeObject:@(self.type) forKey:ENCODE_KEY_TYPE];
}

@end
