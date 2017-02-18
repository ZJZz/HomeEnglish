//
//  MenuInstantiateAppDelegate.h
//  MenuInstantiate
//
//  Created by chen hua on 10/28/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "InterfaceManager.h"
#import "CCMenuPopup.h"
#import "PopUp.h"
#import "LevelGame.h"
#import "SceneTo.h"
#import "SimpleAudioEngine.h"
 
@implementation InterfaceManager
static int nowlevel = 1;
static int nowgame  = 1;//现在在第几个场景(一共7个游戏场景)
static int countForNowGAME=0;//这关游戏有几个不同点
static NSString *gameBackground;//这关游戏的背景图
static int allCount=0;
static CCLayer *_fatherLayer;

#pragma mark --------------一共七个场景分别进入七个 找不同 -------------

+(void) goDiffGame:(NSString * ) flag{
    [self goLevel:1];
}


//这关总点击数
+(void) allCountUp{
    allCount++;
}

//这关总点击数
+(int) allCount{
    return allCount;
}

+(int)countForNowGame{
    return countForNowGAME;
}
//标志这关有几个不同
+(NSString *) gameBackground{
    return  gameBackground;
}
//现在第几关
+(int) nowLevel{
    return nowlevel;
}
//现在第几个场景的游戏
+(int) nowGame{
    return nowgame;
}
//跳转到第几关
+( void ) goLevel: ( short ) level
{
    //循环玩这游戏
    if (level > 7) {
        level =7;
    }
    //设置当前Game的各个关所需要的不同个数
    nowlevel = level;
    CCLayer *layer;
    if (level < 4) {
        countForNowGAME=3;
    }else
        countForNowGAME=4;
    
    
    layer = [ LevelGame node ];
    [ InterfaceManager go: layer ];
}

+( void ) goAbout
{
//	CCLayer *layer = [ About node ];
//	[ InterfaceManager go: layer ];
}

+( void ) goMainMenu
{
    CCLOG(@"回到菜单！！！");
	CCLayer *layer = [ hGardenLayer node ];
	[ InterfaceManager go: layer ];
    nowlevel =1;
}

+( void ) goBack
{
	CCLayer *layer = [ hGardenLayer node ];
    CCLOG(@"goback---------------");
	[ InterfaceManager go: layer ];
}

+( void ) go:( CCLayer * )layer
{
	CCDirector *director = [ CCDirector sharedDirector ];
	CCScene *newScene = [ InterfaceManager wrap:layer ];
	if ( [ director runningScene ]) {
//		[ director replaceScene:newScene ];
        [director replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:newScene withColor:ccBLACK]];

	}else {
        [director replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:newScene withColor:ccBLACK]];

//		[ director runWithScene:newScene ];
	}
}

+( CCScene * ) wrap: ( CCLayer * ) layer
{
	CCScene *newScene = [ CCScene node ];
	[ newScene addChild: layer ];
	return newScene;
}
+(void)gameOver:(CCLayer *)fatherLayer
{
    _fatherLayer =fatherLayer;
    CCLOG(@"game over being");

    int scoreNow = (float)countForNowGAME/((float)allCount+(float)countForNowGAME)*10;
    NSString *scoreNowSt = [NSString stringWithFormat:@"%d",scoreNow];
    
    CCLOG(@"scoreNow 00 :%@",scoreNowSt);
    int xxx = [scoreNowSt intValue];
    CCLOG(@"scoreNow 00 :%d",xxx);
    
    
    CCLOG(@"game over being scoreNow:%d",scoreNow);
    CCLOG(@"总点击数:%d  此关游戏不同点:%d  分数:%0.1f",allCount+countForNowGAME,countForNowGAME,(float)countForNowGAME/((float)allCount+(float)countForNowGAME) );

    
    CCSprite *goldNormal3 = [CCSprite spriteWithFile:@"BtnBall0001.png"];
    CCSprite *goldSelected3 = [CCSprite spriteWithFile:@"BtnBall0002.png"];
    CCSprite *goldDisabled3 = [CCSprite spriteWithFile:@"BtnBall0003.png"];
    
 
    CCMenuItemSprite* spriteMenuItem3 = [CCMenuItemSprite itemFromNormalSprite:goldNormal3
                                                                selectedSprite:goldSelected3
                                                                disabledSprite:goldDisabled3
                                                                        target:self
                                                                      selector:@selector(nextLevel)];
    
    //附上tag值，方便在菜单项被选中时判断哪一个被选中
    spriteMenuItem3.tag = 3;
    
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:spriteMenuItem3, nil];
    
    if ([SceneTo uiIpadBack]) {
        menu.position = ccp(117, 36);
    }else
        menu.position = ccp(234, 72);
    

    PopUp *pop = [PopUp popUpWithTitle:@" " description:@"" sprite:menu scoreNowSt:scoreNowSt];
    [fatherLayer addChild:pop z:1000];
    
    
    //总点击数归0
    allCount=0;
}
+(void)nextLevel{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    [_fatherLayer removeChild:self cleanup:YES];
    [_fatherLayer wordsLable_deall];
    nowlevel++;
    [self goLevel:nowlevel];
    CCLOG(@"第%i关",nowlevel);
}
+(void)killAllWorld{
    CCLOG(@"KILL----------1");
    [_fatherLayer wordsLable_deall];
    CCLOG(@"KILL----------2");
}
+(void)againPlay
{
    [_fatherLayer wordsLable_deall];
    [self goLevel:nowlevel];
    CCLOG(@"againPlay001");
}
 
@end
