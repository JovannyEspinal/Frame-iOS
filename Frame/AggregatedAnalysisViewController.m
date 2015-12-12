//
//  AggregatedAnalysisViewController.m
//  Frame
//
//  Created by Bereket  on 11/23/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "AggregatedAnalysisViewController.h"

@interface AggregatedAnalysisViewController ()

@property (nonatomic, strong) AggregatedAnalysisView *analyzedView;

@end

@implementation AggregatedAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalNegativeToneCount color:PNRed description:@"Negative"],
                       [PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalPositiveToneCount color:PNBlue description:@"Positive"],
                       [PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalNeutralToneCount color:PNGreen description:@"Neutral"],
                       ];
    
    NSArray* subjectivityArray = @[[PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalObjectiveArticleCount color:PNRed description:@"Subjective"], [PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalsubjectiveArticleCount color:PNDarkBlue description:@"Objective"]];

    self.analyzedView = [[AggregatedAnalysisView alloc] initWithFrame:CGRectZero];
    
    self.analyzedView.objectiveSubjectivePieChart = [[PNPieChart alloc] initWithFrame:CGRectZero items:subjectivityArray];
    
    self.analyzedView.tonePieChart = [[PNPieChart alloc] initWithFrame:CGRectZero items:items];

    [self.subjectivityView addSubview:self.analyzedView.objectiveSubjectivePieChart];
    [self.positivityNegativityView addSubview:self.analyzedView.tonePieChart];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.analyzedView.frame = CGRectMake(0, 0, self.subjectivityView.frame.size.width, self.subjectivityView.frame.size.height);
    self.analyzedView.objectiveSubjectivePieChart.frame = self.analyzedView.frame;
    self.analyzedView.tonePieChart.frame = self.analyzedView.frame;
}

- (IBAction)dismissButtonTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
