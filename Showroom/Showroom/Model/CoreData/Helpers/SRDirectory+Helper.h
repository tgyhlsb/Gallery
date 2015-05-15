//
//  SRDirectory+Helper.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRDirectory.h"

@interface SRDirectory (Helper)

+ (BOOL)fileAtPathIsDirectory:(NSString *)path;

@end
