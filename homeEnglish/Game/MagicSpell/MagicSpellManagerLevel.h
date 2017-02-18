//
//  MagicSpellManagerLevel.h
//  homeEnglish
//
//  Created by Tony Zhao on 12-11-21.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface MagicSpellManagerLevel : CCLayer
{
    int runningLevel;
}



+(void) enterNextLevel:(NSString *) fromScene;

+(int) nowLevel;

+(void)playFromStart;

@end
