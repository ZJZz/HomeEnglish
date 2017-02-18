//
//  PopUp.m
//  Mole It
//
//  Created by Todd Perkins on 7/29/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "PopUp.h"
#import "CCSprite+DisableTouch.h"
#import "CCMenuPopup.h"

#import "SceneTo.h"

#define ANIM_SPEED .2f

@implementation PopUp

enum tags
{
    tBG = 1,
};

+(id)popUpWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite scoreNowSt:(NSString *)scoreNowSt
{
    CCLOG(@"popup popUpWithTitle ________________");
    return [[[self alloc] initWithTitle:titleText description:description sprite:sprite scoreNowSt:scoreNowSt] autorelease];
}

-(id)initWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite scoreNowSt:(NSString *)scoreNowSt {
    self = [super init];
    if (self) {
        CCLOG(@"popup initWithTitle ________________");
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"scoreAll.plist"];        
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        CGSize s = [[CCDirector sharedDirector] winSize];
        container = sprite;
        window = [CCSprite spriteWithSpriteFrameName:@"JaugeWindow.png"];
        bg = [CCSprite node];
        bg.color = ccBLACK;
//        bg.scale = 1*scaleXY;
        bg.opacity = 0;
        [bg setTextureRect:CGRectMake(0, 0, s.width, s.height)];
        bg.anchorPoint = ccp(0,0); 
        
        //背景失去touch焦点
        [bg disableTouch];  
        
        window.position = ccp(s.width/2, s.height/2);
        window.scale = 1*scaleXY;        
      
        scoreBodySprite = [CCSprite spriteWithSpriteFrameName:@"JaugeBody0001.png"];
        scoreBodySprite.position = ccp(s.width/2-16, s.height/2+65);
        scoreBodySprite.scale = 1*scaleXY;
//        [self addChild:scoreBodySprite z:100];

        
        
        NSMutableArray *frames = [[NSMutableArray alloc] init];
        NSString *frameName;
        
        int scoreNowx = [scoreNowSt intValue];
        int scoreTempSprite;        

        CCLOG(@"scoreNow:%d",scoreNowx);
        if ( scoreNowx>=0 && scoreNowx<6) {
            scoreTempSprite = 5;
        } else {
            scoreTempSprite = scoreNowx;
        }
        
        int tempScore = scoreTempSprite -3;

        
        //动画：树叶，变化
        for (int i = 1; i < tempScore; i++) {
            frameName = [NSString stringWithFormat:@"JaugeBody%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:8.0f/24.0f];
        [scoreBodySprite runAction:[CCAnimate actionWithAnimation:a]];
        
        [frames release];
        
        int fSize = 36;
        CCLabelTTF *title = [CCLabelTTF labelWithString:titleText fontName:@"Marker Felt" fontSize:fSize];
        title.opacity = (float)255 * .25f;
        
        CCLOG(@"进入PopUp!");
        
        title.position = ccp(window.position.x, window.position.y + window.contentSize.height / 3);
        CCLabelTTF *desc = [CCLabelTTF labelWithString:description fontName:@"TOONISH" fontSize:fSize/2];
        
//        description = @"Score List";

        desc.position = ccp(title.position.x, title.position.y - title.contentSize.height);
        desc.opacity = (float)255 * .75f;
        [window addChild:title z:1];
        [window addChild:desc];
        [self addChild:scoreBodySprite z:100];

        [self addChild:bg z:-1 tag:tBG];
        [self addChild:window];
        
                
        [window addChild:container z:2];
        [bg runAction:[CCFadeTo actionWithDuration:ANIM_SPEED / 2 opacity:150]];
        [window runAction:[CCSequence actions:
                           [CCScaleTo actionWithDuration:ANIM_SPEED /2 scale:1.1*scaleXY],
                           [CCScaleTo actionWithDuration:ANIM_SPEED /2 scale:1.0*scaleXY],
                           nil]];
    }
    return self;
}

-(void)closePopUp
{
    //背景重新获得touch焦点
    CCLOG(@"popup closePopUp ________________");
    [(CCSprite *)[self getChildByTag:tBG] enableTouch];
    
    [window runAction:[CCFadeOut actionWithDuration:ANIM_SPEED]];
    [scoreBodySprite runAction:[CCFadeOut actionWithDuration:ANIM_SPEED]];
    [window runAction:[CCSequence actions:
                       [CCScaleTo actionWithDuration:ANIM_SPEED scale:1.1*scaleXY],
//                       [CCCallFunc actionWithTarget:self selector:@selector(allDone)],
                       nil]];
    [scoreBodySprite runAction:[CCSequence actions:
                       [CCScaleTo actionWithDuration:ANIM_SPEED scale:1.1*scaleXY],
                       //                       [CCCallFunc actionWithTarget:self selector:@selector(allDone)],
                       nil]];
    
}

-(void)allDone
{
    CCLOG(@"popup allDone ________________");
//    [self removeFromParentAndCleanup:YES];
    
}

//-(void)allDone:(id)sender
//{
//    [self removeFromParentAndCleanup:YES];
//}


@end
