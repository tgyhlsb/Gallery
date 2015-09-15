//
//  SRAnalyticsManager.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/09/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRAnalyticsManager.h"

#import <Google/Analytics.h>

@implementation SRAnalyticsManager

+ (void)addScreenView:(NSString *)screenName {
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
