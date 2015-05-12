//
//  GAInternationalization.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAInternationalization.h"

// Managers
#import "GALogger.h"

@implementation GAInternationalization

+ (NSString *)currentLanguage {
    return [[NSLocale preferredLanguages] firstObject];
}

+ (NSString *)formattedNumber:(NSNumber *)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)formattedCurrency:(NSNumber *)number {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:number];
}

+ (UIImage *)imageNamed:(NSString *)name {
    NSString *localizedName = [NSString stringWithFormat:@"%@-%@", name, [self currentLanguage]];
    UIImage *image = [UIImage imageNamed:localizedName];
    if (!image) {
        [GALogger addInformation:@"Localized image \"%@\" not found", localizedName];
        image = [UIImage imageNamed:localizedName];
    }
    return image;
}

@end
