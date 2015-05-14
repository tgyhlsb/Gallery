//
//  GADirectoryInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryMasterVC.h"

// Models
#import "GAFileNavigator.h"

// Managers
#import "GACacheManager.h"

// Views
#import "GAImageFileTableViewCell.h"

@interface GADirectoryMasterVC ()

@end

@implementation GADirectoryMasterVC

#pragma mark - Constructors

+ (instancetype)newWithDirectory:(GADirectory *)directory {
    return [[GADirectoryMasterVC alloc] initWithDirectory:directory];
}

- (id)initWithDirectory:(GADirectory *)directory {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        _directory = directory;
        self.title = NSLocalizedString(@"LOCALIZE_DEFAULT_DIRECTORY_NAME", nil);
    }
    return self;
}

#pragma mark - Getters & Setters

- (void)setDirectory:(GADirectory *)directory {
    _directory = directory;
    [self.tableView reloadData];
}

#pragma mark - Handlers

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [GAImageFileTableViewCell registerToTableView:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.directory.tree count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [GAImageFileTableViewCell reusableIdentifier];
    GAImageFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    cell.thumbnailPreferredSize = CGSizeMake(44.0, 44.0);
    cell.thumbnailScale = 10.0;
    cell.imageFile = [self.directory.tree objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GAFile *file = [self.directory.tree objectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(directoryViewController:didSelectFile:)]) {
        [self.delegate directoryViewController:self didSelectFile:file];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
