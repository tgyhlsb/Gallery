//
//  GALogger.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 07/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

// Model
#import "GALog.h"

@interface GALogger : NSObject

+ (void)addMessage:(NSString *)message withType:(GALogType)type;
+ (void)addInformation:(NSString *)message;
+ (void)addWarning:(NSString *)message;
+ (void)addError:(NSString *)message;

@end
