//
//  SRSelectionsTableViewController.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelectionsTableViewController.h"

// Model
#import "SRModel.h"

@interface SRSelectionsTableViewController ()

@end

@implementation SRSelectionsTableViewController

#pragma mark - Constructors

+ (instancetype)new {
    return [[SRSelectionsTableViewController alloc] init];
}

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
    }
    return self;
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.fetchedResultsController = [[SRModel defaultModel] fetchedResultControllerForSelections];
}

#pragma mark - Getters & Setters

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    SRSelection *selection = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = selection.title;
    
    if (selection.images.count == 0) {
        cell.detailTextLabel.text = NSLocalizedString(@"LOCALIZE_SELECTION_IMAGE_COUNT_FORMAT_NULL", nil);
    } else if (selection.images.count == 1) {
        cell.detailTextLabel.text = NSLocalizedString(@"LOCALIZE_SELECTION_IMAGE_COUNT_FORMAT_SINGLE", nil);
    } else {
        NSString *subtitleFormat = NSLocalizedString(@"LOCALIZE_SELECTION_IMAGE_COUNT_FORMAT_PLURAL", nil);
        cell.detailTextLabel.text = [NSString stringWithFormat:subtitleFormat, selection.images.count];
    }
    
    cell.accessoryType = selection.isActive ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(selectionsTableViewController:didSelectSelection:)]) {
        SRSelection *selection = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [self.delegate selectionsTableViewController:self didSelectSelection:selection];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
