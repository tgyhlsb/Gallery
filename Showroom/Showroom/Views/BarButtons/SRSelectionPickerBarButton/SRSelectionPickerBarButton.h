//
//  SRSelectionPickerBarButton.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 08/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SRSelection.h"

@interface SRSelectionPickerBarButton : UIBarButtonItem

@property (readwrite, strong, nonatomic) SRSelection *selection;

- (id)initWithTarget:(id)target action:(SEL)selector selection:(SRSelection *)selection;

@end
