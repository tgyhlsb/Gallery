//
//  SRSelectionBarButtonItem.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 10/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelectionBarButtonItem.h"

@interface SRSelectionBarButtonItem()

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *selectionButton;

@end

@implementation SRSelectionBarButtonItem

- (id)initWithDelegate:(id<SRSelectionBarButtonItemDelegate>)delegate selection:(SRSelection *)selection selected:(BOOL)selected {
    
    NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"SRSelectionBarButtonItem"
                                                      owner:self
                                                    options:nil];
    
    UIView *view = [nibViews firstObject];
    
    self = [self initWithCustomView:view];
    if (self) {
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionButton.layer.cornerRadius = self.selectionButton.frame.size.height/2;
        [self.selectionButton setTitleColor:[UIColor colorWithRed:0.12f green:0.45f blue:0.66f alpha:1.00f] forState:UIControlStateNormal];
        
        self.delegate = delegate;
        self.selected = selected;
        self.selection = selection;
    }
    return self;
}

#pragma mark - View

- (void)updateView {
    
    self.actionButton.hidden = (self.selection == nil || self.actionButtonHidden);
    NSString *title = self.selection ? self.selection.title : NSLocalizedString(@"LOCALIZE_SELECTION_BUTTON_DEFAULT_NAME", nil);
    [self.selectionButton setTitle:title forState:UIControlStateNormal];
}

#pragma mark - Getters & Setters

- (void)setSelection:(SRSelection *)selection {
    _selection = selection;
    [self updateView];
}

- (void)setActionButtonHidden:(BOOL)actionButtonHidden {
    _actionButtonHidden = actionButtonHidden;
    [self updateView];
}

@synthesize selected = _selected;

- (void)setSelected:(BOOL)selected {
    self.actionButton.selected = selected;
}

- (BOOL)selected {
    return self.actionButton.selected;
}

#pragma mark - Handlers

- (IBAction)actionButtonHandler:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(addAndRemoveButtonHandler:)]) {
        [self.delegate addAndRemoveButtonHandler:self];
    }
}

- (IBAction)selectionButtonHandler:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectionPickerButtonHandler:)]) {
        [self.delegate selectionPickerButtonHandler:self];
    }
}


@end
