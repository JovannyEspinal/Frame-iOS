//
//  DetailReadArticlesViewController.m
//  Frame
//
//  Created by Bereket  on 11/21/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//
//



#import "DetailReadArticlesViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface DetailReadArticlesViewController ()

@end

@implementation DetailReadArticlesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSURL *url = [NSURL URLWithString:self.libraryArticle.url];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    
    
    [self.detailLibraryWebView loadRequest:urlRequest];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
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
