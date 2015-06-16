//
//  SRAddAndRemoveSelectionBarButton.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRBarButtonItem.h"

#import "SRSelection.h"

@protocol SRAddAndRemoveSelectionBarButtonDelegate;

@interface SRAddAndRemoveSelectionBarButton : SRBarButtonItem

@property (readwrite, nonatomic, weak) id<SRAddAndRemoveSelectionBarButtonDelegate> delegate;

@property (readwrite, nonatomic) BOOL selected;
@property (readwrite, nonatomic, strong) SRSelection *selection;

- (id)initWithDelegate:(id<SRAddAndRemoveSelectionBarButtonDelegate>)delegate selection:(SRSelection *)selection selected:(BOOL)selected;

@end

@protocol SRAddAndRemoveSelectionBarButtonDelegate <NSObject>

- (void)addAndRemoveButtonHandler:(SRAddAndRemoveSelectionBarButton *)sender;
- (void)selectionPickerButtonHandler:(SRAddAndRemoveSelectionBarButton *)sender;

@end
