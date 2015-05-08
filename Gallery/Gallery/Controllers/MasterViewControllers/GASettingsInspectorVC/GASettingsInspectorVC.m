//
//  GASettingsInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsInspectorVC.h"

typedef NS_ENUM(NSInteger,GASettingSection){
    GASettingSectionGeneral,
    GASettingSectionDevelopment,
    GASettingSectionEnd
};

typedef NS_ENUM(NSInteger,GASettingGeneral){
    GASettingGeneralThumbnail,
    GASettingGeneralDirectoryNavigation,
    GASettingGeneralEnd
};

typedef NS_ENUM(NSInteger,GASettingDevelopment){
    GASettingDevelopmentLogger,
    GASettingDevelopmentEnd
};


@interface GASettingsInspectorVC ()

@property (strong, nonatomic) NSArray *cellTitles;
@property (strong, nonatomic) NSArray *sectionHeaders;
@property (strong, nonatomic) NSArray *sectionFooters;

@end

@implementation GASettingsInspectorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCellTitles];
    [self initializeSectionHeaders];
    [self initializeSectionFooters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Titles

- (void)initializeCellTitles {
    self.cellTitles = @[
                       @[
                           NSLocalizedString(@"SETTINGS_THUMBNAILS_TITLE", nil),
                           NSLocalizedString(@"SETTINGS_DIRECTORY_NAVIGATION_TITLE", nil)
                           ],
                       @[
                           NSLocalizedString(@"SETTINGS_LOGGER_TITLE", nil)
                           ]
                       ];
}

- (void)initializeSectionHeaders {
    self.sectionHeaders = @[
                           NSLocalizedString(@"SETTINGS_GENERAL_HEADER", nil),
                           NSLocalizedString(@"SETTINGS_DEVELOPMENT_HEADER", nil)
                           ];
}

- (void)initializeSectionFooters {
    self.sectionFooters = @[
                            NSLocalizedString(@"SETTINGS_GENERAL_FOOTER", nil),
                            NSLocalizedString(@"SETTINGS_DEVELOPMENT_FOOTER", nil)
                            ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return GASettingSectionEnd;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case GASettingSectionGeneral:
            return GASettingGeneralEnd;
        case GASettingSectionDevelopment:
            return GASettingDevelopmentEnd;
            
        default:
            return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [[self.cellTitles objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionHeaders objectAtIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.sectionFooters objectAtIndex:section];
}

@end
