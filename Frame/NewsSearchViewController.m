//
//  NewsSearchViewController.m
//  Frame
//
//  Created by Jovanny Espinal on 11/18/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "NewsSearchViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "SearchResultsTableViewController.h"
#import "APLSearchBar.h"

@interface NewsSearchViewController ()  <UITextFieldDelegate>
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *trendingTermButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic) NSMutableArray *trending;

@end

@implementation NewsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextField.delegate = self;
    
    
    self.navigationController.navigationBar.topItem.title = @"Search";
    
    void(^setTrendingArray)(NSArray *);
    setTrendingArray = ^(NSArray *array){
        self.trending = [NSMutableArray arrayWithArray: array];
        [self updateUI];
    };
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    [self trendingTerms:manager addsArticle:setTrendingArray];
    
}

- (IBAction)searchTrendingTerm:(UIButton *)sender {
    self.searchTextField.text = sender.titleLabel.text;
    
    [self textFieldShouldReturn:self.searchTextField];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.searchTextField.text = @"";
}

-(void)trendingTerms:(AFHTTPRequestOperationManager *) manager
         addsArticle:(void(^)(NSArray *))completion{
    [self.trending removeAllObjects];
    NSString *farooAPIKey = @"&key=gIiv-Go-f3KJmywMTRIKExouf@s_";
    NSString *farooQuery = @"";
    
    NSString *farooURL = [NSString stringWithFormat:@"http://www.faroo.com/api?q=%@&start=1&length=10&l=en&src=trends&i=true&f=json%@", farooQuery, farooAPIKey];
    
    [manager GET:farooURL
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             NSArray *trendingTerms = [[NSArray alloc] init];
             trendingTerms = [NSArray arrayWithArray:responseObject[@"trends"]];
             
             completion(trendingTerms);
         }
         failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
             NSLog(@"%@", error);
         }];
    
}

-(void)updateUI{
    for (int i = 0; i < [self.trendingTermButton count]; i++){
        [self.trendingTermButton[i] setTitle:self.trending[i] forState:UIControlStateNormal];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self performSegueWithIdentifier:@"DisplaySearchResults" sender:self];
    [textField resignFirstResponder];
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text = @"";
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.searchTextField endEditing:YES];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     [super prepareForSegue:segue sender:sender];

     SearchResultsTableViewController *svc = [segue destinationViewController];
     svc.searchQuery = self.searchTextField.text;

 }


@end
