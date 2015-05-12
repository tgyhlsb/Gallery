//
//  GACollectionReusableHeader.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GACollectionReusableHeader.h"

@implementation GACollectionReusableHeader

+ (NSString *)preferredKind {
    return UICollectionElementKindSectionHeader;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor purpleColor];
}

@end
