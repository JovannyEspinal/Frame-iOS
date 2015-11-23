//
//  NewsTableViewCell.h
//  Frame
//
//  Created by Jovanny Espinal on 11/21/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MGSwipeTableCell/MGSwipeTableCell.h>

@interface NewsTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *headline;
@property (weak, nonatomic) IBOutlet UIImageView *articleImage;


@end
