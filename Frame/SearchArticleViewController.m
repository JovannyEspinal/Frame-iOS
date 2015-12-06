//
//  SearchArticleViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/24/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "SearchArticleViewController.h"
#import "LQNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "SavedArticleManager.h"

@interface SearchArticleViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SearchArticleViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
     [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    
    // Loads webview with url
    NSURL *url = [NSURL URLWithString:self.searchResult.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    
    [self.webView loadRequest:urlRequest];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError* error = nil;
    self.searchResult.text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error: &error];
    
    NSString *encodedArticleText = [self.searchResult.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self sentimentAnalysis:self.searchResult];
    [self analysis:@"Subjectivity" onText:encodedArticleText withManager:manager];
    
    
    
    //Sets API for Indico API
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    //Insert text into political analysis.
    [[LQNetworkManager sharedManager] politicalAnalysis:self.searchResult.text completionHandler:^(NSDictionary *result, NSError *error) {
        
        NSDictionary *politicalAnalysis = result[@"results"];
        
        NSString *conservativeStringValue = politicalAnalysis[@"Conservative"];
        float conservative = [conservativeStringValue floatValue] * 100;
        
        NSString *greenStringValue = politicalAnalysis[@"Green"];
        float green = [greenStringValue floatValue] * 100;
        
        NSString *liberalStringValue = politicalAnalysis[@"Liberal"];
        float liberal = [liberalStringValue floatValue] * 100;
        
        NSString *libertarianStringValue = politicalAnalysis[@"Libertarian"];
        float libertarian = [libertarianStringValue floatValue] * 100;
        
        self.searchResult.conservative = conservative;
        self.searchResult.green = green;
        self.searchResult.liberal = liberal;
        self.searchResult.libertarian = libertarian;
    }];


}

- (void)analysis:(NSString *)typeOfAnalysisForDatumBox onText:(NSString *)textToAnalyze withManager:(AFHTTPRequestOperationManager *)manager{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.datumbox.com/1.0/%@Analysis.json", typeOfAnalysisForDatumBox];
    
    [manager POST:urlString
       parameters:@{@"api_key": @"8fe3f49401d945d0ca257445a6b1abef",
                    @"text": textToAnalyze}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              self.data = responseObject[@"output"][@"result"];

                  self.searchResult.subjectivityAnalysis = self.data;
                  
                  SavedArticleManager.sharedManager.myAccount.savedArticleArray.lastObject.subjectivityAnalysis = self.searchResult.subjectivityAnalysis;
                  
                  [self totalSubjectivity];
              
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
}

-(void)sentimentAnalysis:(Article *)articleObject{
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithData:[articleObject.text dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: [NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    NSString *text = [attributedText string];
    
    [[LQNetworkManager sharedManager] sentimentAnalysis:text completionHandler:^(NSDictionary *result, NSError *error) {

        float sentimentValue = [result[@"results"] floatValue];
        
        if (sentimentValue > 0.5) {
            self.searchResult.sentimentAnalysis = @"positive";
        } else if (sentimentValue == 0.5){
            self.searchResult.sentimentAnalysis = @"neutral";
        } else {
            self.searchResult.sentimentAnalysis = @"negative";
        }
        
        SavedArticleManager.sharedManager.myAccount.savedArticleArray.lastObject.sentimentAnalysis = self.searchResult.sentimentAnalysis;
        
        [self totalTone];
    }];
}

-(void)totalTone{
    
    if ([self.searchResult.sentimentAnalysis isEqualToString: @"positive"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalPositiveToneCount =  SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalPositiveToneCount +1;
        NSLog(@"Positive Tone Count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalPositiveToneCount);
    }
    
    else if ([self.searchResult.sentimentAnalysis isEqualToString: @"negative"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNegativeToneCount =  SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNegativeToneCount +1;
        NSLog(@"Negative Tone Count:, %ld", (long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNegativeToneCount);
        
    }
    
    else if ([self.searchResult.sentimentAnalysis isEqualToString: @"neutral"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount =  SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount + 1;
        NSLog(@"%@", self.searchResult.sentimentAnalysis);
        NSLog(@"Neutral tone count:, %ld", (long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount);
        
        
        
    }
    
}

-(void)totalSubjectivity{
    
    
    if ([self.searchResult.subjectivityAnalysis isEqualToString:@"objective"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount = SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount +1;
        
        NSLog(@"Total objectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount);
    }
    else if ([self.searchResult.subjectivityAnalysis isEqualToString:@"subjective"]){
        
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount = SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount +1;
        
        NSLog(@"Total subjectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount);
        NSLog(@"%@", self.searchResult.subjectivityAnalysis);
        
    }

}

@end
