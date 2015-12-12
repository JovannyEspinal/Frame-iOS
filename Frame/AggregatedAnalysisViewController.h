//
//  AggregatedAnalysisViewController.h
//  Frame
//
//  Created by Bereket  on 11/23/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNChart/PNChart.h>
#import "SavedArticleManager.h"
#import "AggregatedAnalysisView.h"

@interface AggregatedAnalysisViewController : UIViewController


@property (strong, nonatomic) IBOutlet UILabel *subjectivityLabel;


@property (strong, nonatomic) IBOutlet UILabel *positivityNegativityLabel;

@property (strong, nonatomic) IBOutlet UIView *subjectivityView;

@property (strong, nonatomic) IBOutlet UIView *positivityNegativityView;

- (IBAction)dismissButtonTapped:(id)sender;

@end
