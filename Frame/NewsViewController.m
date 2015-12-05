//
//  NewsViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/15/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "AFNetworking.h"
#import "Article.h"
#import "ArticleViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFWebViewController/AFWebViewController.h>
#import "AnalysisViewController.h"
#import "SavedArticleManager.h"
#import <ChameleonFramework/Chameleon.h>

@interface NewsViewController ()
@property (strong, nonatomic) NSMutableArray<Article *> *articleObjects;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.navigationController.navigationBar.topItem.title = @"Trending News";
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont fontWithName:@"Rockwell-Bold" size:20.0f]}];
    
    self.articleObjects = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [[SDWebImageDownloader sharedDownloader] setMaxConcurrentDownloads:6];
    
    void(^setArticleArray)(NSMutableArray *);
    
    setArticleArray = ^(NSMutableArray *array){
        
        self.articleObjects = array;
        [self.tableView reloadData];
    };
    
    [self breakingNews:manager addsArticle:setArticleArray];
    [self LayoutTableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}

-(void)breakingNews:(AFHTTPRequestOperationManager *)manager
        addsArticle:(void(^)(NSMutableArray *))callback
{
    //Clears old article objects; will be replaced with newest articles
    [self.articleObjects removeAllObjects];
    
    //Creates an array to hold articles from API
    NSMutableArray *articlesFromAPI = [[NSMutableArray alloc] init];
    
    NSString *farooAPIKey = @"&key=gIiv-Go-f3KJmywMTRIKExouf@s_";
    NSString *farooQuery = @"";
    
    NSString *farooURL = [NSString stringWithFormat:@"http://www.faroo.com/api?q=%@&start=1&length=10&l=en&src=news&i=true&f=json%@", farooQuery, farooAPIKey];
    
    [manager GET:farooURL
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             NSArray *results = responseObject[@"results"];
             
             for (NSDictionary *articleData in results){
                 NSString *title = articleData[@"title"];
                 NSString *articleUrl = articleData[@"url"];
                 NSString *articleImageUrl = articleData[@"iurl"];
                 
                 if (articleUrl) {
                     Article *articleObject = [[Article alloc] init];
                     articleObject.headline = title;
                     articleObject.url = articleUrl;
                     articleObject.imageUrl = articleImageUrl;
                     
                     [articlesFromAPI addObject:articleObject];
                 }
             }
             callback(articlesFromAPI);
             
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
         }];
    
}



#pragma MARK - UITableView Methods

-(void)LayoutTableView
{
    self.cellZoomInitialAlpha = [NSNumber numberWithFloat:0.1];
    self.cellZoomAnimationDuration = [NSNumber numberWithFloat:0.3];
    self.cellZoomXScaleFactor = [NSNumber numberWithFloat:1.3];
    self.cellZoomYScaleFactor = [NSNumber numberWithFloat:1.3];
    self.cellZoomXOffset = [NSNumber numberWithFloat:-75];
    self.cellZoomYOffset = [NSNumber numberWithFloat:75];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 202.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.articleObjects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    Article *articleObject = self.articleObjects[indexPath.row];
    
    
    cell.headline.text = articleObject.headline;
    
    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:articleObject.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.articleImage.image = image;
    }];
    
    cell.leftButtons = @[[MGSwipeButton buttonWithTitle:@"Analysis" backgroundColor:[UIColor flatYellowColorDark] callback:^BOOL(MGSwipeTableCell *sender) {
        NSLog(@"%@", cell.headline.text);
        
        AnalysisViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AnalysisViewController"];
        avc.articleObject = self.articleObjects[indexPath.row];
        
        [self presentViewController:avc animated:YES completion:nil];
        
        return true;
    }]];
    
    cell.leftSwipeSettings.transition = MGSwipeTransitionBorder;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
    
    NSLog(@"%@", self.articleObjects[indexPath.row]);
    
    detailViewController.detailArticle = self.articleObjects[indexPath.row];
    //add the object to the Singleton Classes User properties array
    [SavedArticleManager.sharedManager.myAccount.savedArticleArray addObject:self.articleObjects[indexPath.row]];
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}



@end
