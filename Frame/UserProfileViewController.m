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



@interface UserProfileViewController ()

@property (nonatomic, strong) KOPopupView *popup;
@property (nonatomic, strong) UIView* aggregateAnalysisView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.topItem.title = @"Profile";
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReadArticleIdentifier"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    Article *article = [SavedArticleManager sharedManager].myAccount.savedArticleArray[indexPath.row];
    cell.textLabel.text = article.headline;
    
//    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        cell.articleImage.image = image;
//    }];

    
    
    
    //initialize Pocket and FB buttons with MGSWipe Cocoapod Class
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Pocket" backgroundColor:[UIColor redColor]],
                          [MGSwipeButton buttonWithTitle:@"Share" backgroundColor:[UIColor lightGrayColor]]];
   
    
    //------------------------------------------------------------------------------------------------------
    //call back block to analyze articles below

    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Analysis" backgroundColor:[UIColor blackColor] callback:^BOOL(MGSwipeTableCell *sender) {
        //NSLog(@"%@", cell.headline.text);
        
        AnalysisViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalysisViewController"];
        avc.articleObject = article;
        
        [self presentViewController:avc animated:YES completion:nil];
        
        return true;
    }]];
 
    
    //------------------------------------------------------------------------------------------------------
    //call back block to save to Pocket below
    
    [MGSwipeButton buttonWithTitle:@"Pocket" backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        [self callPocketAPI:article.url];
        
        return true;
    }];
  
    
    //------------------------------------------------------------------------------------------------------
    //call back block to share articles on Facebook below
    
    [MGSwipeButton buttonWithTitle:@"Share" backgroundColor:[UIColor lightGrayColor] callback:^BOOL(MGSwipeTableCell *sender) {
        
        [self callFacebookShareAPI:article.url];
        
        return true;
    }];
    
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    return cell;
}

    
    




-(void)callPocketAPI:(NSString *)articleURL{
    
    
       NSString* textToAnalyze;
       NSString* APIKey = [NSString stringWithFormat:@"48589-8599c7f45f7317f60c1964bf"];
       NSString* pocketURL = @"https://getpocket.com/v3/add";
    
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
        [manager GET:pocketURL
          parameters: @{@"APIKey" : @"bdde6d0c11719557a37f27a1070b23990b11fc47",
                        @"url"    :  articleURL,
                        @"outputMode" : @"json",
                    
                        }
    
    
             success:^(AFHTTPRequestOperation *operation, id responseObject){
                 NSLog(@"%@",[responseObject description]);
             }
    
             failure:^(AFHTTPRequestOperation *operation, NSError* error){
                 NSLog(@"%@", error);
                 NSLog(@"boo");
             }];

    
}








-(void)callFacebookShareAPI:(NSString *)articleURL {
    
    
    
    
    
    
}

- (IBAction)biasViewButtonTapped:(id)sender {
    
    if(!self.popup)
        self.popup = [KOPopupView popupView];
    [self.popup.handleView addSubview:self.aggregateAnalysisView];
    self.aggregateAnalysisView.center = CGPointMake(self.popup.handleView.frame.size.width/1.5,
                                        self.popup.handleView.frame.size.height/1.5);
    [self.popup show];
    
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
