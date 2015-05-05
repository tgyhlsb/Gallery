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
#import "GAThumbnailView.h"

@interface GADirectoryInspectorVC ()

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

- (void)initializeRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(shouldRefresh)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Handlers

- (void)shouldRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.directory.tree count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        //        Initialize cell
    }
    //     Customize cell
    GAFile *file = [self.directory.tree objectAtIndex:indexPath.row];
    cell.textLabel.text = [file nameWithExtension:YES];
    
    if ([file isDirectory]) {
        cell.imageView.image = nil;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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
    if ([self.delegate respondsToSelector:@selector(directoryInspector:didSelectImageFile:)]) {
        [self.delegate directoryInspector:self didSelectImageFile:imageFile];
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
