//
//  SRSettingsSplitViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 18/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSettingsSplitViewController.h"

// Providers
#import "SRProviderLocal.h"

// Controllers
#import "UIViewController+Helper.h"
#import "SRNavigationController.h"
#import "MEDeclarativeTable.h"

typedef void (^SRDeclarativeTableActionBlock)(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row);

@interface SRSettingsSplitViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) UITableViewController *masterTableViewController;
@property (strong, nonatomic) UITableViewController *detailTableViewController;

@property (strong, nonatomic) MEDeclarativeTable *masterTable;
@property (strong, nonatomic) MEDeclarativeTable *detailTable;

@property (strong, nonatomic) UIAlertView *alertViewProviderLocalSynchronize;

@property (strong, nonatomic) MEDeclarativeTableSection *tempSection;
@property (strong, nonatomic) MEDeclarativeTableRow *tempRow;

@end

@implementation SRSettingsSplitViewController

#pragma mark - Declarative Table Configuration

- (void)setMasterTable:(MEDeclarativeTable *)masterTable {
    _masterTable = masterTable;
    self.masterTableViewController.tableView.delegate = masterTable;
    self.masterTableViewController.tableView.dataSource = masterTable;
}
- (void)setDetailTable:(MEDeclarativeTable *)detailTable {
    _detailTable = detailTable;
    
    self.detailTableViewController.tableView.dataSource = detailTable;
    self.detailTableViewController.tableView.delegate = detailTable;
    
    [self.detailTableViewController.tableView reloadData];
}

#pragma mark Master Table

- (MEDeclarativeTable *)settingsCategoryTable {
    MEDeclarativeTable *table = [[MEDeclarativeTable alloc] init];
    
    [table addSection:[self appearanceSection]];
    [table addSection:[self providersSection]];
    
    return table;
}

- (MEDeclarativeTableSection *)appearanceSection {
    MEDeclarativeTableSection *section = [[MEDeclarativeTableSection alloc] init];
    section.headerTitle = NSLocalizedString(@"LOCALIZE_SETTING_SECTION_APPEARANCE", nil);
    
    MEDeclarativeTableRow *row = [self masterRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        self.detailTable = [self appearanceInterfaceCategoryTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_INTERFACE", nil);
    
    row = [self masterRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        self.detailTable = [self appearanceThumbnailsCategoryTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_THUMBNAILS", nil);
    
    return section;
}

- (MEDeclarativeTableSection *)providersSection {
    MEDeclarativeTableSection *section = [[MEDeclarativeTableSection alloc] init];
    section.headerTitle = NSLocalizedString(@"LOCALIZE_SETTING_SECTION_PROVIDERS", nil);
    
    MEDeclarativeTableRow *row = [self masterRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        self.detailTable = [self providerLocalCategoryTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_PROVIDER_LOCAL_SYNCHRONIZATION", nil);
    
    return section;
}

#pragma mark Detail Table

- (MEDeclarativeTable *)providerLocalCategoryTable {
    MEDeclarativeTable *table = [[MEDeclarativeTable alloc] init];
    
    [table addSection:[self providerLocalSynchronizationSection]];
    
    return table;
}

- (MEDeclarativeTableSection *)providerLocalSynchronizationSection {
    MEDeclarativeTableSection *section = [[MEDeclarativeTableSection alloc] init];
    
    MEDeclarativeTableRow *row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
        [self.alertViewProviderLocalSynchronize show];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_SYNCHRONIZE", nil);
    
    return section;
}

- (MEDeclarativeTable *)appearanceInterfaceCategoryTable {
    MEDeclarativeTable *table = [[MEDeclarativeTable alloc] init];
    
    [table addSection:[self appearanceInterfaceAppColorsSection]];
    [table addSection:[self appearanceInterfaceDiaporamaColorsSection]];
    
    return table;
}

- (MEDeclarativeTableSection *)appearanceInterfaceAppColorsSection {
    MEDeclarativeTableSection *section = [[MEDeclarativeTableSection alloc] init];
    section.headerTitle = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_APP_COLOR_SECTION", nil);
    
    MEDeclarativeTableRow *row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_MAIN_COLOR", nil);
    
    row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_SECONDARY_COLOR", nil);
    
    return section;
}

- (MEDeclarativeTableSection *)appearanceInterfaceDiaporamaColorsSection {
    MEDeclarativeTableSection *section = [[MEDeclarativeTableSection alloc] init];
    section.headerTitle = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_DIAPORAMA_COLOR_SECTION", nil);
    
    MEDeclarativeTableRow *row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_DIAPORAMA_BACKGROUND_COLOR", nil);
    
    row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_APPEARANCE_DIAPORAMA_BACKGROUND_COLOR_FULLSCREEN", nil);
    
    return section;
}

- (MEDeclarativeTable *)appearanceThumbnailsCategoryTable {
    MEDeclarativeTable *table = [[MEDeclarativeTable alloc] init];
    
    [table addSection:[self appearanceThumbnailsQualitySection]];
    
    return table;
}

- (MEDeclarativeTableSection *)appearanceThumbnailsQualitySection {
    MEDeclarativeTableSection *section = [[MEDeclarativeTableSection alloc] init];
    section.headerTitle = NSLocalizedString(@"LOCALIZE_SETTING_THUMBNAILS_QUALITY_SECTION", nil);
    
    MEDeclarativeTableRow *row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_THUMBNAILS_QUALITY_HIGH", nil);
    
    row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_THUMBNAILS_QUALITY_MEDIUM", nil);
    
    row = [self detailRowForTable:self.masterTable inSection:section WithAction:^(MEDeclarativeTable *table, MEDeclarativeTableSection *section, MEDeclarativeTableRow *row) {
        [self deselectDetailTable];
    }];
    row.textLabelText = NSLocalizedString(@"LOCALIZE_SETTING_THUMBNAILS_QUALITY_LOW", nil);
    
    return section;
}

#pragma mark - Constructor

- (id)init {
    self = [super init];
    if (self) {
        
        UINavigationController *masterNavigation = [[SRNavigationController alloc] initWithRootViewController:self.masterTableViewController];
        UINavigationController *detailNavigation = [[SRNavigationController alloc] initWithRootViewController:self.detailTableViewController];
        
        [self.detailTableViewController setTitleWithAppIcon];
        [self showCloseButton];
        
        self.masterTable = [self settingsCategoryTable];
        
        self.viewControllers = @[masterNavigation, detailNavigation];
        
        self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    }
    return self;
}

#pragma mark - View life cycle

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Getters & Setters

- (UITableViewController *)masterTableViewController {
    if (!_masterTableViewController) {
        _masterTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _masterTableViewController;
}

- (UITableViewController *)detailTableViewController {
    if (!_detailTableViewController) {
        _detailTableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    }
    return _detailTableViewController;
}

@synthesize closeButton = _closeButton;

- (void)showCloseButton {
    self.masterTableViewController.navigationItem.leftBarButtonItem = self.closeButton;
}

- (void)setCloseButton:(UIBarButtonItem *)closeButton {
    _closeButton = closeButton;
    [self showCloseButton];
}

- (UIBarButtonItem *)closeButton {
    if (!_closeButton) {
        NSString *title = NSLocalizedString(@"LOCALIZE_CLOSE", nil);
        _closeButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonHandler)];
    }
    return _closeButton;
}

#pragma mark - Handlers

- (void)closeButtonHandler {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Declarative Table Helpers

- (void)deselectMasterTable {
    NSIndexPath *indexPath = [self.masterTableViewController.tableView indexPathForSelectedRow];
    [self.masterTableViewController.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)deselectDetailTable {
    NSIndexPath *indexPath = [self.detailTableViewController.tableView indexPathForSelectedRow];
    [self.detailTableViewController.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (MEDeclarativeTableRow *)masterRowForTable:(MEDeclarativeTable *)table inSection:(MEDeclarativeTableSection *)section WithAction:(SRDeclarativeTableActionBlock)didSelectAction {
    MEDeclarativeTableRow *row = [[MEDeclarativeTableRow alloc] init];
    
    [row setConfigureCell:^(UITableViewCell *cell) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }];
    
    __weak MEDeclarativeTableRow *weakRow = row;
    [row setDidSelectAction:^{
        
        if (didSelectAction) {
            self.tempSection = section;
            self.tempRow = weakRow;
            didSelectAction(table, section, weakRow);
        }
    }];
    
    row.selectionStyle = UITableViewCellSelectionStyleDefault;
    [section addRow:row];
    return row;
}

- (MEDeclarativeTableRow *)detailRowForTable:(MEDeclarativeTable *)table inSection:(MEDeclarativeTableSection *)section WithAction:(SRDeclarativeTableActionBlock)didSelectAction {
    MEDeclarativeTableRow *row = [[MEDeclarativeTableRow alloc] init];
    
    [row setConfigureCell:^(UITableViewCell *cell) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }];
    
    __weak MEDeclarativeTableRow *weakRow = row;
    [row setDidSelectAction:^{

        if (didSelectAction) {
            self.tempSection = section;
            self.tempRow = weakRow;
            didSelectAction(table, section, weakRow);
        }
    }];
    
    row.selectionStyle = UITableViewCellSelectionStyleDefault;
    [section addRow:row];
    return row;
}

#pragma mark - UIAlertViewDelegate

- (UIAlertView *)alertViewProviderLocalSynchronize {
    if (!_alertViewProviderLocalSynchronize) {
        NSString *title = NSLocalizedString(@"LOCALIZE_SYNCHRONIZATION_LOCAL_TITLE", nil);
        NSString *message = NSLocalizedString(@"LOCALIZE_SYNCHRONIZATION_LOCAL_MESSAGE", nil);
        NSString *cancel = NSLocalizedString(@"LOCALIZE_SYNCHRONIZATION_LOCAL_CANCEL", nil);
        NSString *validate = NSLocalizedString(@"LOCALIZE_SYNCHRONIZATION_LOCAL_VALIDATE", nil);
        _alertViewProviderLocalSynchronize = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancel otherButtonTitles:validate, nil];
    }
    return _alertViewProviderLocalSynchronize;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView isEqual:self.alertViewProviderLocalSynchronize]) {
        [self alertViewProviderLocalSynchronizeHandler:buttonIndex];
    }
}

- (void)alertViewProviderLocalSynchronizeHandler:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        self.tempSection.footerTitle = NSLocalizedString(@"LOCALIZE_SYNCHRONIZATION_SUCCESS", nil);
        
        self.tempSection = nil;
        self.tempRow = nil;
        
        [[SRProviderLocal defaultProvider] reloadFiles];
        
        [self.detailTableViewController.tableView reloadData];
    }
}

@end
