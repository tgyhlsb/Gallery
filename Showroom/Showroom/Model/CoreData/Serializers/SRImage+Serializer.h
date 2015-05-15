//
//  SRImage+Serializer.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRImage.h"

@interface SRImage (Serializer)

+ (SRImage *)imageWithAttributes:(NSDictionary *)attributes;

@end
