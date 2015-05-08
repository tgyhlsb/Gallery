//
//  GALog.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,GALogType){
    GALogTypeInfo,
    GALogTypeWarning,
    GALogTypeError
};

@interface GALog : NSObject

@property (strong, nonatomic, readonly) NSString *message;
@property (strong, nonatomic, readonly) NSDate *creationDate;
@property (nonatomic, readonly) GALogType type;

+ (instancetype)logWithMessage:(NSString *)message type:(GALogType)type;

+ (NSString *)stringForType:(GALogType)type;
- (NSString *)stringType;

@end
