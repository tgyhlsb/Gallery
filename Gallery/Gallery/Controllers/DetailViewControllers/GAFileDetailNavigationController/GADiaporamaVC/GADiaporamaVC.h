//
//  GADiaporamaVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GAFileNavigator.h"

@interface GADiaporamaVC : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) GAFileNavigator *fileNavigator;
@property (nonatomic) BOOL showSplitButton;

+ (instancetype)newWithFileNavigator:(GAFileNavigator *)fileNavigator;

@end
