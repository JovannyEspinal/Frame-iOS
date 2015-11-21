//
//  SavedArticleManager.h
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@class Article;
@class SavedArticleAnalysis;

@interface SavedArticleManager : NSObject

@property (nonatomic) User* myAccount;

+ (instancetype) sharedManager;
-(void)saveArticle:(Article*)readArticle;

-(SavedArticleAnalysis*)analyzeArticles;


@end
