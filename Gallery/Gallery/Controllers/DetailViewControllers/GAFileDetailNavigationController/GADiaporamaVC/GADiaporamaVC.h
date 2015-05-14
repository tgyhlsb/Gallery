//
//  GADiaporamaVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GADirectory.h"

@interface GADiaporamaVC : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) GADirectory *directory;
@property (nonatomic) BOOL showSplitButton;

+ (instancetype)newWithDirectory:(GADirectory *)directory;

@end
