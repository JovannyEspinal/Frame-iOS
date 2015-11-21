//
//  AggregatedAnalysis.h
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AggregatedAnalysis : NSObject


@property (strong, nonatomic) NSString *totalObjectiveArticleCount;
@property (strong, nonatomic) NSString *subjectiveArticleCount;
@property (strong, nonatomic) NSString *totalPositiveToneCount;
@property (strong, nonatomic) NSString *totalNegativeToneCount;




@property (nonatomic) float totalConservativeCount;
@property (nonatomic) float totalGreenCOUNT;
@property (nonatomic) float totalLiberalCount;
@property (nonatomic) float totalLibertarianCount;



@end
