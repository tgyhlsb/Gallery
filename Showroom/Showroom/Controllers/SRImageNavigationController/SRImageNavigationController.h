//
//  SRImageNavigationController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 16/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRNavigationController.h"

@class NSFetchedResultsController;

@interface SRImageNavigationController : SRNavigationController

+ (instancetype)newWithResultController:(NSFetchedResultsController *)fetchResultController;

@end
