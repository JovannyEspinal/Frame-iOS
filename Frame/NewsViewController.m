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

#import "SavedArticleManager.h"

@interface NewsViewController () 
@property (strong, nonatomic) NSMutableArray<Article *> *articleObjects;

@end

@implementation NewsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
    
    NSLog(@"%@", self.articleObjects[indexPath.row]);
    
    detailViewController.url = self.articleObjects[indexPath.row].url;
    
    //add the object to the Singleton Classes User properties array
    [SavedArticleManager.sharedManager.myAccount.savedArticleArray addObject:self.articleObjects[indexPath.row]];
    
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}



#pragma mark - Navigation

/*
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end