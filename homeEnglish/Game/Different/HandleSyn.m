//
//  touch.m
//  Untitled
//
//  Created by chen hua on 11/5/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "HandleSyn.h"
#import "InterfaceManager.h"
#import "SimpleAudioEngine.h"
#import "CCMenuPopup.h"
#import "PopUp.h"
#import "SceneTo.h"

@implementation HandleSyn
{
}

-( id ) init
{
	if( (self = [super init]) ) {
        self.isTouchEnabled = YES;
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        CCLOG(@"scaleXY:%d",scaleXY);
    }    
	return self;
}

-( void ) setSynSprint:( CCSprite * ) s
{
	synSprite = s;
}
 
-(void) onGameMenu: (id) sender
{
    CCLOG(@"HandleSyn onGameMenu");
    [ InterfaceManager  goMainMenu];
    
}

-(void) onGameHelp: (id) sender
{
    CCLOG(@"HandleSyn onGameHelp");
    [ InterfaceManager  goAbout];
    
}
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
//    CCLOG(@"touch---bigggin--");
    return 0;
} 
-(void) removerightOrError:(int)flag{
    
    CCLOG(@"现在按对了几个-----%d",rightOrErrorCount);
    if(rightOrErrorCount == 0){
        CCSprite *zhongjian1 =(CCSprite *) [self getChildByTag:91];
        zhongjian1.visible =NO;
    }else if(rightOrErrorCount == 1){
        CCSprite *zhongjian2 =(CCSprite *) [self getChildByTag:92];
        zhongjian2.visible =NO;
    }else if(rightOrErrorCount == 2){
        CCSprite *zhongjian3 =(CCSprite *) [self getChildByTag:93];
        zhongjian3.visible =NO;
    }else if(rightOrErrorCount == 3){
        CCSprite *zhongjian4 =(CCSprite *) [self getChildByTag:94];
        zhongjian4.visible =NO;
    }else if(rightOrErrorCount == 4){
        CCSprite *zhongjian5 =(CCSprite *) [self getChildByTag:95];
        zhongjian5.visible =NO;
    }else if(rightOrErrorCount == 5){
        CCSprite *zhongjian6 =(CCSprite *) [self getChildByTag:96];
        zhongjian6.visible =NO;
    }
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //总点击数++
    [InterfaceManager allCountUp];
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CCSprite *menuButton = (CCSprite *)[self getChildByTag:1];

    
    //如果是按了右下角的home 就切回主2界面
    if (CGRectContainsPoint([menuButton boundingBox], location)) {
        [self  wordsLable_deall];
        
        
        text2.text =@"";
        // 切回主2界面        
        NSArray *sceneNameArray = [[NSArray alloc] initWithObjects:
                                   @"Livingroom",
                                   @"Kitchen",
                                   @"Garage",
                                   @"Garden",
                                   @"Library",
                                   @"Bathroom",
                                   @"Bedroom",
                                   nil];
        int sceneNumber = [sceneNameArray indexOfObject:[SceneTo SceneNameF] ];
        [sceneNameArray release];
        CCLOG(@"推出游戏-------------");
        [SceneTo toSceneScene:sceneNumber];
    }
}

-(void)rightOrErrorCountdo:(int)tag{
    
//    CCLOG(@"tag:%i",tag);
    NSString *WordName = [word1 objectAtIndex:tag-1];

    WordName = [WordName stringByReplacingOccurrencesOfString:@"2"withString:@""];
    WordName = [WordName stringByReplacingOccurrencesOfString:@"3"withString:@""];
    WordName = [WordName stringByReplacingOccurrencesOfString:@"4"withString:@""];
    WordName = [WordName stringByReplacingOccurrencesOfString:@"5"withString:@""];
    WordName = [WordName stringByReplacingOccurrencesOfString:@"6"withString:@""];
    WordName = [WordName stringByReplacingOccurrencesOfString:@"7"withString:@""];

    CCSprite *wordCurrent = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", WordName]];
    wordCurrent.anchorPoint = ccp(0.5, 0.5);
    wordCurrent.position = ccp(rightOrErrorCount*150+70,120);
    wordCurrent.scale = 0.8*scaleXY;


    CCLOG(@"tag::%d",tag);
    int fontSize = 28;
    
    if (tag == 1) {
        wordLable1 = [CCLabelTTF labelWithString:WordName fontName:@"AppleGothic" fontSize:fontSize ];
        wordLable1.position =  ccp( rightOrErrorCount*150+70,55);
        [self addChild: wordLable1 ];
    }else if (tag == 2) {
        wordLable2 = [CCLabelTTF labelWithString:WordName fontName:@"AppleGothic" fontSize:fontSize ];
        wordLable2.position =  ccp( rightOrErrorCount*150+70,55);
        [self addChild: wordLable2 ];
    }else if (tag == 3) {
        wordLable3 = [CCLabelTTF labelWithString:WordName fontName:@"AppleGothic" fontSize:fontSize ];
        wordLable3.position =  ccp( rightOrErrorCount*150+70,55);
        [self addChild: wordLable3 ];
    }else if (tag == 4) {
        wordLable4 = [CCLabelTTF labelWithString:WordName fontName:@"AppleGothic" fontSize:fontSize ];
        wordLable4.position =  ccp( rightOrErrorCount*150+70,55);
        [self addChild: wordLable4 ];
    }else if (tag == 5) {
        wordLable5 = [CCLabelTTF labelWithString:WordName fontName:@"AppleGothic" fontSize:fontSize ];
        wordLable5.position =  ccp( rightOrErrorCount*150+70,55);
        [self addChild: wordLable5 ];
    }else if (tag == 6) {
        wordLable6 = [CCLabelTTF labelWithString:WordName fontName:@"AppleGothic" fontSize:fontSize ];
        wordLable6.position =  ccp( rightOrErrorCount*150+70,55);
        [self addChild: wordLable6 ];
    }

    

    
    [self addChild:wordCurrent z:3];
    CCLOG(@"dif------:%@",WordName);
    [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%@_us.mp3", WordName]];
    
}
-(void)wordsLable_deall{
    CCLOG(@"----------wordsLable_deall");
    if(wordLable1 != nil){
        CCLOG(@"------1deall");
        wordLable1.string =@"";
//        [wordLable1 release];
    }
    if (wordLable2 != nil){
        CCLOG(@"------2deall");
        wordLable2.string =@"";
//        [wordLable2 release];
    }
    if (wordLable3 != nil){
        CCLOG(@"------3deall");
        wordLable3.string =@"";
//        [wordLable3 release];
    }
    if (wordLable4 != nil){
        CCLOG(@"------4deall");
        wordLable4.string =@"";
//        [wordLable4 release];
    }
    if (wordLable5 != nil){
        CCLOG(@"------5deall");
        wordLable5.string =@"";
//        [wordLable5 release];
    }
    if (wordLable6 != nil){
        CCLOG(@"------6deall");
        wordLable6.string =@"";
//        [wordLable6 release];
    }
}

-(void)setrightOrErrorCount:(int)count{
    rightOrErrorCount =count;
}
-(void)againPlay
{
    CCLOG(@"againPlay001");
}

-(void)mainMenu
{
    CCLOG(@"mainMenu");
}
-( void ) dealloc
{
	[ super dealloc ];
}

@end
