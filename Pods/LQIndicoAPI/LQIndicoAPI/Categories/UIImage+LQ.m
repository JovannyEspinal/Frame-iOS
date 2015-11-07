//
//  UIImage+LQ.m
//  LQIndicoAPI
//
//  Created by LuQuan Intrepid on 8/14/15.
//  Copyright (c) 2015 Lu Quan Tan. All rights reserved.
//

#import "UIImage+LQ.h"

@implementation UIImage (LQ)

- (NSString *)base64Encoding {
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0f);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

@end
