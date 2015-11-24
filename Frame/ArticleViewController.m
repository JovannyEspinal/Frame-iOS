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

- (void)viewDidLoad {
    
   // [self directionalToneAPI];
    
    
    // Loads webview with url
    NSURL *url = [NSURL URLWithString:self.detailArticle.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    
    [self.webView loadRequest:urlRequest];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSError* error = nil;
    self.detailArticle.text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error: &error];
    
    NSString *encodedArticleText = [self.detailArticle.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self analysis:@"Sentiment" onText:encodedArticleText withManager:manager];
    [self analysis:@"Subjectivity" onText:encodedArticleText withManager:manager];
    
    
    
//    //Sets API for Indico API
//    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
//    
//    //Insert text into political analysis.
//       [[LQNetworkManager sharedManager] politicalAnalysis:self.detailArticle.text completionHandler:^(NSDictionary *result, NSError *error) {
//           
//           NSDictionary *politicalAnalysis = result[@"results"];
//
//           NSString *conservativeStringValue = politicalAnalysis[@"Conservative"];
//           float conservative = [conservativeStringValue floatValue] * 100;
//           
//           NSString *greenStringValue = politicalAnalysis[@"Green"];
//           float green = [greenStringValue floatValue] * 100;
//           
//           NSString *liberalStringValue = politicalAnalysis[@"Liberal"];
//           float liberal = [liberalStringValue floatValue] * 100;
//           
//           NSString *libertarianStringValue = politicalAnalysis[@"Libertarian"];
//           float libertarian = [libertarianStringValue floatValue] * 100;
//           
//           self.detailArticle.conservative = conservative;
//           self.detailArticle.green = green;
//           self.detailArticle.liberal = liberal;
//           self.detailArticle.libertarian = libertarian;
//           
//           NSLog(@"%f", self.detailArticle.libertarian);
//       }];
//    
    
    
    
//    //datumbox API call - You can find edit the SentimentAnalysis to whichever one from the list at http://www.datumbox.com/files/API-Documentation-1.0v.pdf
//    
//    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

//-(void)directionalToneAPI   {
//    
// //   NSString* textToAnalyze;
//  //  NSString* APIKey = [NSString stringWithFormat:@"bdde6d0c11719557a37f27a1070b23990b11fc47"];
//    NSString* alchemyURL = @"https://gateway-a.watsonplatform.net/calls/url/URLGetRelations";
//    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    
//    [manager GET:alchemyURL
//      parameters: @{@"apikey" : @"bdde6d0c11719557a37f27a1070b23990b11fc47",
//                    @"url"    : self.detailArticle.url,
//                    @"outputMode" : @"json",
//                    @"sentiment"  : @"1"
//                    }
//     
//     
//         success:^(AFHTTPRequestOperation *operation, id responseObject){
//             NSLog(@"%@",[responseObject description]);
//         }
//     
//         failure:^(AFHTTPRequestOperation *operation, NSError* error){
//             NSLog(@"%@", error);
//             NSLog(@"boo");
//         }];
//
//}
//
//


//-------------------------------------------------------------------------------------------------------------------------------------------------

//Method does the API Call and calls the methods that then add up the values for the Aggregated Analysis
- (void)analysis:(NSString *)typeOfAnalysisForDatumBox onText:(NSString *)textToAnalyze withManager:(AFHTTPRequestOperationManager *)manager{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.datumbox.com/1.0/%@Analysis.json", typeOfAnalysisForDatumBox];
    
    [manager POST:urlString
       parameters:@{@"api_key": @"8fe3f49401d945d0ca257445a6b1abef",
                    @"text": textToAnalyze}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
               self.data = responseObject[@"output"][@"result"];
              
              if ([typeOfAnalysisForDatumBox isEqualToString:@"Sentiment"]) {
                self.detailArticle.sentimentAnalysis = self.data;
                SavedArticleManager.sharedManager.myAccount.savedArticleArray.lastObject.sentimentAnalysis = self.detailArticle.sentimentAnalysis;
                  [self totalTone];
              }

            if ([typeOfAnalysisForDatumBox isEqualToString:@"Subjectivity"]){
                          self.detailArticle.subjectivityAnalysis = self.data;
                          
                          SavedArticleManager.sharedManager.myAccount.savedArticleArray.lastObject.sentimentAnalysis = self.detailArticle.sentimentAnalysis;
                
                          [self totalSubjectivity];
                   
                               }

              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
}
//-----------------------------------------------------------------------------------------------------------------------------------------------




//-----------------------------------------------------------------------------------------------------------------------------------------------

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
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNegativeToneCount =  SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount + 1;
        NSLog(@"Neutral tone count:, %ld", (long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalNeutralToneCount);

    }

   
    NSLog(@"%@", self.detailArticle.sentimentAnalysis);

}
//-----------------------------------------------------------------------------------------------------------------------------------------------





//-----------------------------------------------------------------------------------------------------------------------------------------------

//method checks the subjectivity value and adds it to the count of the respective property on the Aggregated Analysis

-(void)totalSubjectivity{
    
    
    if ([self.detailArticle.subjectivityAnalysis isEqualToString:@"objective"]) {
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount = SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount +1;
        
        NSLog(@"Total objectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount);
        NSLog(@"Total subjectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount);

        NSLog(@"%@", self.detailArticle.subjectivityAnalysis);
    }
    
    
    if ([self.detailArticle.subjectivityAnalysis isEqualToString:@"subjective"]){
        
        SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount = SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount +1;
        
        NSLog(@"Total subjectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalsubjectiveArticleCount);
        NSLog(@"Total objectivity count:, %ld",(long)SavedArticleManager.sharedManager.myAccount.usersTotalBias.totalObjectiveArticleCount);

        NSLog(@"%@", self.detailArticle.subjectivityAnalysis);

    }

//-----------------------------------------------------------------------------------------------------------------------------------------------



//-------------------------------------------------------
    
    
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
