//
//  AnalysisViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/16/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "AnalysisViewController.h"
#import "LQNetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "PNChart.h"
#import "LQNetworkManager.h"
#import <ChameleonFramework/Chameleon.h>


@interface AnalysisViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sentimentLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectivityLabel;
@property (nonatomic) PNPieChart *pieChart;
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.articleObject.url];
    
    NSError* error = nil;
    self.articleObject.text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error: &error];
    
    void(^politicalAnalysisBlock)(Article *);
    
    politicalAnalysisBlock = ^(Article *articleObject){
        self.sentimentLabel.text = self.articleObject.sentimentAnalysis;
        self.subjectivityLabel.text = self.articleObject.subjectivityAnalysis;
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:articleObject.liberal color:FlatRed description:@"Liberal"],
                           [PNPieChartDataItem dataItemWithValue:articleObject.green color:FlatGreen description:@"Green"],
                           [PNPieChartDataItem dataItemWithValue:articleObject.conservative color:FlatSkyBlue description:@"Conservative"],
                           [PNPieChartDataItem dataItemWithValue:articleObject.libertarian color:FlatYellow description:@"Libertarian"]
                           ];
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH /2.0 - 100, 240, 240.0, 240.0) items:items];
        self.pieChart.center = self.view.center;
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir" size:11.0];
        self.pieChart.descriptionTextFont = [UIFont boldSystemFontOfSize:12.0f];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
        self.pieChart.showAbsoluteValues = NO;
        self.pieChart.showOnlyValues = NO;
        [self.pieChart strokeChart];
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked;
        self.pieChart.legendFont = [UIFont fontWithName:@"Avenir" size:12.0f];
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.pieChart.legendFontColor = [UIColor flatWhiteColor];
        
        UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
        [legend setFrame:CGRectMake(150, 470, legend.frame.size.width, legend.frame.size.height)];
        
        
        [self.view addSubview:legend];
        
        [self.view addSubview:self.pieChart];

    };
    
    
    
    //Sets API for Indico API
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    [self politicalAnalysis:self.articleObject analysis:politicalAnalysisBlock];

    
    
}

-(void)politicalAnalysis:(Article *)articleObject
                analysis:(void(^)(Article *))callback{
    //Insert text into political analysis.
    [[LQNetworkManager sharedManager] politicalAnalysis:articleObject.text completionHandler:^(NSDictionary *result, NSError *error) {
        
        NSDictionary *politicalAnalysis = result[@"results"];
        
        NSString *conservativeStringValue = politicalAnalysis[@"Conservative"];
        float conservative = [conservativeStringValue floatValue] * 100;
        
        NSString *greenStringValue = politicalAnalysis[@"Green"];
        float green = [greenStringValue floatValue] * 100;
        
        NSString *liberalStringValue = politicalAnalysis[@"Liberal"];
        float liberal = [liberalStringValue floatValue] * 100;
        
        NSString *libertarianStringValue = politicalAnalysis[@"Libertarian"];
        float libertarian = [libertarianStringValue floatValue] * 100;
        
        articleObject.conservative = conservative;
        articleObject.green = green;
        articleObject.liberal = liberal;
        articleObject.libertarian = libertarian;
        
        callback(articleObject);
        NSLog(@"%f", self.articleObject.libertarian);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissViewController:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
