//
//  SRCollectionReusableHeader.h
//  Gallery
//
//  Created by Tanguy Hélesbeux on 12/05/2015.
//  Copyright (c) 2015 Tanguy Hélesbeux. All rights reserved.
//

#import "SRCollectionReusableHeader.h"

#import "SRTextAttachment.h"

@interface SRCollectionReusableHeader()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SRCollectionReusableHeader

+ (NSString *)preferredKind {
    return UICollectionElementKindSectionHeader;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (self.title) {
        [self updateTitle];
    }
    
    self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self updateTitle];
}

- (void)updateTitle {
    
    SRTextAttachment *attachment = [[SRTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"breadcrumb.png"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *attributedTitle = [NSMutableAttributedString new];
    NSArray *directories = [self.title componentsSeparatedByString:@"/"];
    
    for (NSString *directory in directories) {
        if (directory.length > 0) {
            NSMutableAttributedString *directoryString = [[NSMutableAttributedString alloc] initWithString:directory];
            [attributedTitle appendAttributedString:attachmentString];
            [attributedTitle appendAttributedString:directoryString];
        }
    }
    
    self.titleLabel.attributedText = attributedTitle;
    
}

@end
