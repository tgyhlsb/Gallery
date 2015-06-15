//
//  SRHomeBarButton.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 13/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRHomeBarButton.h"

@implementation SRHomeBarButton

- (id)initWithTarget:(id)target action:(SEL)selector {
    UIImage *image = [UIImage imageNamed:@"arrow-down.png"];
    return  [self initWithImage:image style:UIBarButtonItemStylePlain target:target action:selector];
}

@end
