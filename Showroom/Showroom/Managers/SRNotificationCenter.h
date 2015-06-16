//
//  SRNotificationCenter.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SRNotificationProviderLocalFilesDidChange = @"SRNotificationProviderLocalFilesDidChange";
static NSString *SRNotificationActiveSelectionChanged = @"SRNotificationActiveSelectionChanged";

@interface SRNotificationCenter : NSNotificationCenter

@end
