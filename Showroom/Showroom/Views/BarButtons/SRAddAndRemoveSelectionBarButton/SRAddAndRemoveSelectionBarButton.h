//
//  SRAddAndRemoveSelectionBarButton.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRBarButtonItem.h"

@interface SRAddAndRemoveSelectionBarButton : SRBarButtonItem

@property (readwrite, nonatomic) BOOL selected;

- (id)initWithTarget:(id)target action:(SEL)selector selected:(BOOL)selected;

@end
