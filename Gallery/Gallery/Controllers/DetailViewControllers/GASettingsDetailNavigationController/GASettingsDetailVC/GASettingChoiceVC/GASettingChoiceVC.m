//
//  GASettingChoiceVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingChoiceVC.h"

@interface GASettingChoiceVC ()

@end

@implementation GASettingChoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Helpers

- (BOOL)isSelectedValue:(NSObject *)value {
    return [value.description isEqualToString:self.selectedValue.description];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.values count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"settingValueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSObject *value = [self.values objectAtIndex:indexPath.row];
    NSString *valueTitle = [self.valueTitles objectAtIndex:indexPath.row];
    
    cell.textLabel.text = valueTitle;
    cell.accessoryType = [self isSelectedValue:value] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(multipleChoiceController:didSelectValue:)]) {
        NSObject *value = [self.values objectAtIndex:indexPath.row];
        [self.delegate multipleChoiceController:self didSelectValue:value];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
