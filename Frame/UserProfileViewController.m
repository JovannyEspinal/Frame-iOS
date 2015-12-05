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
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <KOPopupView/KOPopupView.h>
#import <PNChart/PNChart.h>
#import "AggregatedAnalysisView.h"
#import <PocketAPI/PocketAPI.h>
#import <ChameleonFramework/Chameleon.h>
#import <CoreData/CoreData.h>

//kk


@interface UserProfileViewController ()


@property (nonatomic) UIButton* dismissButtonTapped;

@property (nonatomic, strong) KOPopupView *popup;
@property (nonatomic, strong) UIView* aggregateAnalysisView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *readArticlesArray;

@end

@implementation UserProfileViewController






- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[PocketAPI sharedAPI] setURLScheme:@"pocketapp48589"];
  
    [[PocketAPI sharedAPI] setConsumerKey:@"48589-8599c7f45f7317f60c1964bf"];

    
    
    self.aggregateAnalysisView  = [[KOPopupView alloc] initWithFrame:CGRectMake(0, -400, 500, 400)];
    self.aggregateAnalysisView.backgroundColor = [UIColor redColor];
    self.aggregateAnalysisView.alpha = 0.7;
    
    self.navigationController.navigationBar.topItem.title = @"Profile";
    
    
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
    
    
//
//    
//    NSManagedObject *readArticle = [self.readArticlesArray objectAtIndex:indexPath.row];
//    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [readArticle valueForKey:@"headline"]]];
//    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:15];
//    cell.textLabel.textColor = [UIColor whiteColor];
    
//    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        cell.articleImage.image = image;
//    }];

    //------------------------------------------------------------------------------------------------------
    //call back block to save to Pocket below
    
    MGSwipeButton *pocketButton = [MGSwipeButton buttonWithTitle:@"Pocket" backgroundColor:[UIColor flatRedColorDark] callback:^BOOL(MGSwipeTableCell *sender) {
        
        
    

        
        [self callPocketAPI:article.url];
        
        return true;
    }];
    
    
    //------------------------------------------------------------------------------------------------------
    
    //initialize Pocket and FB buttons with MGSWipe Cocoapod Class
    cell.rightButtons = @[pocketButton,
                          [MGSwipeButton buttonWithTitle:@"Share" backgroundColor:[UIColor flatOrangeColor]]];
   
    
//------------------------------------------------------------------------------------------------------
//call back block to analyze articles below

    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Analysis" backgroundColor:[UIColor flatYellowColorDark] callback:^BOOL(MGSwipeTableCell *sender) {
        //NSLog(@"%@", cell.headline.text);
        
        AnalysisViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalysisViewController"];
        avc.articleObject = article;
        
        [self presentViewController:avc animated:YES completion:nil];
        
        return true;
    }]];
 

//call back block to share articles on Facebook below
    
    [MGSwipeButton buttonWithTitle:@"Share" backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        [self callFacebookShareAPI:article.url];
        
        return true;
    }];
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    

    
    return cell;
}

    
    




-(void)callPocketAPI:(NSString *)articleURL{
    
    NSURL *url = [NSURL URLWithString:articleURL];
    [[PocketAPI sharedAPI] saveURL:url handler: ^(PocketAPI *API, NSURL *URL, NSError *error){
        if(error){
            NSLog(@"Cant connect homie");
            
        }else{
            NSLog(@"We did it!");
        }
    }];

    
    
    
//    [[PocketAPI sharedAPI] loginWithHandler: ^(PocketAPI *API, NSError *error){
//        if (error != nil)
//        {
//            NSLog(@"Yo its cool man but you messed up");
//        }
//        else
//        {
//            NSLog(@"Good job!");
//        }
//    }];
    
}








-(void)callFacebookShareAPI:(NSString *)articleURL {
    

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










//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 202.0;
//}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */




 #pragma mark - Navigation

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    
//}

 // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     
//
//   }
// 


@end
