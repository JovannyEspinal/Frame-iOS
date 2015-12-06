//
//  UserProfileViewController.m
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "UserProfileViewController.h"
#import "SavedArticleManager.h"
#import "ReadArticlesTableViewCell.h"
#import "NewsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AnalysisViewController.h"
#import "DetailReadArticlesViewController.h"
#import <KOPopupView/KOPopupView.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AFNetworking/AFNetworking.h>
#import <KOPopupView/KOPopupView.h>
#import <PNChart/PNChart.h>
#import "AggregatedAnalysisView.h"
#import <PocketAPI/PocketAPI.h>
#import <ChameleonFramework/Chameleon.h>
#import <CoreData/CoreData.h>
#import <SIAlertView/SIAlertView.h>
#import <QuartzCore/QuartzCore.h>

// fartbook
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


//kk


@interface UserProfileViewController ()

//Buttons
@property (nonatomic) UIButton* dismissButtonTapped;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *viewBiasButton;

//On the view
@property (nonatomic, strong) KOPopupView *popup;
@property (nonatomic, strong) UIView* aggregateAnalysisView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *readArticlesArray;

@end

@implementation UserProfileViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //change font of 'clear' button
    [self.clearButton setTitleTextAttributes:@{
                                               NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:15],
                                               NSForegroundColorAttributeName: [UIColor whiteColor]
                                               } forState:UIControlStateNormal];
    
//    [[self.viewBiasButton layer] setBorderColor:[UIColor whiteColor].CGColor];
//    [[self.viewBiasButton layer] setBorderWidth:1.0f];
    
    
    [[PocketAPI sharedAPI] setURLScheme:@"pocketapp48589"];
    [[PocketAPI sharedAPI] setConsumerKey:@"48589-8599c7f45f7317f60c1964bf"];
    
    self.aggregateAnalysisView  = [[KOPopupView alloc] initWithFrame:CGRectMake(0, -400, 500, 400)];
    self.aggregateAnalysisView.backgroundColor = [UIColor redColor];
    self.aggregateAnalysisView.alpha = 0.7;
    
    self.navigationController.navigationBar.topItem.title = @"History";
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReadArticleIdentifier"];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [SavedArticleManager sharedManager].myAccount.savedArticleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Cell below inherits from MGSwipeTableCell
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadArticleIdentifier" forIndexPath:indexPath];
    
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    
    
    Article *article = [SavedArticleManager sharedManager].myAccount.savedArticleArray[indexPath.row];
    
  
    cell.textLabel.text = article.headline;
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    

    //------------------------------------------------------------------------------------------------------
    //call back block to save to Pocket below
    
    MGSwipeButton *pocketButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"pocket"]  backgroundColor:[UIColor flatRedColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        [self callPocketAPI:article.url];
        
        return true;
    }];
    
    
    //------------------------------------------------------------------------------------------------------
    
    //initialize Pocket and FB buttons with MGSWipe Cocoapod Class
    cell.rightButtons = @[pocketButton,
                          [MGSwipeButton buttonWithTitle:@"Share" backgroundColor:rgb(59, 89, 152)]];
   
    
//------------------------------------------------------------------------------------------------------
//call back block to analyze articles below

    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Analysis" backgroundColor:[UIColor flatYellowColorDark] callback:^BOOL(MGSwipeTableCell *sender) {
        //NSLog(@"%@", cell.headline.text);
    
        
        AnalysisViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalysisViewController"];
        avc.articleObject = article;
        
        [self presentViewController:avc animated:YES completion:nil];
        
        return true;
    }]];
    
    
    FBSDKShareButton *fbButton = [[FBSDKShareButton alloc] init];
    fbButton.hidden = TRUE;
    
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:article.url];

    MGSwipeButton *shareButton = [MGSwipeButton buttonWithTitle:@"" icon:[UIImage imageNamed:@"facebook"] backgroundColor:[UIColor flatSkyBlueColor] callback:^BOOL(MGSwipeTableCell *sender) {
    
        [fbButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
        return true;
    }];
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    
    
 
 
    
    
    fbButton.shareContent = content;
    
       // fbButton.frame = shareButton.bounds;
    fbButton.frame = CGRectMake(10, 10, shareButton.frame.size.width, shareButton.frame.size.height);
//    shareButton.center =  [cell.rightButtons[0] center];
    
    [shareButton addSubview:fbButton];
    
    cell.rightButtons = @[pocketButton, shareButton];

    return cell;
}

-(void)callPocketAPI:(NSString *)articleURL{
    
    NSURL *url = [NSURL URLWithString:articleURL];
    [[PocketAPI sharedAPI] saveURL:url handler: ^(PocketAPI *API, NSURL *URL, NSError *error){
        if(error){
            NSLog(@"Cant connect homie");
            
        }else{
            SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Saved!" andMessage:@"Your article has been saved to Pocket for offline reading."];
            
            [alertView addButtonWithTitle:@"OK"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                  }];
            
            alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
            
            [alertView show];
        }
        
    }];
}

-(void)callFacebookShareAPI:(NSString *)articleURL {
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:articleURL];
    
    FBSDKShareButton *shareButton = [[FBSDKShareButton alloc] init];
    shareButton.shareContent = content;
    shareButton.center = self.view.center;
    [self.view addSubview:shareButton];
    

}

- (IBAction)biasViewButtonTapped:(id)sender {
    
    if(!self.popup)
        self.popup = [KOPopupView popupView];
   
    
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:10 color:PNRed description:@"Negative"],
                       [PNPieChartDataItem dataItemWithValue:20 color:PNBlue description:@"Positive"],
                       [PNPieChartDataItem dataItemWithValue:40 color:PNGreen description:@"Neutral"],
                       ];

    
    AggregatedAnalysisView* analyzedView = [[AggregatedAnalysisView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, self.view.frame.size.height - 40)];
    analyzedView.backgroundColor = [UIColor blackColor];
    
    CGFloat width = (self.view.frame.size.width - 40) / 2.0;
    CGSize frameSize = CGSizeMake(width, width);
    
    CGRect toneFrame = CGRectMake(0, analyzedView.center.y, frameSize.width, frameSize.height);
    analyzedView.tonePieChart = [[PNPieChart alloc] initWithFrame:toneFrame items:items];
    
    CGRect objectiveFrame = CGRectMake(width, analyzedView.center.y, frameSize.width, frameSize.height);
    analyzedView.objectiveSubjectivePieChart = [[PNPieChart alloc] initWithFrame:objectiveFrame items:@[items[0], items[1]]];
    
    
    analyzedView.dismissViewButton = [[UIButton alloc] initWithFrame:CGRectMake(250,100,50, 50)];
    
    [self.popup.handleView addSubview:analyzedView];
    self.dismissButtonTapped.titleLabel.text = @"Dismiss";
    self.dismissButtonTapped.titleLabel.backgroundColor = [UIColor redColor];
    
    
    [analyzedView addSubview:analyzedView.tonePieChart];
    [analyzedView addSubview:analyzedView.objectiveSubjectivePieChart];
    [analyzedView addSubview:analyzedView.dismissViewButton];
    
    analyzedView.center = self.popup.handleView.center;
    analyzedView.dismissViewButton.backgroundColor = [UIColor whiteColor];
   
    //adds a target to (void)dismissPopup
    [analyzedView.dismissViewButton addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    [self.popup show];
    
}

- (void)dismissPopup {
    [self.popup hideAnimated:YES];
}

- (IBAction)clearHistoryButtonTapped:(UIBarButtonItem *)sender {
    
    [[SavedArticleManager sharedManager].myAccount.savedArticleArray removeAllObjects];
    [SavedArticleManager.sharedManager persistArticles];
    [self.tableView reloadData];
    
}






@end
