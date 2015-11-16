//
//  AnalysisViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/16/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "AnalysisViewController.h"
#import "LQNetworkManager.h"
#import <AFNetworking/AFNetworking.h>


@interface AnalysisViewController ()

@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    //datumbox API call - You can find edit the SentimentAnalysis to whichever one from the list at http://www.datumbox.com/files/API-Documentation-1.0v.pdf
    [manager GET:@"https://api.datumbox.com/1.0/SentimentAnalysis.json?api_key=8fe3f49401d945d0ca257445a6b1abef&text=i%20like%20cheese"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             NSLog(@"JSON: %@", responseObject);
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"Error: %@", error);
         }];
    
    
    //Sets API for Indico API
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    //Insert text into political analysis.
//    [LQNetworkManager sharedManager] politicalAnalysis:(NSString *) completionHandler:^(NSDictionary *result, NSError *error) {
//        code
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
