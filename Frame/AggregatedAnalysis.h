//
//  AggregatedAnalysis.h
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AggregatedAnalysis : NSObject


@property (nonatomic) NSInteger  totalObjectiveArticleCount;
@property (nonatomic) NSInteger  subjectiveArticleCount;
@property (nonatomic) NSInteger  totalPositiveToneCount;
@property (nonatomic) NSInteger  totalNegativeToneCount;




@property (nonatomic) float totalConservativeCount;
@property (nonatomic) float totalGreenCOUNT;
@property (nonatomic) float totalLiberalCount;
@property (nonatomic) float totalLibertarianCount;



@end
