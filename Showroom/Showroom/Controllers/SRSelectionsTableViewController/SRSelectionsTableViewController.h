//
//  SRSelectionsTableViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "UICoreDataTableViewController.h"

// Model
#import "SRSelection.h"

@protocol SRSelectionsTableViewControllerDelegate;

@interface SRSelectionsTableViewController : UICoreDataTableViewController

@property (weak, nonatomic) id<SRSelectionsTableViewControllerDelegate> delegate;

@end

@protocol SRSelectionsTableViewControllerDelegate <NSObject>

- (void)selectionsTableViewController:(SRSelectionsTableViewController *)controller didSelectSelection:(SRSelection *)selection;

@end