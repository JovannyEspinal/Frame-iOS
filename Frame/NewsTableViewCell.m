//
//  NewsTableViewCell.m
//  Frame
//
//  Created by Jovanny Espinal on 11/21/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "NewsTableViewCell.h"

@implementation NewsTableViewCell

- (void)awakeFromNib {
    
    self.articleImage.image = [UIImage imageNamed:@"default-photo"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
