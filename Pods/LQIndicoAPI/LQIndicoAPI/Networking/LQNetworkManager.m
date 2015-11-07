//
//  LQNetworkManager.m
//  LQIndicoAPI
//
//  Created by LuQuan Intrepid on 6/5/15.
//  Copyright (c) 2015 Lu Quan Tan. All rights reserved.
//

#import "LQNetworkManager.h"
#import "AFNetworking/AFNetworking.h"
#import "LQIndicoEndpoints.h"
#import "UIImage+LQ.h"

@interface LQNetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) NSString *apiKey;
@end

@implementation LQNetworkManager

+ (instancetype)sharedManager {
    static LQNetworkManager *shared = nil;
    static dispatch_once_t singleToken;
    dispatch_once(&singleToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (instancetype)init {
    self = [super init];;
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kIndicoEndpointBaseURL]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        //Indico API response content-type is text/html
        [_manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html", nil]];
        _apiKey = nil;
    }
    return self;
}

- (NSString *)apiKey {
    if (!_apiKey) {
        NSAssert(NO, @"You need to register for a free public API key at https://indico.io/register");
    }
    return _apiKey;
}

#pragma mark - Requests

//---------------------------------------------------------------------------------------------------------------
// Text Analysis
//---------------------------------------------------------------------------------------------------------------

- (void)sentimentAnalysis:(NSString *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoSentiment]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)highQualitySentimentAnalysis:(NSArray *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoSentimenHighQuality]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];

}

- (void)textTagsAnalysis:(NSArray *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoTextTags]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)languageAnalysis:(NSArray *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoLanguage]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)politicalAnalysis:(NSArray *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoPolitical]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];

}

- (void)keywordsAnalysis:(NSArray *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoKeywords]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)namedEntitiesAnalysis:(NSArray *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoNamedEntities]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)twitterEnagagementAnalysis:(NSArray *)text completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : text};
    [self.manager POST:[self urlStringFor:kIndicoTwitterEngagement]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

//---------------------------------------------------------------------------------------------------------------
// Image Analysis
//---------------------------------------------------------------------------------------------------------------

- (void)facialEmotionRecognitionAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : [image base64Encoding]};
    [self.manager POST:[self urlStringFor:kIndicoFacialEmotionRecognition]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)imageFeaturesAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion{
    NSDictionary *data = @{@"data" : [image base64Encoding]};
    [self.manager POST:[self urlStringFor:kIndicoImageFeatures]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)facialFeatureAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion {
    NSDictionary *data = @{@"data" : [image base64Encoding]};
    [self.manager POST:[self urlStringFor:kIndicoFacialFeatures]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)facialLocalizationAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion{
    NSDictionary *data = @{@"data" : [image base64Encoding]};
    [self.manager POST:[self urlStringFor:kIndicoFacialLocalization]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

- (void)contentFilteringAnalysis:(UIImage *)image completionHandler:(LQDictionaryCompletionBlock)completion{
    NSDictionary *data = @{@"data" : [image base64Encoding]};
    [self.manager POST:[self urlStringFor:kIndicoContentFiltering]
            parameters:data
               success:^(NSURLSessionDataTask *task, id responseObject) {
                   if (completion) {
                       completion(responseObject, nil);
                   }
               }
               failure:^(NSURLSessionDataTask *task, NSError *error) {
                   if (completion) {
                       completion(nil, error);
                   }
               }];
}

#pragma mark - Helper

- (NSString *)urlStringFor:(NSString *)api {
    return [NSString stringWithFormat:@"%@key=%@", api, self.apiKey];
}

@end
