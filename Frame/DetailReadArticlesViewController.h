//
//  DetailReadArticlesViewController.h
//  Frame
//
//  Created by Bereket  on 11/21/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface DetailReadArticlesViewController : UIViewController

<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *detailLibraryWebView;

@property (nonatomic, strong) NSString* libraryArticleURL;


@end
