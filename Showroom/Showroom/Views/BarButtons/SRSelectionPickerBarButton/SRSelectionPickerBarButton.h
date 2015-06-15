//
//  SRSelectionPickerBarButton.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 08/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRBarButtonItem.h"

#import "SRSelection.h"

@interface SRSelectionPickerBarButton : SRBarButtonItem

@property (readwrite, strong, nonatomic) SRSelection *selection;

- (id)initWithTarget:(id)target action:(SEL)selector selection:(SRSelection *)selection;

@end
