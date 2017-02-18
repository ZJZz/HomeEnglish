//
//  MagicSpellManagerLevel.m
//  homeEnglish
//
//  Created by Tony Zhao on 12-11-21.
//  Copyright 2012年 itech. All rights reserved.
//

#import "MagicSpellManagerLevel.h"
#import "MagicSpellLayer.h"


@implementation MagicSpellManagerLevel

int nowLevel = 1;


+(void) enterNextLevel:(NSString *) fromScene
{
    if (nowLevel<7) {
        nowLevel++;
    } else {
        nowLevel = 6;
    }
    
    if(nowLevel<7)
    {
//      [[CCDirector sharedDirector]replaceScene:[MagicSpellLayer scene]];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MagicSpellLayer sceneWithGround:fromScene] withColor:ccBLACK]];
    }
    else if (nowLevel==7)
    {
        //处理玩完
    }
}

+(int) nowLevel
{
    return nowLevel;
}

@end
