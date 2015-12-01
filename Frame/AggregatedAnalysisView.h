//
//  AggregatedAnalysisView.h
//  Frame
//
//  Created by Bereket  on 11/30/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KOPopupView/KOPopupView.h>
#import <PNChart/PNChart.h>

@interface AggregatedAnalysisView : UIView

@property (nonatomic) PNPieChart *tonePieChart;
@property (nonatomic) PNPieChart *objectiveSubjectivePieChart;
@property (nonatomic) UIButton*  dismissViewButton;

@end
