//
//  GAHomeViewController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 14/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAHomeViewController.h"

// Managers
#import "GAFileManager.h"
#import "GACacheManager.h"

// Controllers
#import "GAFileLoadingVC.h"
#import "GADirectorySplitController.h"
#import "GAImageCollectionNavigationController.h"

@interface GAHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fileInspectorButton;
@property (weak, nonatomic) IBOutlet UIButton *imageCollectionButton;

@end

@implementation GAHomeViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerToFileManagerNotifications];
    [self initializeView];
    
    [GAFileManager readSharedDirectoryInBackgroundWithBlock:^(GADirectory *root, NSError *error) {
        [self showButtons];
//        [GACacheManager thumbnailsForFiles:root.recursiveImages andSize:CGSizeMake(200, 200) inBackgroundWithBlock:^(UIImage *thumbnail) {
//        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configuration

- (void)initializeView {
    [self.fileInspectorButton setTitle:NSLocalizedString(@"LOCALIZE_FILE_INSPECTOR", nil) forState:UIControlStateNormal];
    [self.imageCollectionButton setTitle:NSLocalizedString(@"LOCALIZE_IMAGE_COLLECTION", nil) forState:UIControlStateNormal];
    self.fileInspectorButton.hidden = YES;
    self.imageCollectionButton.hidden = YES;
}

- (void)showButtons {
    self.fileInspectorButton.hidden = NO;
    self.imageCollectionButton.hidden = NO;
}

#pragma mark - Navigation

- (void)setWindowForViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self presentViewController:viewController animated:YES completion:^{
      
    }];
}

- (void)setWindowForFileInspector {
    GADirectory *directory = [GAFileManager rootDirectory];
    GADirectorySplitController *controller = [GADirectorySplitController newWithRootDirectory:directory];
    [self setWindowForViewController:controller animated:NO];
}

- (void)setWindowForPictureCollection{
    GADirectory *directory = [GAFileManager rootDirectory];
    GAImageCollectionNavigationController *controller = [GAImageCollectionNavigationController newWithRootDirectory:directory];
    [self setWindowForViewController:controller animated:NO];
}

#pragma mark - Broadcast

- (void)registerToFileManagerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fileDirectoryDidChange) name:GANotificationFileDirectoryChanged object:nil];
}

- (void)fileDirectoryDidChange {
//    [self setWindowForPictureCollection];
}

#pragma mark - Handlers

- (IBAction)fileInspectorButtonHandler:(UIButton *)sender {
    [self setWindowForFileInspector];
}

- (IBAction)imageCollectionButtonHandler:(UIButton *)sender {
    [self setWindowForPictureCollection];
}

@end
