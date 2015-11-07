//
//  APIManager.m
//  Frame
//
//  Created by Jovanny Espinal on 11/7/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "APIManager.h"

@implementation APIManager

-(void)GETRequestWithURL:(NSURL *)URL
completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))
completionHandler {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData * data, NSURLResponse *response, NSError * error) {
        
        NSLog(@"%@",data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(data, response, error);
            
        });
    }];
    
    [task resume];
}


@end
