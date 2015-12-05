//
//  Article.m
//  Frame
//
//  Created by Jovanny Espinal on 11/13/15.
//  Copyright © 2015 Jovanny Espinal. All rights reserved.
//

#import "Article.h"

@implementation Article

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.url forKey:@"url"];
    [encoder encodeObject:self.headline forKey:@"headline"];
    [encoder encodeObject:self.imageUrl forKey:@"imageUrl"];
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.sentimentAnalysis forKey:@"sentimentAnalysis"];
    [encoder encodeObject:self.subjectivityAnalysis forKey:@"subjectivityAnalysis"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.conservative] forKey:@"conservative"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.green] forKey:@"green"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.liberal] forKey:@"liberal"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.libertarian] forKey:@"libertarian"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super init]) {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        self.headline = [aDecoder decodeObjectForKey:@"headline"];
        self.imageUrl = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.text = [aDecoder decodeObjectForKey:@"text"];
        self.sentimentAnalysis = [aDecoder decodeObjectForKey:@"sentimentAnalysis"];
        self.subjectivityAnalysis = [aDecoder decodeObjectForKey:@"subjectivityAnalysis"];
        self.conservative = [[aDecoder decodeObjectForKey:@"conservative"] floatValue];
        self.green = [[aDecoder decodeObjectForKey:@"green"] floatValue];
        self.liberal = [[aDecoder decodeObjectForKey:@"liberal"] floatValue];
        self.libertarian = [[aDecoder decodeObjectForKey:@"libertarian"] floatValue];
        return self;
    }
    return nil;
}

@end
