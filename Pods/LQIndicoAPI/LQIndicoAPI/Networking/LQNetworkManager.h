//
//  LQNetworkManager.h
//  LQIndicoAPI
//
//  Created by LuQuan Intrepid on 6/5/15.
//  Copyright (c) 2015 Lu Quan Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LQDictionaryCompletionBlock)(NSDictionary *result, NSError *error);

@interface LQNetworkManager : NSObject

+ (instancetype)sharedManager;

/**
 *  You need to register for a free public API key at https://indico.io/register
 *  When you have created one, set the key here before hitting the endpoints
 *
 */
- (void)setApiKey:(NSString *)apiKey;

//---------------------------------------------------------------------------------------------------------------
// Text Analysis
//---------------------------------------------------------------------------------------------------------------

- (void)sentimentAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)highQualitySentimentAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)textTagsAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)languageAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)politicalAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)keywordsAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)namedEntitiesAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)twitterEnagagementAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion;

//---------------------------------------------------------------------------------------------------------------
// Image Analysis
//---------------------------------------------------------------------------------------------------------------

- (void)facialEmotionRecognitionAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)imageFeaturesAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)facialFeatureAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)facialLocalizationAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion;
- (void)contentFilteringAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion;


@end
