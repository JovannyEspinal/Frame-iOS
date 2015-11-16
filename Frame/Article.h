//
//  Article.h
//  Frame
//
//  Created by Jovanny Espinal on 11/13/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Article : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *imageUrl;

@end
