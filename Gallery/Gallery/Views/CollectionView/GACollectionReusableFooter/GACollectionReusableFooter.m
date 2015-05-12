//
//  GACollectionReusableFooter.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GACollectionReusableFooter.h"

@implementation GACollectionReusableFooter

+ (NSString *)preferredKind {
    return UICollectionElementKindSectionFooter;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor greenColor];
}

@end
