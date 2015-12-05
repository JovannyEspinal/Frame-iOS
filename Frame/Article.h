//
//  Article.h
//  Frame
//
//  Created by Jovanny Espinal on 11/13/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DirectionalTone.h"

@interface Article : NSObject <NSCoding>

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *headline;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *text;


@property (strong, nonatomic) NSString *sentimentAnalysis;
@property (strong, nonatomic) NSString *subjectivityAnalysis;


@property (nonatomic) float conservative;
@property (nonatomic) float green;
@property (nonatomic) float liberal;
@property (nonatomic) float libertarian;


@property (nonatomic) DirectionalTone* articlesDirectionalTone;


@end
