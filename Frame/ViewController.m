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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *articleSnippet;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //Datumbox API
//    [manager POST:@"http://api.datumbox.com/1.0/SubjectivityAnalysis.json"
//       parameters:@{@"api_key": @"8fe3f49401d945d0ca257445a6b1abef",
//                    @"text": self.articleSnippet.text}
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSLog(@"JSON: %@", responseObject);
//          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"Error: %@", error);
//          }];
    
    //Diffbot API
    [manager GET:@"http://api.diffbot.com/v3/article"
      parameters:@{@"token": @"fcbd17950b98e6d4138a9de24c642347",
                   @"url": @"http://www.digitalspy.com/movies/star-wars/news/a773508/star-wars-fan-daniel-fleetwood-dies-aged-32/"}
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             NSArray *data = responseObject[@"objects"];
             NSString *text = [data firstObject][@"text"];
             
             NSLog(@"%@",text);
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NSLog(@"Failed.");
         }];
    
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)politicalAnalysisTapped:(UIButton *)sender {
    
    //Indico API
    [[LQNetworkManager sharedManager] politicalAnalysis:self.articleSnippet.text completionHandler:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSLog(@"%@", result);
        } else {
            NSLog(@"Political failure");
        }
    }];
}

- (IBAction)sentimentAnalysisTapped:(UIButton *)sender {
    //Indico API
    [[LQNetworkManager sharedManager] sentimentAnalysis:self.articleSnippet.text completionHandler:^(NSDictionary *result, NSError *error) {
        if (!error) {
            NSLog(@"%@", result);
        } else {
            NSLog(@"sentiment failed");
        }
    }];
}


@end
