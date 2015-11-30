//
//  ReadArticlesTableViewCell.h
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavedArticleManager.h"
#import "UserProfileViewController.h"
#import <MGSwipeTableCell/MGSwipeTableCell.h>


@interface ReadArticlesTableViewCell : MGSwipeTableCell


@property (nonatomic) Article* readArticle;


@end
