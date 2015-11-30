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




@interface UserProfileViewController ()


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
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReadArticleIdentifier" forIndexPath:indexPath];
    
  //  cell.delegate = self;
    
    Article *article = [SavedArticleManager sharedManager].myAccount.savedArticleArray[indexPath.row];
    cell.textLabel.text = article.headline;
    
//    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:article.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        cell.articleImage.image = image;
//    }];

    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Pocket" backgroundColor:[UIColor redColor]],
                          [MGSwipeButton buttonWithTitle:@"Share" backgroundColor:[UIColor lightGrayColor]]];
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Analysis" backgroundColor:[UIColor blackColor] callback:^BOOL(MGSwipeTableCell *sender) {
        //NSLog(@"%@", cell.headline.text);
        
        AnalysisViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalysisViewController"];
        avc.articleObject = article;
        
        [self presentViewController:avc animated:YES completion:nil];
        
        return true;
    }]];

    
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    return cell;
}


//-(BOOL) swipeTableCell:(MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion{
//    
//    //delegate method for which button is tapped
//    
//    
//    if(PocketButtonTapped){
//        
//        call Pocket API
//    }
//    
//    else if (ShareButtonTapped){
//        call fb API
//    }
//    
//    
//    
//    return true;
//}
//
//
//
//
//-(void)callFBShareAPI{
//    
//    
//}
//
//
//-(void)CallPocketShareAPI{
//    
//}
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
