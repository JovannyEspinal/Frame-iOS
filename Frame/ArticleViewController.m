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

@interface ArticleViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ArticleViewController

- (void)viewDidLoad {
    // Loads webview with url
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:urlRequest];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
//    NSString *encodedArticleText = [self.articleObject.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    
//    [self analysis:@"Sentiment" onText:encodedArticleText withManager:manager];
//    [self analysis:@"Subjectivity" onText:encodedArticleText withManager:manager];
//    
//    
//    
//    //Sets API for Indico API
//    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
//    
//    //Insert text into political analysis.
//       [[LQNetworkManager sharedManager] politicalAnalysis:self.articleObject.text completionHandler:^(NSDictionary *result, NSError *error) {
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
//           self.articleObject.conservative = conservative;
//           self.articleObject.green = green;
//           self.articleObject.liberal = liberal;
//           self.articleObject.libertarian = libertarian;
//           
//           NSLog(@"%f", self.articleObject.libertarian);
//       }];
//    
//    
//    
//    
//    //datumbox API call - You can find edit the SentimentAnalysis to whichever one from the list at http://www.datumbox.com/files/API-Documentation-1.0v.pdf
//    
//    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

//- (void)analysis:(NSString *)typeOfAnalysisForDatumBox onText:(NSString *)textToAnalyze withManager:(AFHTTPRequestOperationManager *)manager{
//    
//    NSString *urlString = [NSString stringWithFormat:@"http://api.datumbox.com/1.0/%@Analysis.json", typeOfAnalysisForDatumBox];
//    
//    [manager POST:urlString
//       parameters:@{@"api_key": @"8fe3f49401d945d0ca257445a6b1abef",
//                    @"text": textToAnalyze}
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              
//              NSString *data = responseObject[@"output"][@"result"];
//              
//              if ([typeOfAnalysisForDatumBox isEqualToString:@"Sentiment"]) {
//                  self.articleObject.sentimentAnalysis = data;
//                  NSLog(@"%@", self.articleObject.sentimentAnalysis);
//              } else if ([typeOfAnalysisForDatumBox isEqualToString:@"Subjectivity"]){
//                  self.articleObject.subjectivityAnalysis = data;
//              }
//              
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", error);
//          }];
//    
//}


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
