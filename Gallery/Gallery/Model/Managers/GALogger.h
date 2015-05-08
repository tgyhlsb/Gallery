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

+ (void)addEntryWithType:(GALogType)type andFormat:(NSString *)format, ...;
+ (void)addInformation:(NSString *)format, ...;
+ (void)addWarning:(NSString *)format, ...;
+ (void)addError:(NSString *)format, ...;

@end
