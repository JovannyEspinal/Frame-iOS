//
//  ViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/6/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "ViewController.h"
#import "LQNetworkManager.h"
#import "AFNetworking.h"
#import "APIManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *articleSnippet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    [manager GET:@"https://api.datumbox.com/1.0/SentimentAnalysis.json?api_key=8fe3f49401d945d0ca257445a6b1abef&text=i%20like%20cheese"
       parameters:nil
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"JSON: %@", responseObject);
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {l
              NSLog(@"Error: %@", error);
          }];
    
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)politicalAnalysisTapped:(UIButton *)sender {
    [[LQNetworkManager sharedManager] politicalAnalysis:self.articleSnippet.text completionHandler:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSLog(@"%@", result);
        } else {
            NSLog(@"Political failure");
        }
    }];
}

- (IBAction)sentimentAnalysisTapped:(UIButton *)sender {
    [[LQNetworkManager sharedManager] sentimentAnalysis:self.articleSnippet.text completionHandler:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSLog(@"%@", result);
        } else {
            NSLog(@"sentiment failed");
        }
    }];
}


@end
