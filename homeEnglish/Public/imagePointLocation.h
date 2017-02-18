//
//  imagePointLocation.h
//  homeEnglish
//
//  Created by david zhao on 12-4-11.
//  Copyright (c) 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface imagePointLocation : NSObject{
    
}

+ (int) getPixelColorAtLocation:(CGPoint)point secondX:(NSString *) imageMaskName;
+ (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef)inImage;
@end
