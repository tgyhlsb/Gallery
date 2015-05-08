//
//  GASettingsDetailThumbnailsVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsDetailThumbnailsVC.h"

// Managers
#import "GASettingsManager.h"
#import "GACacheManager.h"
#import "GALogger.h"

#define CACHE_LIMIT_UNLIMITED 1000

@interface GASettingsDetailThumbnailsVC ()

@end

@implementation GASettingsDetailThumbnailsVC

+ (instancetype)new {
    GASettingsDetailThumbnailsVC *controller = [[GASettingsDetailThumbnailsVC alloc] initWithNibName:@"GASettingsDetailVC" bundle:nil];
    return controller;
}

#pragma mark - Configuration

- (void)initializeCellTitles {
    self.cellTitles = @[
                        @[
                            NSLocalizedString(@"SETTINGS_THUMBNAIL_SHOULD_CACHE", nil),
                            NSLocalizedString(@"SETTINGS_THUMBNAIL_CACHE_LIMIT", nil)
                            ],
                        @[
                            NSLocalizedString(@"SETTINGS_THUMBNAIL_RESET", nil)
                            ]
                        ];
}

- (void)initializeSectionHeaders {
    self.sectionHeaders = @[
                            ];
}

- (void)initializeSectionFooters {
    self.sectionFooters = @[
                            ];
}

- (void)initializePossibleValues {
    self.possibleValues = @[
                            @[
                                @[@YES, @NO],
                                @[@50, @100, @CACHE_LIMIT_UNLIMITED]
                                ],
                            @[
                                // nil
                                ]
                            ];
}

- (void)initializePossibleValueTitles {
    self.possibleValueTitles = @[
                                 @[
                                     @[NSLocalizedString(@"YES", nil), NSLocalizedString(@"NO", nil)],
                                     @[@"50", @"100", NSLocalizedString(@"UNLIMITED", nil)]
                                     ]
                                 ];
}

- (void)initializeSelectedValues {
    self.selectedValues = @[
                            @[
                                @([GACacheManager shouldCacheThumbnails]),
                                @([GASettingsManager thumbnailCacheLimit])
                                ]
                            ];
}

- (void)initializeSelectors {
    self.selectorNames = @[
                           @[
                               @"setShouldCache:",
                               @"setCacheLimit:"
                               ],
                           @[
                               @"resetCache"
                               ]
                           ];
}

#pragma mark - Handlers

- (void)setShouldCache:(NSObject *)value {
    BOOL boolValue = [((NSNumber *)value) boolValue];
    [GACacheManager shouldCacheThumbnails:boolValue];
}

- (void)setCacheLimit:(NSObject *)value {
    NSInteger intValue = [((NSNumber *)value) integerValue];
    [GASettingsManager setTumbnailCacheLimit:intValue];
}

- (void)resetCache {
    [GACacheManager clearThumbnails];
}

@end
