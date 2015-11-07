//
//  LQIndicoEndpoints.h
//  LQIndicoAPI
//
//  Created by LuQuan Intrepid on 6/5/15.
//  Copyright (c) 2015 Lu Quan Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const kIndicoEndpointBaseURL = @"https://apiv2.indico.io/";

// For more information on these APIs provided by Indico, visit https://docs.indico.io/v2.0/docs

//---------------------------------------------------------------------------------------------------------------
// Text Analysis
//---------------------------------------------------------------------------------------------------------------

/**
 *  Determine if the overall sentiment in the text is positive or negative
 *
 */
static NSString * const kIndicoSentiment = @"sentiment?";

/**
 *  Determine if the overall sentiment in the text is positive or negative(high quality)
 *
 */
static NSString * const kIndicoSentimenHighQuality = @"sentimenthq?";

/**
 *  Tag unstructured text with topics from a wide range of topics
 *  For the full list of topics, visit https://docs.indico.io/v2.0/docs/text-tags
 */
static NSString * const kIndicoTextTags = @"texttags?";

/**
 *  Predict the language of a given piece of text
 *  For the full list of languages, visit https://docs.indico.io/v2.0/docs/language-1
 */
static NSString * const kIndicoLanguage = @"language?";

/**
 *  Predict the political alignment of a given piece of text
 *  The political groups included are Conservative, Greem, Liberal and Libertarian
 */
static NSString * const kIndicoPolitical = @"political?";

/**
 *  Extract important words from the text
 *
 */
static NSString * const kIndicoKeywords = @"keywords?";

/**
 *  Identify the names of people, places, and organizations in a phrase or document
 *
 */
static NSString * const kIndicoNamedEntities = @"namedentitites?";

/**
 *  Predict twitter audience engagement for a given tweet
 *
 */
static NSString * const kIndicoTwitterEngagement = @"twitterengagement?";

//---------------------------------------------------------------------------------------------------------------
// Image Analysis
//---------------------------------------------------------------------------------------------------------------

/**
 *  Extract the emotions from an image of a face
 *  The emotions included are: Angry, Sad, Neutral, Surprise, Fear, Happy
 */
static NSString * const kIndicoFacialEmotionRecognition = @"fer?";

/**
 *  Convert images from pixel arrrays to meaningful feature vectors
 *
 */
static NSString * const kIndicoImageFeatures = @"imagefeatures?";

/**
 *  Convert images of faces from pixel arrays to meaningful feature vectors
 *
 */
static NSString * const kIndicoFacialFeatures = @"facialfeatures?";

/**
 *  Returns a list of face bounding boxes founds for a given image
 *
 */
static NSString * const kIndicoFacialLocalization = @"faciallocalization";

/**
 *  Determines whether or not an image contains mature content
 *
 */
static NSString * const kIndicoContentFiltering = @"contentfiltering";
