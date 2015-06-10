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

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *iPadProviderButton;
@property (weak, nonatomic) IBOutlet UIButton *dropboxProviderButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewLeftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewWidthConstraint;

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.commentLabel.hidden = ![[SRProviderLocal defaultProvider] didUpdateAfterLaunch];
}

- (void)viewWillLayoutSubviews {
    
    self.tableViewWidthConstraint.constant = 300;
    
    if (self.showTableView) {
        self.tableViewLeftConstraint.constant = 20;
    } else {
        self.tableViewLeftConstraint.constant = - 300;
    }
    
    [super viewWillLayoutSubviews];
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

#pragma mark - Getters & Setters

- (UIBarButtonItem *)homeBarButton {
    if (!_homeBarButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_HOME_BUTTON", nil);
        _homeBarButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(homeBarButtonHandler)];
    }
    return _homeBarButton;
}

- (void)setShowTableView:(BOOL)showTableView {
    if (_showTableView != showTableView) {
        _showTableView = showTableView;
        [self.view setNeedsLayout];
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

#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    SRDirectory *directory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = directory.name;
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SRDirectory *directory = [self.fetchedResultsController objectAtIndexPath:indexPath];
    SRImageNavigationController *destination = [SRImageNavigationController newWithDirectory:directory];
    destination.topViewController.navigationItem.leftBarButtonItem = self.homeBarButton;
    [self presentViewController:destination animated:YES completion:nil];
}

@end
