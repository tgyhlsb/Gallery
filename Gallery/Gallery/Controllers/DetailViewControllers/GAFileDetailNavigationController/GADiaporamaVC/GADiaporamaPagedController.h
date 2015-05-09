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
#import "GAImageFile.h"

@protocol GADiaporamaPagedControllerDelegate;

typedef NS_ENUM(NSInteger,GADiaporamaFileType){
    GADiaporamaFileTypeAll,
    GADiaporamaFileTypeImages,
    GADiaporamaFileTypeDirectories
};

@interface GADiaporamaPagedController : UIViewController

@property (weak, nonatomic) id<GADiaporamaPagedControllerDelegate> diaporamDelegate;

@property (nonatomic) GADiaporamaFileType diaporamaFileType;

- (UIBarButtonItem *)diaporamaFileTypeBarButton;

- (void)setParentViewController:(UIViewController *)parent withView:(UIView *)view;

- (void)reloadCenterViewController;
- (void)showFile:(GAFile *)file;
- (void)showImage:(GAImageFile *)imageFile;
- (void)showDirectory:(GADirectory *)directory;
- (void)showNext;
- (void)showPrevious;

@end

@protocol GADiaporamaPagedControllerDelegate <NSObject>

- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController didUpdateRightNavigationItems:(NSArray *)rightItems;
- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController didUpdateLeftNavigationItems:(NSArray *)rightItems;

@optional

- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController willShowFile:(GAFile *)file;
- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController didShowFile:(GAFile *)file;

@end
