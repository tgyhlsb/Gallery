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

// Manager
#import "SRLogger.h"

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

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SRFile *file = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if (file.isImage) {
        [self didSelectImage:(SRImage *)file];
    } else if (file.isDirectory) {
        [self didSelectDirectory:(SRDirectory *)file];
    } else {
        [SRLogger addError:@"Tried to open invalid file '%@'", file];
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didSelectImage:(SRImage *)image {
    if ([self.delegate respondsToSelector:@selector(filesTableViewController:didSelectImage:)]) {
        [self.delegate filesTableViewController:self didSelectImage:image];
    }
}

- (void)didSelectDirectory:(SRDirectory *)directory {
    if ([self.delegate respondsToSelector:@selector(filesTableViewController:didSelectDirectory:)]) {
        [self.delegate filesTableViewController:self didSelectDirectory:directory];
    }
    
    SRFilesTableViewController *destination = [SRFilesTableViewController newWithDirectory:directory];
    destination.delegate = self.delegate;
    [self.navigationController pushViewController:destination animated:YES];
}

@end
