//
//  SRTableViewCell.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 13/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRTableViewCell : UITableViewCell

+ (NSString *)defaultIdentifier;
+ (void)registerToTableView:(UITableView *)tableView;

@end
