//
//  SearchResultsTableViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/22/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "NewsTableViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Article.h"

@interface SearchResultsTableViewController ()
@property (nonatomic) NSMutableArray *searchResultObjects;

@end

@implementation SearchResultsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResultObjects = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    
    self.navigationController.navigationBar.topItem.title = @"Search Results";
    
    [[SDWebImageDownloader sharedDownloader] setMaxConcurrentDownloads:6];
    
    //    self.tableView.estimatedRowHeight = 202.0;
    //    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    void(^setArticleArray)(NSMutableArray *);
    
    setArticleArray = ^(NSMutableArray *array){
        self.searchResultObjects = array;
        [self.tableView reloadData];
    };
    
    [self breakingNews:manager searchQuery:self.searchQuery addsArticle:setArticleArray];
    [self LayoutTableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ArticleTableViewCell" bundle:nil] forCellReuseIdentifier:@"NewsCell"];
}

-(void)breakingNews:(AFHTTPRequestOperationManager *)manager
        searchQuery:(NSString *)query
        addsArticle:(void(^)(NSMutableArray *))callback
{
    //Clears old article objects; will be replaced with newest articles
    [self.searchResultObjects removeAllObjects];
    
    //Creates an array to hold articles from API
    NSMutableArray *articlesFromAPI = [[NSMutableArray alloc] init];
    
    NSString *farooAPIKey = @"&key=gIiv-Go-f3KJmywMTRIKExouf@s_";
    NSString *farooQuery = [query stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *farooURL = [NSString stringWithFormat:@"http://www.faroo.com/api?q=%@&start=1&length=10&l=en&src=news&i=true&f=json%@", farooQuery, farooAPIKey];

    
    [manager GET:farooURL
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             NSLog(@"%@", responseObject);
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
    return [self.searchResultObjects count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    
    Article *articleObject = self.searchResultObjects[indexPath.row];
    
    
    cell.headline.text = articleObject.headline;
    
    [cell.articleImage sd_setImageWithURL:[NSURL URLWithString:articleObject.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.articleImage.image = image;
    }];
    
    return cell;
}
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
