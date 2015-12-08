//
//  AggregatedAnalysisViewController.m
//  Frame
//
//  Created by Bereket  on 11/23/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "AggregatedAnalysisViewController.h"

@interface AggregatedAnalysisViewController ()

@end

@implementation AggregatedAnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalNegativeToneCount color:PNRed description:@"Negative"],
                       [PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalPositiveToneCount color:PNBlue description:@"Positive"],
                       [PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalNeutralToneCount color:PNGreen description:@"Neutral"],
                       ];
    
    NSArray* subjectivityArray = @[[PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalsubjectiveArticleCount color:PNRed description:@"Subjective"], [PNPieChartDataItem dataItemWithValue:[SavedArticleManager sharedManager].myAccount.usersTotalBias.totalObjectiveArticleCount color:PNDarkBlue description:@"Objective"]];

    
    
    AggregatedAnalysisView* analyzedView = [[AggregatedAnalysisView alloc] initWithFrame:CGRectMake(0, 0, self.subjectivityView.frame.size.width, self.subjectivityView.frame.size.height)];
    
    
    analyzedView.objectiveSubjectivePieChart = [[PNPieChart alloc] initWithFrame:analyzedView.frame items:subjectivityArray];
    
    analyzedView.tonePieChart = [[PNPieChart alloc] initWithFrame:analyzedView.frame items:items];

    
    [self.subjectivityView addSubview:analyzedView.objectiveSubjectivePieChart];
    [self.positivityNegativityView addSubview:analyzedView.tonePieChart];

    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
