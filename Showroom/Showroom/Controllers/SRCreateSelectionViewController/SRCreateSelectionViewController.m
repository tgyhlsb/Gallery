//
//  SRCreateSelectionViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRCreateSelectionViewController.h"

// Model
#import "SRModel.h"

@interface SRCreateSelectionViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

@end

@implementation SRCreateSelectionViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeTitleTextField];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.titleTextField becomeFirstResponder];
}

#pragma mark - Initialization

- (void)initializeTitleTextField {
    self.titleTextField.delegate = self;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (!textField.text.length) return NO;
    
    [[SRModel defaultModel] createSelectionWithTitle:textField.text];
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

@end
