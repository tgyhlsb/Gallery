//
//  GASettingsDetailVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GASettingsDetailVC : UITableViewController

@property (strong, nonatomic) NSArray *cellTitles;
@property (strong, nonatomic) NSArray *sectionHeaders;
@property (strong, nonatomic) NSArray *sectionFooters;
@property (strong, nonatomic) NSArray *possibleValues;
@property (strong, nonatomic) NSArray *possibleValueTitles;
@property (strong, nonatomic) NSArray *selectedValues;
@property (strong, nonatomic) NSArray *selectorNames;

@end
