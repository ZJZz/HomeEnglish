//
//  LevelWord.h
//  homeEnglish
//
//  Created by zhao david on 13-6-9.
//  Copyright 2013年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface LevelWord : CCLayer {
    
}

+(CCScene *) sceneWithWord:(NSString *) wordPath Level:(NSString *) l;

@end
