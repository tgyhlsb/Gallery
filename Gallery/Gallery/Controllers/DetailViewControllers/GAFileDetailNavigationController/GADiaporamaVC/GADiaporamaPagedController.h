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

@property (weak, nonatomic) id<GADiaporamaPagedControllerDelegate> delegate;

@property (nonatomic) GADiaporamaFileType diaporamaFileType;

@property (strong, nonatomic) NSArray *topLeftBarItems;
@property (strong, nonatomic) NSArray *topRightBarItems;
@property (strong, nonatomic) NSArray *bottomLeftBarItems;
@property (strong, nonatomic) NSArray *bottomRightBarItems;

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

- (void)diaporamaPagedControllerDidUpdateBarItems:(GADiaporamaPagedController *)diaporamaPagedController;

@optional

- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController willShowFile:(GAFile *)file;
- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController mayShowFile:(GAFile *)file;
- (void)diaporamaPagedController:(GADiaporamaPagedController *)diaporamaPagedController didShowFile:(GAFile *)file;

@end
