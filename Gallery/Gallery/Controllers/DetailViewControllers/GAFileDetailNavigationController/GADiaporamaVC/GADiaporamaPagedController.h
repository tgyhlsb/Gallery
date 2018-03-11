//
//  GADiaporamaPagedController.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

// Models
#import "GADirectory.h"

@protocol GADiaporamaPagedControllerDelegate;
@protocol GAFileInspectorBarButtonsDataSource;

@interface GADiaporamaPagedController : UIViewController

@property (weak, nonatomic) id<GADiaporamaPagedControllerDelegate> delegate;
@property (weak, nonatomic) id<GAFileInspectorBarButtonsDataSource> barItemDataSource;

@property (strong, nonatomic) NSArray *files;
@property (strong, nonatomic) GAImageFile *selectedImageFile;

+ (instancetype)newWithFiles:(NSArray *)files andSelectedImageFile:(GAImageFile *)imageFile;

- (void)setParentViewController:(UIViewController *)parent withView:(UIView *)view;

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
