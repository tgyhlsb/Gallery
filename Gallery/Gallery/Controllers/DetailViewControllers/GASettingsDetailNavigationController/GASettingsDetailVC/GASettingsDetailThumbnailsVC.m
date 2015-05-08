//
//  GASettingsDetailThumbnailsVC.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 08/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GASettingsDetailThumbnailsVC.h"

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
                            NSLocalizedString(@"SETTINGS_THUMBNAIL_MODE", nil)
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
                                @[@(UIViewContentModeScaleToFill), @(UIViewContentModeScaleAspectFill), @(UIViewContentModeScaleAspectFit)]
                                ]
                            ];
}

- (void)initializePossibleValueTitles {
    self.possibleValueTitles = @[
                                 @[
                                     @[NSLocalizedString(@"YES", nil), NSLocalizedString(@"NO", nil)],
                                     @[@"50", @"100", NSLocalizedString(@"UNLIMITED", nil)]
                                     ],
                                 @[
                                     @[NSLocalizedString(@"SETTINGS_THUMBNAIL_MODE_RESIZE", nil), NSLocalizedString(@"SETTINGS_THUMBNAIL_MODE_FILL", nil), NSLocalizedString(@"SETTINGS_THUMBNAIL_MODE_FIT", nil)]
                                     ]
                                 ];
}

- (void)initializeSelectedValues {
    self.selectedValues = @[
                            @[
                                @([GASettingsManager shouldCacheThumbnails]),
                                @([GASettingsManager thumbnailCacheLimit])
                                ],
                            @[
                                @([GASettingsManager thumbnailMode])
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
                               @"setThumbnailMode:"
                               ],
                           @[
                               @"resetCache"
                               ]
                           ];
}

#pragma mark - Handlers

- (void)setShouldCache:(NSObject *)value {
    BOOL boolValue = [((NSNumber *)value) boolValue];
    [GASettingsManager setShouldCacheThumbnails:boolValue];
}

- (void)setCacheLimit:(NSObject *)value {
    NSInteger intValue = [((NSNumber *)value) integerValue];
    [GASettingsManager setTumbnailCacheLimit:intValue];
}

- (void)setThumbnailMode:(NSObject *)value {
    NSInteger intValue = [((NSNumber *)value) integerValue];
    [GASettingsManager setThumbnailMode:intValue];
}

- (void)resetCache {
    [GACacheManager clearThumbnails];
}

@end
