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
#import "SRProviderLocal.h"

// Managers
#import "SRNotificationCenter.h"

// Controllers
#import "SRImageNavigationController.h"
#import "SRFilesNavigationController.h"

@interface SRHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fileListInterfaceButton;
@property (weak, nonatomic) IBOutlet UIButton *imageCollectionInterfaceButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *forceReloadButton;

@property (strong, nonatomic) UIBarButtonItem *homeBarButton;

@end

@implementation SRHomeViewController

#pragma mark - Constructor


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
    [self initializeProviders];
    [self initializeManagers];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.commentLabel.hidden = ![[SRProviderLocal defaultProvider] didUpdateAfterLaunch];
}

#pragma mark - Initilization

- (void)initializeManagers {
    [[SRModel defaultModel] fetchActiveSelection];
}

- (void)initializeProviders {
    SRProviderLocal *localProvider = [SRProviderLocal defaultProvider];
    [localProvider initialize];
    localProvider.autoUpdate = YES;
}

#pragma mark - Getters & Setters

- (UIBarButtonItem *)homeBarButton {
    if (!_homeBarButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_HOME_BUTTON", nil);
        _homeBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(homeBarButtonHandler)];
    }
    return _homeBarButton;
}

#pragma mark - View methods

- (void)initializeView {
    NSString *fileTitle = NSLocalizedString(@"LOCALIZE_HOME_BUTTON_FILE_LIST", nil);
    [self.fileListInterfaceButton setTitle:fileTitle forState:UIControlStateNormal];
    
    NSString *imageTitle = NSLocalizedString(@"LOCALIZE_HOME_BUTTON_IMAGE_COLLECTION", nil);
    [self.imageCollectionInterfaceButton setTitle:imageTitle forState:UIControlStateNormal];
    [self.fileListInterfaceButton setTitle:fileTitle forState:UIControlStateNormal];
    
    NSString *syncTitle = NSLocalizedString(@"LOCALIZE_HOME_BUTTON_SYNCHRONIZE", nil);
    [self.forceReloadButton setTitle:syncTitle forState:UIControlStateNormal];
    
    NSString *commentText = NSLocalizedString(@"LOCALIZE_HOME_INFO_FILE_UPDATE", nil);
    [self.commentLabel setText:commentText];
    self.commentLabel.hidden = YES;
}

#pragma mark - Handlers 

- (IBAction)fileListInterfaceButtonHandler:(UIButton *)sender {
    SRDirectory *directory = [[SRProviderLocal defaultProvider] rootDirectory];
    SRFilesNavigationController *destination = [SRFilesNavigationController newWithDirectory:directory];
    destination.topViewController.navigationItem.leftBarButtonItem = self.homeBarButton;
    [self presentViewController:destination animated:YES completion:nil];
}

- (IBAction)imageCollectionInterfaceButtonHandler:(UIButton *)sender {
    SRDirectory *directory = [[SRProviderLocal defaultProvider] rootDirectory];
    SRImageNavigationController *destination = [SRImageNavigationController newWithDirectory:directory];
    destination.topViewController.navigationItem.leftBarButtonItem = self.homeBarButton;
    [self presentViewController:destination animated:YES completion:nil];
}

- (void)homeBarButtonHandler {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)forceReloadButtonHandler:(UIButton *)sender {
    [[SRProviderLocal defaultProvider] reloadFiles];
    self.commentLabel.hidden = NO;
}

@end
