//
//  User.h
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AggregatedAnalysis.h"
#import  <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic, strong) AggregatedAnalysis* usersTotalBias;
@property (nonatomic, strong) UIImage* profilePic;
@property (nonatomic, strong) NSMutableArray* savedArticleArray;

@end
