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
    self.detailArticle.text = [NSString stringWithContentsOfURL:self.detailArticle.url encoding:nil error:error];
    
    NSString *encodedArticleText = [self.detailArticle.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self analysis:@"Sentiment" onText:encodedArticleText withManager:manager];
    [self analysis:@"Subjectivity" onText:encodedArticleText withManager:manager];
    
    
    
    //Sets API for Indico API
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    //Insert text into political analysis.
       [[LQNetworkManager sharedManager] politicalAnalysis:self.detailArticle.text completionHandler:^(NSDictionary *result, NSError *error) {
           
           NSDictionary *politicalAnalysis = result[@"results"];

           NSString *conservativeStringValue = politicalAnalysis[@"Conservative"];
           float conservative = [conservativeStringValue floatValue] * 100;
           
           NSString *greenStringValue = politicalAnalysis[@"Green"];
           float green = [greenStringValue floatValue] * 100;
           
           NSString *liberalStringValue = politicalAnalysis[@"Liberal"];
           float liberal = [liberalStringValue floatValue] * 100;
           
           NSString *libertarianStringValue = politicalAnalysis[@"Libertarian"];
           float libertarian = [libertarianStringValue floatValue] * 100;
           
           self.detailArticle.conservative = conservative;
           self.detailArticle.green = green;
           self.detailArticle.liberal = liberal;
           self.detailArticle.libertarian = libertarian;
           
           NSLog(@"%f", self.detailArticle.libertarian);
       }];
    
    
    
    
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


- (void)analysis:(NSString *)typeOfAnalysisForDatumBox onText:(NSString *)textToAnalyze withManager:(AFHTTPRequestOperationManager *)manager{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.datumbox.com/1.0/%@Analysis.json", typeOfAnalysisForDatumBox];
    
    [manager POST:urlString
       parameters:@{@"api_key": @"8fe3f49401d945d0ca257445a6b1abef",
                    @"text": textToAnalyze}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *data = responseObject[@"output"][@"result"];
              
              if ([typeOfAnalysisForDatumBox isEqualToString:@"Sentiment"]) {
                  self.detailArticle.sentimentAnalysis = data;
                  NSLog(@"%@", self.detailArticle.sentimentAnalysis);
              } else if ([typeOfAnalysisForDatumBox isEqualToString:@"Subjectivity"]){
                  self.detailArticle.subjectivityAnalysis = data;
              }
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"Analysis Modal"]) {
        AnalysisViewController *avc = segue.destinationViewController;
//        avc.articleObject = self.articleObject;
    }
    
}


@end
