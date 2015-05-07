//
//  GATableViewCell.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 05/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GATableViewCell : UITableViewCell

+ (void)registerToTableView:(UITableView *)tableView;
+ (NSString *)reusableIdentifier;

@end
