//
//  GASettingsDetailVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsDetailVC.h"

// Controllers
#import "GASettingChoiceVC.h"

@interface GASettingsDetailVC () <GASettingChoiceDelegate>

@end

@implementation GASettingsDetailVC

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeCellTitles];
    [self initializeSectionHeaders];
    [self initializeSectionFooters];
    [self initializePossibleValues];
    [self initializePossibleValueTitles];
    [self initializeSelectedValues];
    [self initializeSelectors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configuration

- (void)initializeCellTitles {
    self.cellTitles = @[];
}

- (void)initializeSectionHeaders {
    self.sectionHeaders = @[];
}

- (void)initializeSectionFooters {
    self.sectionFooters = @[];
}

- (void)initializePossibleValues {
    self.possibleValues = @[];
}

- (void)initializePossibleValueTitles {
    self.possibleValueTitles = @[];
}

- (void)initializeSelectedValues {
    self.selectedValues = @[];
}

- (void)initializeSelectors {
    self.selectorNames = @[];
}

- (id)objectInArray:(NSArray *)array atIndexPath:(NSIndexPath *)indexPath {
    NSArray *tempArray = [self objectInArray:array atIndex:indexPath.section];
    return [self objectInArray:tempArray atIndex:indexPath.row];
}

- (id)objectInArray:(NSArray *)array atIndex:(NSInteger)index {
    return (array && [array count] > index) ? [array objectAtIndex:index] : nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.cellTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.cellTitles objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    
    cell.textLabel.text = [self objectInArray:self.cellTitles atIndexPath:indexPath];
    cell.detailTextLabel.text = [self titleForSelectedValueAtIndexPath:indexPath];
    
    NSArray *possibleValues = [self objectInArray:self.possibleValues atIndexPath:indexPath];
    cell.accessoryType = possibleValues ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    return cell;
}

- (NSString *)titleForSelectedValueAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *selectedValue = [self objectInArray:self.selectedValues atIndexPath:indexPath];
    NSArray *possibleValues = [self objectInArray:self.possibleValues atIndexPath:indexPath];
    NSArray *possibleValueTitles = [self objectInArray:self.possibleValueTitles atIndexPath:indexPath];
    for (int i = 0; i < possibleValues.count; i++) {
        NSObject *possibleValue = [self objectInArray:possibleValues atIndex:i];
        if ([possibleValue isEqual:selectedValue]) {
            return [self objectInArray:possibleValueTitles atIndex:i];
        }
    }
    return nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *possibleValues = [self objectInArray:self.possibleValues atIndexPath:indexPath];
    if (possibleValues) {
        [self pushMultipleChoiceControllerForIndexPath:indexPath];
    } else {
        NSString *selectorName = [self objectInArray:self.selectorNames atIndexPath:indexPath];
        if (selectorName) {
            [self performSelectorWithName:selectorName withObject:nil];
        }
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self objectInArray:self.sectionHeaders atIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self objectInArray:self.sectionFooters atIndex:section];
}

- (void)pushMultipleChoiceControllerForIndexPath:(NSIndexPath *)indexPath {
    GASettingChoiceVC *destination = [GASettingChoiceVC new];
    destination.title = [self objectInArray:self.cellTitles atIndexPath:indexPath];
    destination.values = [self objectInArray:self.possibleValues atIndexPath:indexPath];
    destination.valueTitles = [self objectInArray:self.possibleValueTitles atIndexPath:indexPath];
    destination.selectedValue = [self objectInArray:self.selectedValues atIndexPath:indexPath];
    destination.indexPath = indexPath;
    destination.delegate = self;
    [self.navigationController pushViewController:destination animated:YES];
}

#pragma mark - Handlers 


- (void)performSelectorWithName:(NSString *)selectorName withObject:(NSObject *)object {
    SEL selector = NSSelectorFromString(selectorName);
    if ([self respondsToSelector:selector]) {
#pragma clang diagnostic push // Warning removal
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:selector withObject:object];
#pragma clang diagnostic pop
        [self initializeSelectedValues]; // refresh them
    }
}

#pragma mark - GASettingChoiceDelegate

- (void)multipleChoiceController:(GASettingChoiceVC *)controller didSelectValue:(NSObject *)value {
    NSString *selectorName = [self objectInArray:self.selectorNames atIndexPath:controller.indexPath];
    if (selectorName) {
        [self performSelectorWithName:selectorName withObject:value];
    }
}

@end
