//
//  SRDiaporamaViewController.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 04/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRViewController.h"

// Model
#import "SRDirectory.h"
#import "SRImage.h"

@interface SRDiaporamaViewController : SRViewController

@property (strong, nonatomic) SRImage *activeImage;

+ (instancetype)newWithResultController:(NSFetchedResultsController *)fetchedResultController activeImage:(SRImage *)activeImage;


@end
