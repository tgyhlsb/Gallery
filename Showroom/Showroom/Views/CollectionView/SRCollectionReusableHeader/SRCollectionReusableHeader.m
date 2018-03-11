//
//  SRCollectionReusableHeader.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRCollectionReusableHeader.h"

@interface SRCollectionReusableHeader()

@end

@implementation SRCollectionReusableHeader

+ (NSString *)preferredKind {
    return UICollectionElementKindSectionHeader;
}

- (void)awakeFromNib {
    
}

@end
