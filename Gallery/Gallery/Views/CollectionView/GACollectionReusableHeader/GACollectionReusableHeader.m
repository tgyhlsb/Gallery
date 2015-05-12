//
//  GACollectionReusableHeader.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GACollectionReusableHeader.h"

@interface GACollectionReusableHeader()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GACollectionReusableHeader

+ (NSString *)preferredKind {
    return UICollectionElementKindSectionHeader;
}

- (void)awakeFromNib {
    self.backgroundColor = [UIColor purpleColor];
}

- (void)setDirectory:(GADirectory *)directory {
    _directory = directory;
    self.titleLabel.text = [directory nameWithExtension:NO];
}

@end
