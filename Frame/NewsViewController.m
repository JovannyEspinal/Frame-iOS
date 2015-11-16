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
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsViewController () <KSGallerySlidingLayoutLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray<Article *> *articleObjects;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    self.articleObjects = [[NSMutableArray alloc] init];
    
    [self breakingNews:manager intoArray:self.articleObjects];
    
    KSGallerySlidingLayout *layout = [[KSGallerySlidingLayout alloc] initWithDelegate:self];
    
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame), HomeNewsCellCollapsedHeight);
    
    self.collectionView.collectionViewLayout = layout;
    
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeNewsCell" bundle:nil] forCellWithReuseIdentifier:@"HomeNewsCell"];
    
    
    
}

-(void)breakingNews:(AFHTTPRequestOperationManager *)manager intoArray:(NSMutableArray *)articleObjects{
    [self.articleObjects removeAllObjects];
    [manager GET:@"https://www.reddit.com/r/worldnews/new.json" parameters:nil success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSDictionary *data = responseObject[@"data"];
        NSArray *submission = data[@"children"];
        
        for (NSDictionary *submissionData in submission){
            NSString *headline = submissionData[@"data"][@"title"];
            NSString *url = submissionData[@"data"][@"url"];
            
            Article *articleObject = [[Article alloc] init];
            
            articleObject.content = headline;
            articleObject.url = url;
            
            [articleObjects addObject:articleObject];
            
        }
        
        for (int i = 0; i < [self.articleObjects count]; i++) {
            [self extractImages:manager fromURLInObject:self.articleObjects[i]];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"FAILED.");
    }];
    
    
}

-(void)extractImages:(AFHTTPRequestOperationManager *)manager fromURLInObject:(Article *)articleObject{
    
    [manager GET:@"http://api.diffbot.com/v3/article"
      parameters:@{@"token": @"fcbd17950b98e6d4138a9de24c642347",
                   @"url": articleObject.url}
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             NSArray *data = responseObject[@"objects"];
             NSDictionary *images = [[data firstObject][@"images"] firstObject];
             
             NSString *imageUrl = images[@"url"];
             
             if (imageUrl) {
                 articleObject.imageUrl = imageUrl;
             }
             
             
             [self.collectionView reloadData];
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NSLog(@"Failed.");
         }];
    
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.articleObjects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HomeNewsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HomeNewsCell" forIndexPath:indexPath];
    
     Article *articleObject = self.articleObjects[indexPath.row];
    
        cell.lTitle.text = articleObject.content;
        cell.lSubTitle.text = articleObject.url;
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:articleObject.imageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.imageView.image = image;
    }];
        
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
