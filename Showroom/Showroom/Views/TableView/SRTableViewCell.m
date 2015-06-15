//
//  SRTableViewCell.m
//  Showroom
//
//  Created by Tanguy Hélesbeux on 13/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRTableViewCell.h"

@implementation SRTableViewCell

+ (NSString *)defaultIdentifier {
    return [[self class] description];
}

+ (void)registerToTableView:(UITableView *)tableView {
    NSString *identifier = [self defaultIdentifier];
    UINib *nib = [UINib nibWithNibName:identifier bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
}

@end
