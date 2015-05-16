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

@property (strong, nonatomic) UIBarButtonItem *homeBarButton;

@end

@implementation SRHomeViewController

#pragma mark - Constructor


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
    
    [[SRProviderLocal defaultProvider] initialize];
    
//    [self checkForFileUpdates];
//    [self registerToProviderLocalNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

- (void)notificationProviderLocalFilesDidChangeHandler {
    [[SRProviderLocal defaultProvider] reloadFiles];
    [[SRProviderLocal defaultProvider] startMonitoring];
}

#pragma mark - Providers

- (void)checkForFileUpdates {
    SRProviderLocal *provider = [SRProviderLocal defaultProvider];
    if ([provider needsUpdate]) {
        [provider reloadFiles];
        self.commentLabel.hidden = NO;
    }
    [provider startMonitoring];
}

#pragma mark - Broadcasting

- (void)registerToProviderLocalNotifications {
    [[SRNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationProviderLocalFilesDidChangeHandler)
                                                 name:SRNotificationProviderLocalFilesDidChange
                                               object:nil];
}

@end
