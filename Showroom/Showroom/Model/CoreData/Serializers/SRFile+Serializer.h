//
//  SRFile+Serializer.h
//  Showroom
//
//  Created by Tanguy Hélesbeux on 15/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRFile.h"

@interface SRFile (Serializer)

- (void)updateWithPath:(NSString *)path attributes:(NSDictionary *)attributes;

@end
