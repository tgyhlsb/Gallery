//
//  GAAlertFactoy.m
//  Gallery
//
//  Created by Tanguy Hélesbeux on 09/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "GAAlertFactoy.h"

// Managers
#import "GALogger.h"

@implementation GAAlertFactoy

+ (UIAlertController *)confirmationControllerWithTitle:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:title
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *confirmAction = [UIAlertAction
                                   actionWithTitle:buttonTitle
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [GALogger addInformation:@"User confirmed \"%@ - %@\"", title, message];
                                   }];
    
    [alertController addAction:confirmAction];
    
    return alertController;
}

@end
