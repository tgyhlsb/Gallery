//
//  SRSelection+Serializer.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 09/06/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRSelection.h"

@interface SRSelection (Serializer)

+ (NSString *)className;

+ (SRSelection *)selectionWithTitle:(NSString *)title
             inManagedObjectContext:(NSManagedObjectContext *)context;

@end
