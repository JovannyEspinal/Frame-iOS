//
//  ArticleViewController.h
//  Frame
//
//  Created by Jovanny Espinal on 11/16/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ArticleViewController : UIViewController <WKNavigationDelegate>

@property (nonatomic) NSString *url;

@end
