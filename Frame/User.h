//
//  User.h
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AggregatedAnalysis.h"
#import  <UIKit/UIKit.h>
#import "Article.h"

@interface User : NSObject

@property (nonatomic, strong) AggregatedAnalysis* usersTotalBias;
@property (nonatomic, strong) UIImage* profilePic;
@property (nonatomic, strong) NSMutableArray<Article *> *savedArticleArray;



//Signup so we can differentiate users on Parse
@property (nonatomic) NSString* userName;
@property (nonatomic) NSString* password;

@end
