//
//  GATableViewCell.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 05/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GATableViewCell.h"

@implementation GATableViewCell

+ (void)registerToTableView:(UITableView *)tableView {
    NSString *nibName = [[self class] description];
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[self reusableIdentifier]];
}

+ (NSString *)reusableIdentifier {
    return [[self class] description];
}

@end
