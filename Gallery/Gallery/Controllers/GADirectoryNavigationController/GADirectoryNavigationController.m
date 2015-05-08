//
//  GADirectoryNavigationController.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 03/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GADirectoryNavigationController.h"

@interface GADirectoryNavigationController ()

@property (strong, nonatomic) GADirectory *rootDirectory;

@end

@implementation GADirectoryNavigationController

#pragma mark - Constructors

+ (instancetype)newWithRootDirectory:(GADirectory *)rootDirectory {
    return [[GADirectoryNavigationController alloc] initWithRootDirectory:rootDirectory];
}

- (id)initWithRootDirectory:(GADirectory *)rootDirectory {
    GADirectoryInspectorVC *rootVC = [GADirectoryInspectorVC newWithDirectory:rootDirectory];
    self = [super initWithRootViewController:rootVC];
    if (self) {
        self.rootDirectory = rootDirectory;
        rootVC.delegate = self;
    }
    return self;
}

#pragma mark - UINAvigationController overrides

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
//    Attach delegate of all directory inspectors
    if ([viewController isKindOfClass:[GADirectoryInspectorVC class]]) {
        ((GADirectoryInspectorVC *)viewController).delegate = self;
    }
    
    [super pushViewController:viewController animated:animated];
}

#pragma mark - GADirectoryInspectorDelegate

- (void)directoryInspector:(GADirectoryInspectorVC *)inspectorVC didSelectImageFile:(GAImageFile *)imageFile {
    
    if ([self.directoryDelegate respondsToSelector:@selector(directoryInspector:didSelectImageFile:)]) {
        [self.directoryDelegate directoryInspector:inspectorVC didSelectImageFile:imageFile];
    }
}

- (void)directoryInspector:(GADirectoryInspectorVC *)inspectorVC didSelectDirectory:(GADirectory *)directory {
    
    if ([self.directoryDelegate respondsToSelector:@selector(directoryInspector:didSelectDirectory:)]) {
        [self.directoryDelegate directoryInspector:inspectorVC didSelectDirectory:directory];
    }
}

@end
