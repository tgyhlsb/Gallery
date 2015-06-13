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

// Views
#import "SRBarButtonItem.h"
#import "SRDirectoryThumbnailTableViewCell.h"
#import "SRHomeBarButton.h"

@interface SRHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fileListInterfaceButton;
@property (weak, nonatomic) IBOutlet UIButton *imageCollectionInterfaceButton;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *forceReloadButton;

// XIB

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *iPadProviderButton;
@property (weak, nonatomic) IBOutlet UIButton *dropboxProviderButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mainViewBottomConstraint;

// Other

@property (strong, nonatomic) SRBarButtonItem *homeBarButton;

@property (nonatomic) BOOL interfaceIsHidden;
@property (nonatomic) BOOL showTableView;


@end

@implementation SRHomeViewController

#pragma mark - Constructor


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeView];
    [self initializeProviders];
    [self initializeManagers];
    
    [self setUpFetchedResultController];
    
    self.tableView.hidden = YES; // prevents first animation on launch
    
    [self updateLayout];
    
    [SRDirectoryThumbnailTableViewCell registerToTableView:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.commentLabel.hidden = ![[SRProviderLocal defaultProvider] didUpdateAfterLaunch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setInterfaceHidden:NO duration:0.35 completion:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)updateLayout {
    
    self.tableViewWidthConstraint.constant = 300;
    
    if (self.showTableView) {
        self.tableViewLeftConstraint.constant = 20;
    } else {
        self.tableViewLeftConstraint.constant = - 300;
    }
    
    if (self.interfaceIsHidden) {
        CGFloat viewHeight = self.view.bounds.size.height;
        
        self.tableViewTopConstraint.constant = - viewHeight;
        self.tableViewBottomConstraint.constant = viewHeight;
        
        self.mainViewTopConstraint.constant = - viewHeight;
        self.mainViewBottomConstraint.constant = viewHeight;
    } else {
        
        self.tableViewTopConstraint.constant = 0;
        self.tableViewBottomConstraint.constant = 0;
        
        self.mainViewTopConstraint.constant = 0;
        self.mainViewBottomConstraint.constant = 0;
    }
}

#pragma mark - Initilization

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)initializeManagers {
    [[SRModel defaultModel] fetchActiveSelection];
}

- (void)initializeProviders {
    SRProviderLocal *localProvider = [SRProviderLocal defaultProvider];
    [localProvider initialize];
    localProvider.autoUpdate = YES;
}

- (void)initializeView {
    self.view.backgroundColor = [UIColor colorWithRed:0.14f green:0.45f blue:0.65f alpha:1.00f];
    self.mainView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    NSString *fileTitle = NSLocalizedString(@"LOCALIZE_HOME_BUTTON_FILE_LIST", nil);
    [self.fileListInterfaceButton setTitle:fileTitle forState:UIControlStateNormal];
    [self.fileListInterfaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.fileListInterfaceButton.hidden = YES;
    
    NSString *imageTitle = NSLocalizedString(@"LOCALIZE_HOME_BUTTON_IMAGE_COLLECTION", nil);
    [self.imageCollectionInterfaceButton setTitle:imageTitle forState:UIControlStateNormal];
    [self.imageCollectionInterfaceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *syncTitle = NSLocalizedString(@"LOCALIZE_HOME_BUTTON_SYNCHRONIZE", nil);
    [self.forceReloadButton setTitle:syncTitle forState:UIControlStateNormal];
    [self.forceReloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    NSString *commentText = NSLocalizedString(@"LOCALIZE_HOME_INFO_FILE_UPDATE", nil);
    [self.commentLabel setText:commentText];
    self.commentLabel.hidden = YES;
    self.commentLabel.textColor = [UIColor grayColor];
    
    
//    *********************
//    
//    Provider Buttons
//
//    *********************
    
    UIColor *providerButtonColor = [UIColor whiteColor];
    
    
    UIImage *iPadProviderImage = [UIImage imageNamed:@"provider-ipad.png"];
    [self.iPadProviderButton setImage:iPadProviderImage forState:UIControlStateNormal];
    [self.iPadProviderButton setTintColor:providerButtonColor];
    
    UIImage *dropboxProviderImage = [UIImage imageNamed:@"provider-dropbox.png"];
    [self.dropboxProviderButton setImage:dropboxProviderImage forState:UIControlStateNormal];
    [self.dropboxProviderButton setTintColor:providerButtonColor];
}

#pragma mark - Animations

- (void)animateLayoutWitDuration:(NSTimeInterval)duration completion:(void (^)(SRHomeViewController *weakSelf, BOOL finished))completion  {
    
    [self updateLayout];
    
    __weak SRHomeViewController *weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat alpha = self.interfaceIsHidden ? 0 : 1;
        self.tableView.alpha = alpha;
        self.mainView.alpha = alpha;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion(weakSelf, finished);
        }
        
        self.tableView.hidden = NO; // previously set to YES to prevent first animation
    }];
}

- (void)setInterfaceHidden:(BOOL)hidden duration:(NSTimeInterval)duration completion:(void (^)(SRHomeViewController *weakSelf, BOOL finished))completion {
    self.interfaceIsHidden = hidden;
    [self animateLayoutWitDuration:duration completion:completion];
}

#pragma mark - Getters & Setters

- (SRBarButtonItem *)homeBarButton {
    if (!_homeBarButton) {
        _homeBarButton = [[SRHomeBarButton alloc] initWithTarget:self action:@selector(homeBarButtonHandler)];
    }
    return _homeBarButton;
}

- (void)setShowTableView:(BOOL)showTableView {
    if (_showTableView != showTableView) {
        _showTableView = showTableView;
        [self animateLayoutWitDuration:0.5 completion:nil];
    }
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

- (IBAction)iPadProviderButtonHandler:(UIButton *)sender {
    self.showTableView = !self.showTableView;
}

- (IBAction)dropboxProviderButtonHandler:(UIButton *)sender {
    self.showTableView = !self.showTableView;
}

#pragma mark - UICoreDataTableViewController

- (void)setUpFetchedResultController {
    SRDirectory *directory = [[SRProviderLocal defaultProvider] rootDirectory];
    self.fetchedResultsController = [[SRModel defaultModel] fetchedResultControllerForDirectoriesInDirectoryRecursively:directory];
}

- (SRImage *)firstImageForDirectory:(SRDirectory *)directory {
    static NSMutableDictionary *cachedThumbnails;
    if (!cachedThumbnails) cachedThumbnails = [[NSMutableDictionary alloc] init];
    
    SRImage *firstImage = [cachedThumbnails objectForKey:directory.path];
    
    if (firstImage) return firstImage;
    
    for (SRFile *child in directory.children) {
        if (child.isImage) {
            [cachedThumbnails setObject:child forKey:directory.path];
            return (SRImage *)child;
        }
    }
    
    SRDirectory *firstDirectory = [[directory.children allObjects] firstObject];
    return firstDirectory ? [self firstImageForDirectory:firstDirectory] : nil;
}

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [SRDirectoryThumbnailTableViewCell defaultIdentifier];
    SRDirectoryThumbnailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    SRDirectory *directory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SRProviderLocal *provider = [SRProviderLocal defaultProvider];
    
    if ([directory isEqual:provider.rootDirectory]) {
        [self setCell:cell forProvider:provider];
    } else {
        [self setCell:cell forDirectory:directory];
    }
    
    return cell;
}

- (void)setCell:(SRDirectoryThumbnailTableViewCell *)cell forDirectory:(SRDirectory *)directory {
    SRImage *image = [self firstImageForDirectory:directory];
    cell.titleLabel.text = directory.name;
    cell.thumbnailView.image = [image image];
    cell.thumbnailView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setCell:(SRDirectoryThumbnailTableViewCell *)cell forProvider:(SRProvider *)provider {
    NSString *title = NSLocalizedString(@"LOCALIZE_LOCAL_PROVIDER_TITLE", nil);
    UIImage *image = [UIImage imageNamed:@"provider-ipad-directory.png"];
    cell.titleLabel.text = title;
    cell.thumbnailView.image = image;
    cell.thumbnailView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SRDirectory *directory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SRImageNavigationController *destination = [SRImageNavigationController newWithDirectory:directory];
    destination.topViewController.navigationItem.leftBarButtonItem = self.homeBarButton;
    
    [self setInterfaceHidden:YES duration:0.35 completion:^(SRHomeViewController *weakSelf, BOOL finished) {
    }];
    
    [self presentViewController:destination animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

@end
