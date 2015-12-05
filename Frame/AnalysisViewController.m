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
#import <WeightedWordCloud/HITWeightedWordCloud.h>


@interface AnalysisViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sentimentLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectivityLabel;
@property (nonatomic) NSMutableDictionary *wordCloudData;
@property (strong, nonatomic) IBOutlet UIImageView *wordCloudImage;
@property (nonatomic) HITWeightedWordCloud *wordCLoud;

@property (nonatomic) PNPieChart *pieChart;
@end

@implementation AnalysisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.wordCloudData = [[NSMutableDictionary alloc] init];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    void(^setWordCloud)(NSMutableDictionary *);
    
    setWordCloud = ^(NSMutableDictionary *wordCloudDictionary){
        
        self.wordCLoud = [[HITWeightedWordCloud alloc] initWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 200)];
        self.wordCLoud.textColor = [UIColor whiteColor];
        self.wordCLoud.scale = [[UIScreen mainScreen] scale];

        
        [self.wordCloudImage setImage:[self.wordCLoud imageWithWords:wordCloudDictionary]];
    };
    
    
    NSURL *url = [NSURL URLWithString:self.articleObject.url];
    
    NSError* error = nil;
    self.articleObject.text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error: &error];
    
    void(^politicalAnalysisBlock)(Article *);
    
    politicalAnalysisBlock = ^(Article *articleObject){
        
        NSArray *items = @[[PNPieChartDataItem dataItemWithValue:articleObject.liberal color:FlatRed description:@"Liberal"],
                           [PNPieChartDataItem dataItemWithValue:articleObject.green color:FlatGreen description:@"Green"],
                           [PNPieChartDataItem dataItemWithValue:articleObject.conservative color:FlatSkyBlue description:@"Conservative"],
                           [PNPieChartDataItem dataItemWithValue:articleObject.libertarian color:FlatYellow description:@"Libertarian"],
                           ];
        
        self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2.0 - 70, 380, 120.0, 120.0) items:items];
        self.pieChart.descriptionTextColor = [UIColor whiteColor];
        self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir" size:11.0];
        self.pieChart.descriptionTextFont = [UIFont boldSystemFontOfSize:12.0f];
        self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
        self.pieChart.showAbsoluteValues = NO;
        self.pieChart.showOnlyValues = YES;
        [self.pieChart strokeChart];
        
        
        self.pieChart.legendStyle = PNLegendItemStyleStacked;
        self.pieChart.legendFont = [UIFont fontWithName:@"Avenir" size:12.0f];
        self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
        self.pieChart.legendFontColor = [UIColor flatWhiteColor];
        
        UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
        [legend setFrame:CGRectMake(145, 510, legend.frame.size.width, legend.frame.size.height)];
        
        
        [self.view addSubview:legend];
        
        [self.view addSubview:self.pieChart];
        
    };
    
    void(^setLabel)(Article *);
    
    setLabel = ^(Article *articleObject){
        if (self.articleObject.sentimentAnalysis) {
            self.sentimentLabel.text = [self.articleObject.sentimentAnalysis uppercaseString];
            
        }
        
        if (self.articleObject.subjectivityAnalysis) {
            self.subjectivityLabel.text = [self.articleObject.subjectivityAnalysis uppercaseString];
        }
    };
    
    
    //Sets API for Indico API
    [[LQNetworkManager sharedManager] setApiKey:@"9b41f9a9dec46968939722b005f52be4"];
    
    self.articleObject.text = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error: &error];
    
    NSString *encodedArticleText = [self.articleObject.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    if (!(self.articleObject.sentimentAnalysis && self.articleObject.subjectivityAnalysis)){
        [self analysis:@"Sentiment" onText:encodedArticleText withManager:manager analysis:setLabel];
        [self analysis:@"Subjectivity" onText:encodedArticleText withManager:manager analysis:setLabel];
    }
    else{
        self.sentimentLabel.text = self.articleObject.sentimentAnalysis;
        self.subjectivityLabel.text = self.articleObject.subjectivityAnalysis;
    }
    [self loadWordCloud:manager intoArray:setWordCloud];
    [self politicalAnalysis:self.articleObject analysis:politicalAnalysisBlock];
    
    

}

- (void)analysis:(NSString *)typeOfAnalysisForDatumBox
          onText:(NSString *)textToAnalyze
     withManager:(AFHTTPRequestOperationManager *)manager
        analysis:(void(^)(Article *))callback {
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.datumbox.com/1.0/%@Analysis.json", typeOfAnalysisForDatumBox];
    
    [manager POST:urlString
       parameters:@{@"api_key": @"8fe3f49401d945d0ca257445a6b1abef",
                    @"text": textToAnalyze}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              NSString *result = responseObject[@"output"][@"result"];
              
              if ([typeOfAnalysisForDatumBox isEqualToString:@"Sentiment"]) {
                  self.articleObject.sentimentAnalysis = result;
              }
              
              if ([typeOfAnalysisForDatumBox isEqualToString:@"Subjectivity"]){
                  self.articleObject.subjectivityAnalysis = result;
              }
              
              callback(self.articleObject);
              
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: %@", error);
          }];
    
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
        NSLog(@"%f", articleObject.libertarian);
    }];
    
}

- (void)loadWordCloud:(AFHTTPRequestOperationManager *)manager
            intoArray:(void(^)(NSMutableDictionary *))callback{
    
    NSString* alchemyURL = @"https://gateway-a.watsonplatform.net/calls/url/URLGetRankedKeywords";
    
    [manager GET:alchemyURL
      parameters: @{@"apikey" : @"bdde6d0c11719557a37f27a1070b23990b11fc47",
                    @"url"    : self.articleObject.url,
                    @"outputMode" : @"json",
                    @"sentiment"  : @"1"
                    }
     
     
         success:^(AFHTTPRequestOperation *operation, id responseObject){
             
             NSArray *keywords = responseObject[@"keywords"];
             NSLog(@"%@", keywords);
             
             for (NSDictionary *object in keywords) {
                 NSString *keyword = object[@"text"];
                 NSString *relevance = object[@"relevance"];
                 double relevanceDouble = [relevance doubleValue] * 1000.00;
                 NSNumber *relevanceNumber = [NSNumber numberWithDouble:relevanceDouble];
                 
                 [self.wordCloudData setObject:relevanceNumber forKey:keyword];
                 
             }
             callback(self.wordCloudData);
             NSLog(@"%@", self.wordCloudData);
         }
     
         failure:^(AFHTTPRequestOperation *operation, NSError* error){
             NSLog(@"%@", error);
             NSLog(@"boo");
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
