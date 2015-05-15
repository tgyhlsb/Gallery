//
//  SRFilesTableViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRFilesTableViewController.h"

// Models
#import "SRModel.h"

@interface SRFilesTableViewController()

@property (strong, nonatomic) SRDirectory *directory;

@end

@implementation SRFilesTableViewController

#pragma mark - Constructors

+ (instancetype)newWithDirectory:(SRDirectory *)directory {
    return [[SRFilesTableViewController alloc] initWithDirectory:directory];
}

- (id)initWithDirectory:(SRDirectory *)directory {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.directory = directory;
    }
    return self;
}

#pragma mark - Getters & Setters

- (void)setDirectory:(SRDirectory *)directory {
    _directory = directory;
    [self updateFetchedResultController];
}

#pragma mark - Fetch request

- (void)updateFetchedResultController {
    self.fetchedResultsController = [[SRModel defaultModel] fetchedResultControllerForFilesInDirectory:self.directory];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SRFileCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    SRFile *file = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = file.name;
    cell.accessoryType = file.isDirectory ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}

@end
