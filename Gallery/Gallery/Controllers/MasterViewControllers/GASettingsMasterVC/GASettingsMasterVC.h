//
//  GASettingsMasterVC.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GASettingsInspectorDelegate;

@interface GASettingsMasterVC : UITableViewController

@property (weak, nonatomic) id<GASettingsInspectorDelegate> delegate;

@end

@protocol GASettingsInspectorDelegate <NSObject>

- (void)settingsInspectorDidSelectThumbnailsSettings;
- (void)settingsInspectorDidSelectDirectoryNavigationSettings;
- (void)settingsInspectorDidSelectLoggerSettings;

@end
