//
//  GADirectoryInspectorVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryInspectorVC.h"

// Models
#import "GAFile.h"

// Managers
#import "GACacheManager.h"

// Views
#import "GAImageFileTableViewCell.h"

@interface GADirectoryInspectorVC ()

@property (strong, nonatomic) UIBarButtonItem *splitViewButton;

@end

@implementation GADirectoryInspectorVC

#pragma mark - Constructors

+ (instancetype)newWithDirectory:(GADirectory *)directory {
    return [[GADirectoryInspectorVC alloc] initWithDirectory:directory];
}

- (id)initWithDirectory:(GADirectory *)directory {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.directory = directory;
        self.title = NSLocalizedString(@"DEFAULT_DIRECTORY_NAME", nil);
        [self initializeRefreshControl];
    }
    return self;
}

#pragma mark - Getters & Setters

- (void)setDirectory:(GADirectory *)directory {
    _directory = directory;
    [self.tableView reloadData];
}

- (UIBarButtonItem *)splitViewButton {
    if (!_splitViewButton) {
        NSString *title = NSLocalizedString(@"CLOSE", nil);
        _splitViewButton = [[UIBarButtonItem alloc] initWithTitle:title
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(splitViewButtonHandler)];
    }
    return _splitViewButton;
}

- (void)initializeRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(shouldRefresh)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Handlers

- (void)splitViewButtonHandler {
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryHidden;
    }];
}

- (void)shouldRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [GAImageFileTableViewCell registerToTableView:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self notifySelectedDirectory:self.directory];
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
    
    cell.imageFile = [self.directory.tree objectAtIndex:indexPath.row];
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GAFile *file = [self.directory.tree objectAtIndex:indexPath.row];
    
    if ([file isDirectory]) {
        [self openDirectory:(GADirectory *)file];
    } else if ([file isImage]) {
        [self openImagefile:(GAImageFile *)file];
    } else {
        
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)openDirectory:(GADirectory *)directory {
    GADirectoryInspectorVC *destination = [GADirectoryInspectorVC newWithDirectory:directory];
    destination.title = [directory nameWithExtension:YES];
    [self.navigationController pushViewController:destination animated:YES];
}

- (void)openImagefile:(GAImageFile *)imageFile {
    [self notifySelectedImageFile:imageFile];
}

#pragma mark - Broadcast

- (void)notifySelectedDirectory:(GADirectory *)directory {
    [[NSNotificationCenter defaultCenter] postNotificationName:GADirectoryInspectorNotificationSelectedDirectory
                                                        object:self
                                                      userInfo:@{@"directory": directory}];
}

- (void)notifySelectedImageFile:(GAImageFile *)imageFile {
    [[NSNotificationCenter defaultCenter] postNotificationName:GADirectoryInspectorNotificationSelectedImageFile
                                                        object:self
                                                      userInfo:@{@"imageFile": imageFile}];
}

@end
