//
//  ArticleViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/16/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "ArticleViewController.h"
#import "AnalysisViewController.h"
#import "LQNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "NewsViewController.h"
#import "SavedArticleManager.h"

@interface ArticleViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ArticleViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    // Loads webview with url
    NSURL *url = [NSURL URLWithString:self.detailArticle.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    [self.webView loadRequest:urlRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    NSURL *url = [NSURL URLWithString:self.detailArticle.url];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError* error = nil;
    self.detailArticle.text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error: &error];
    
    NSString *encodedArticleText = [self.detailArticle.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self sentimentAnalysis:self.detailArticle];
    [self analysis:@"Subjectivity" onText:encodedArticleText withManager:manager];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}


//-------------------------------------------------------------------------------------------------------------------------------------------------

//Method does the API Call and calls the methods that then add up the values for the Aggregated Analysis
- (void)analysis:(NSString *)typeOfAnalysisForDatumBox onText:(NSString *)textToAnalyze withManager:(AFHTTPRequestOperationManager *)manager{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.datumbox.com/1.0/%@Analysis.json", typeOfAnalysisForDatumBox];
    
    [manager POST:urlString
       parameters:@{@"api_key": @"8fe3f49401d945d0ca257445a6b1abef",
                    @"text": textToAnalyze}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              self.data = responseObject[@"output"][@"result"];
              
              self.detailArticle.subjectivityAnalysis = self.data;
              
              SavedArticleManager.sharedManager.myAccount.savedArticleArray.lastObject.subjectivityAnalysis = self.detailArticle.subjectivityAnalysis;
              
              NSLog(@"%@", self.data);
              
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
            self.detailArticle.sentimentAnalysis = @"positive";
        } else if (sentimentValue == 0.5){
            self.detailArticle.sentimentAnalysis = @"neutral";
        } else {
            self.detailArticle.sentimentAnalysis = @"negative";
        }
        
        SavedArticleManager.sharedManager.myAccount.savedArticleArray.lastObject.sentimentAnalysis = self.detailArticle.sentimentAnalysis;
        
        [self totalTone];
    }];
}

//method checks the tone value and adds it to the count of the respective property on the Aggregated Analysis
-(void)totalTone{
    
    if ([self.detailArticle.sentimentAnalysis isEqualToString: @"positive"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalPositiveToneCount =  SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalPositiveToneCount +1;
        NSLog(@"Positive Tone Count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalPositiveToneCount);
    }
    
    else if ([self.detailArticle.sentimentAnalysis isEqualToString: @"negative"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNegativeToneCount =  SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNegativeToneCount +1;
        NSLog(@"Negative Tone Count:, %ld", (long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNegativeToneCount);
        
    }
    
    else if ([self.detailArticle.sentimentAnalysis isEqualToString: @"neutral"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount =  SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount + 1;
        NSLog(@"Neutral tone count:, %ld", (long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount);
        
    }
    
    
    NSLog(@"%@", self.detailArticle.sentimentAnalysis);
    
}
//-----------------------------------------------------------------------------------------------------------------------------------------------





//-----------------------------------------------------------------------------------------------------------------------------------------------

//method checks the subjectivity value and adds it to the count of the respective property on the Aggregated Analysis

-(void)totalSubjectivity{
    
    
    if ([self.detailArticle.subjectivityAnalysis isEqualToString:@"objective"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount += 1;
        
        NSLog(@"Total objectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount);
        NSLog(@"Total subjectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount);

    }
    
    
    if ([self.detailArticle.subjectivityAnalysis isEqualToString:@"subjective"]){
        
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount += 1;
        
        NSLog(@"Total subjectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount);
        NSLog(@"Total objectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount);
        
    }
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------
    
    
    
    //-----------------------------------------------------------------------------------------------------------------------------------------------
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}


@end
