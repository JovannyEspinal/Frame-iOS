//
//  UserProfileViewController.h
//  Frame
//
//  Created by Bereket  on 11/20/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UserProfileViewController : UIViewController
<UITableViewDelegate,
UITableViewDataSource>


@property (strong, nonatomic) NSMutableArray* readArticlesOnProfile;
@property (strong, nonatomic) NSMutableArray* bookmarkedArticles;

@property (strong, nonatomic) IBOutlet UIView *FacebookLoginView;

-(void)callPocketAPI:(NSString*)articleURL;
-(void)callFacebookShareAPI:(NSString*)articleURL;

- (IBAction)biasViewButtonTapped:(id)sender;


@end
