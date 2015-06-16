//
//  SRSelectionBarButtonItem.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRBarButtonItem.h"

#import "SRSelection.h"

@protocol SRSelectionBarButtonItemDelegate;

@interface SRSelectionBarButtonItem : SRBarButtonItem

@property (readwrite, nonatomic, weak) id<SRSelectionBarButtonItemDelegate> delegate;

@property (readwrite, nonatomic) BOOL selected;
@property (readwrite, nonatomic, strong) SRSelection *selection;

- (id)initWithDelegate:(id<SRSelectionBarButtonItemDelegate>)delegate selection:(SRSelection *)selection selected:(BOOL)selected;

@end

@protocol SRSelectionBarButtonItemDelegate <NSObject>

- (void)addAndRemoveButtonHandler:(SRSelectionBarButtonItem *)sender;
- (void)selectionPickerButtonHandler:(SRSelectionBarButtonItem *)sender;

@end
