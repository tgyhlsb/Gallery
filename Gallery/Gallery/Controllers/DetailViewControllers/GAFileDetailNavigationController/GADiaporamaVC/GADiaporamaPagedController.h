//
//  GADiaporamaPagedController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GAFileNavigator.h"

@protocol GADiaporamaPagedControllerDelegate;
@protocol GAFileInspectorBarButtonsDataSource;

@interface GADiaporamaPagedController : UIViewController

@property (weak, nonatomic) id<GADiaporamaPagedControllerDelegate> delegate;
@property (weak, nonatomic) id<GAFileInspectorBarButtonsDataSource> barItemDataSource;

@property (strong, nonatomic) GAFileNavigator *fileNavigator;

- (UIBarButtonItem *)diaporamaFileTypeBarButton;

- (void)setParentViewController:(UIViewController *)parent withView:(UIView *)view;

- (void)reloadCenterViewController;
- (void)showFile:(GAFile *)file;
- (void)showImage:(GAImageFile *)imageFile;
- (void)showDirectory:(GADirectory *)directory;
- (void)showNext;
- (void)showPrevious;

- (NSArray *)topLeftBarItemsForDisplayedFile;
- (NSArray *)topRightBarItemsForDisplayedFile;
- (NSArray *)bottomLeftBarItemsForDisplayedFile;
- (NSArray *)bottomRightBarItemsForDisplayedFile;

@end

@protocol GADiaporamaPagedControllerDelegate <NSObject>

- (void)diaporamaPagedControllerDidUpdateBarItems:(GADiaporamaPagedController *)diaporamaPagedController;

@optional

- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController willShowFile:(GAFile *)file;
- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController mayShowFile:(GAFile *)file;
- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController didShowFile:(GAFile *)file;

@end

@protocol GAFileInspectorBarButtonsDataSource <NSObject>

@optional
- (NSArray *)topLeftBarItemsForDisplayedFile;
- (NSArray *)topRightBarItemsForDisplayedFile;
- (NSArray *)bottomLeftBarItemsForDisplayedFile;
- (NSArray *)bottomRightBarItemsForDisplayedFile;

@end
