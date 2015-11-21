//
//  SavedArticleManager.m
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "SavedArticleManager.h"
#import "Article.h"

@interface SavedArticleManager ()



@end


@implementation SavedArticleManager

+ (instancetype) sharedManager {
    static SavedArticleManager* manager = nil;
    if(manager == nil){
        
        manager = [[self alloc] init];
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.savedArticleArray = [[NSMutableArray alloc] init];
        self.myAccount= [[User alloc] init];
        self.myAccount.savedArticleArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)saveArticle:(Article*)readArticle {
    
    for (Article *otherArticle in self.myAccount.savedArticleArray){
        if ([readArticle.url isEqualToString:otherArticle.url]) {
            return ;
        }
    }
    
    [self.myAccount.savedArticleArray addObject:readArticle];
}

-(SavedArticleAnalysis*)analyzeArticles{
    
    AggregatedAnalysis* analyzedObject = [[AggregatedAnalysis alloc] init];
    
    //    for(Article *article in self.savedArticleArray){
    //
    //        if (article.tone {
    //            <#statements#>
    //        }
    //
    //
    //    }
    
    return analyzedObject;
}
@end
