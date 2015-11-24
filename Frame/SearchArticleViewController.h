//
//  SearchArticleViewController.h
//  Frame
//
//  Created by Jovanny Espinal on 11/24/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface SearchArticleViewController : UIViewController
@property (strong, nonatomic) Article *searchResult;
@property (nonatomic, strong) NSString* data;

@end
