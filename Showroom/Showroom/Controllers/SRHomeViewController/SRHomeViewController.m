//
//  SRHomeViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRHomeViewController.h"

// Models
#import "SRModel.h"

// Managers
#import "SRProviderLocal.h"

// Controllers
#import "SRImageNavigationController.h"
#import "SRFilesNavigationController.h"

@interface SRHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fileListInterfaceButton;
@property (weak, nonatomic) IBOutlet UIButton *imageCollectionInterfaceButton;

@end

@implementation SRHomeViewController

#pragma mark - Constructor


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[SRProviderLocal defaultProvider] initialize];
    [[SRProviderLocal defaultProvider] reloadFiles];
}

#pragma mark - View methods

- (void)initializeView {
    NSString *fileTitle = NSLocalizedString(@"LOCALIZE_FILE_INTERFACE_BUTTON", nil);
    [self.fileListInterfaceButton setTitle:fileTitle forState:UIControlStateNormal];
    
    NSString *imageTitle = NSLocalizedString(@"LOCALIZE_IMAGE_INTERFACE_BUTTON", nil);
    [self.imageCollectionInterfaceButton setTitle:imageTitle forState:UIControlStateNormal];
}

#pragma mark - Handlers 

- (IBAction)fileListInterfaceButtonHandler:(UIButton *)sender {
    SRDirectory *directory = [[SRProviderLocal defaultProvider] getRootDirectory];
    SRFilesNavigationController *destination = [SRFilesNavigationController newWithDirectory:directory];
    [self presentViewController:destination animated:YES completion:nil];
}

- (IBAction)imageCollectionInterfaceButtonHandler:(UIButton *)sender {
    SRDirectory *directory = [[SRProviderLocal defaultProvider] getRootDirectory];
    SRImageNavigationController *destination = [SRImageNavigationController newWithDirectory:directory];
    [self presentViewController:destination animated:YES completion:nil];
}


@end
