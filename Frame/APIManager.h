//
//  APIManager.h
//  Frame
//
//  Created by Jovanny Espinal on 11/7/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIManager : NSObject

-(void)GETRequestWithURL:(NSURL *)URL
       completionHandler:(void(^)(NSData *, NSURLResponse *, NSError *))
completionHandler;

@end
