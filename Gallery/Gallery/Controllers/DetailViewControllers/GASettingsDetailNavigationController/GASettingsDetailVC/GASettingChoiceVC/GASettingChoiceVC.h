//
//  GASettingChoiceVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GASettingChoiceDelegate;

@interface GASettingChoiceVC : UITableViewController

@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) NSObject *selectedValue;
@property (strong, nonatomic) NSArray *values;
@property (strong, nonatomic) NSArray *valueTitles;
@property (strong, nonatomic) NSString *informationText;

@property (weak, nonatomic) id<GASettingChoiceDelegate> delegate;

@end

@protocol GASettingChoiceDelegate <NSObject>

- (void)multipleChoiceController:(GASettingChoiceVC *)controller didSelectValue:(NSObject *)value;

@end
