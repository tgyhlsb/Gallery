//
//  SRCreateSelectionViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRCreateSelectionViewController.h"

// Controllers
#import "SRTutorialSelectionsViewController.h"

// Model
#import "SRModel.h"

@interface SRCreateSelectionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation SRCreateSelectionViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

#pragma mark - Initialization

- (void)initializeView {
    self.titleTextField.delegate = self;
    
    self.title = NSLocalizedString(@"LOCALIZE_CREATE_LIST_TITLE", nil);
    
    self.titleLabel.text = NSLocalizedString(@"LOCALIZE_NEW_LIST_TITLE", nil);
    
    NSString *title = NSLocalizedString(@"LOCALIZE_CREATE_LIST_BUTTON", nil);
    [self.actionButton setTitle:title forState:UIControlStateNormal];
    self.actionButton.tintColor = [UIColor whiteColor];
    self.actionButton.backgroundColor = [UIColor colorWithRed:0.13f green:0.49f blue:0.69f alpha:1.00f];
    self.actionButton.layer.cornerRadius = 5.0;
    self.actionButton.enabled = NO;
    
    self.infoButton.tintColor = [UIColor colorWithRed:0.13f green:0.49f blue:0.69f alpha:1.00f];
}

#pragma mark - Handlers

- (IBAction)actionButtonHandler:(UIButton *)sender {
    [self createListWithName:self.titleTextField.text];
}

- (void)createListWithName:(NSString *)name {
    
    [[SRModel defaultModel] createSelectionWithTitle:name];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButtonHandler:(UIButton *)sender {
    
    // show Selections tutorial
    SRNavigationController *destination = [SRTutorialSelectionsViewController tutorialNavigationController];
    [self presentViewController:destination animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    self.actionButton.enabled = sender.text.length > 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!textField.text.length) return NO;
    
    [self createListWithName:textField.text];
    
    return YES;
}

@end
