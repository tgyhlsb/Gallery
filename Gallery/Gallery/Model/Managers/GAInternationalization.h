//
//  GAInternationalization.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

@interface GAInternationalization : NSObject

+ (NSString *)formattedNumber:(NSNumber *)number;
+ (NSString *)formattedCurrency:(NSNumber *)number;

+ (UIImage *)imageNamed:(NSString *)name;

@end
