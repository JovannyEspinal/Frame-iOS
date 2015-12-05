//
//  SavedArticleManager.m
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "SavedArticleManager.h"
#import "Article.h"

static NSString *FRSavedArticlesKey = @"FRSavedArticlesKey";

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
        
        //user class
        self.myAccount= [[User alloc] init];
        
        //users agreggated bias
        self.myAccount.usersTotalBias = [[AggregatedAnalysis alloc] init];
        

        //Version one aggregator for user bias
            // political aggregator
        self.myAccount.usersTotalBias.totalConservativeCount = 0;
        self.myAccount.usersTotalBias.totalLiberalCount = 0;
        self.myAccount.usersTotalBias.totalGreenCOUNT = 0;
        self.myAccount.usersTotalBias.totalLibertarianCount=0;
        
            // objectivity/subjectivity aggregator
        self.myAccount.usersTotalBias.totalsubjectiveArticleCount = 0;
        self.myAccount.usersTotalBias.totalObjectiveArticleCount = 0;
        
            // positivity/negativity/neutrality aggregator
        self.myAccount.usersTotalBias.totalPositiveToneCount = 0;
        self.myAccount.usersTotalBias.totalNegativeToneCount = 0;
        self.myAccount.usersTotalBias.totalNeutralToneCount  = 0;
        
        //array that stores article objects
        NSArray *articles = [self loadPersistedArticles];
        if (articles) {
            self.myAccount.savedArticleArray = [articles mutableCopy];
        } else {
            self.myAccount.savedArticleArray = [[NSMutableArray alloc] init];
        }
        


    }
    return self;
}

- (void)addArticle:(Article *)article {
    [self.myAccount.savedArticleArray addObject:article];
    
    [self persistArticles];
}

// this method is for saving articles to NSUserDefaults
- (void)persistArticles {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.myAccount.savedArticleArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:FRSavedArticlesKey];
}

- (NSArray *)loadPersistedArticles {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults valueForKey:FRSavedArticlesKey] != nil) {
        NSData *data = [defaults objectForKey:FRSavedArticlesKey];
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return array;
    }
    return nil;
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
