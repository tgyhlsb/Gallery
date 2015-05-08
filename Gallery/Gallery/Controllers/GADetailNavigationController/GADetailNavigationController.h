//
//  GADetailNavigationController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 04/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>


// Controllers
#import "GADiaporamaVC.h"
#import "GAMasterNavigationController.h"

@interface GADetailNavigationController : UINavigationController

- (GADiaporamaVC *)rootViewController;

@end
