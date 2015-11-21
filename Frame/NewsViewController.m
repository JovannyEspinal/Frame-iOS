//
//  NewsViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/15/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "NewsViewController.h"
#import "KSGallerySlidingLayout.h"
#import "HomeNewsCell.h"
#import "AFNetworking.h"
#import "Article.h"
#import "ArticleViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFWebViewController/AFWebViewController.h>

#import "SavedArticleManager.h"

@interface NewsViewController () <KSGallerySlidingLayoutLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
        [self.collectionView reloadData];
    };
    
    [self breakingNews:manager addsArticle:setArticleArray];
    [self LayoutCollectionView];
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

#pragma MARK - UICollectionView Methods

-(void)LayoutCollectionView
{
    KSGallerySlidingLayout *layout = [[KSGallerySlidingLayout alloc] initWithDelegate:self];
    
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), HomeNewsCellCollapsedHeight);
    
    self.collectionView.collectionViewLayout = layout;
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeNewsCell" bundle:nil] forCellWithReuseIdentifier:@"HomeNewsCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self.articleObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HomeNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeNewsCell" forIndexPath:indexPath];
    
    Article *articleObject = self.articleObjects[indexPath.row];
    
    
    cell.lTitle.text = articleObject.headline;
    cell.lSubTitle.text = articleObject.url;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleObject.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.imageView.image = image;
        
        
   
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ArticleViewController* detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleViewController"];
        
        NSLog(@"%@", self.articleObjects[indexPath.row]);
        
        detailViewController.url = self.articleObjects[indexPath.row].url;
        
        //add the object to the Singleton Classes User properties array
        [SavedArticleManager.sharedManager.myAccount.savedArticleArray addObject:self.articleObjects[indexPath.row]];
        
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    
}

#pragma mark - KSGallerySlidingLayoutLayoutDelegate

- (CGFloat)heightForFeatureCell
{
    //    return RPSlidingCellFeatureHeight;
    return HomeNewsCellFeatureHeight;
}

- (CGFloat)heightForCollapsedCell
{
    //    return RPSlidingCellCollapsedHeight;
    return HomeNewsCellCollapsedHeight;
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
