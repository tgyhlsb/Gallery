//
//  GAAlertFactoy.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIkit/UIKit.h>

@interface GAAlertFactoy : NSObject

+ (UIAlertController *)confirmationControllerWithTitle:(NSString *)title
                                               message:(NSString *)message
                                           buttonTitle:(NSString *)buttonTitle;

@end
