//
//  SRLogger.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SRLogger : NSObject

+ (void)addInformation:(NSString *)format, ...;
+ (void)addWarning:(NSString *)format, ...;
+ (void)addError:(NSString *)format, ...;

@end
