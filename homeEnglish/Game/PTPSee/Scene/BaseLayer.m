#import "BaseLayer.h"

#import "SceneTo.h"
#import "SimpleAudioEngine.h"


@implementation BaseLayer
-(id) init{
	self = [super init];
	if(nil == self){
		return nil;
	}
	
	self.isTouchEnabled = YES;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
	
	CCSprite *bg = [CCSprite spriteWithFile: @"backgroud.png"];
//	bg.position = ccp(240,160);
    bg.position = ccp(size.width/2,size.height/2);
	[self addChild: bg z:0];
    
    
    if ([SceneTo uiIpadBack]) {
        scaleXY = 2;
    }else
        scaleXY = 1;    
    
    //return button
    NSString * fromSceneName =[SceneTo SceneNameF] ;    
    CCLOG(@"++++++++fromSceneName ptp:%@",fromSceneName);        
    CCMenuItem *returnSceneItem=[CCMenuItemImage itemWithNormalImage:[fromSceneName stringByAppendingString:@"ReturnButton.png"] selectedImage:[fromSceneName stringByAppendingString:@"ReturnButton.png"] target:self selector:@selector(returnSceneName:)];
    returnSceneItem.scale = 1*scaleXY;
    returnSceneItem.position= ccp(989, 35);
    CCMenu *returnSceneMenu =[CCMenu menuWithItems:returnSceneItem, nil];
    returnSceneMenu.position=CGPointZero;
    
    [self addChild:returnSceneMenu];
    
    //血条背景
    CCSprite *backGroundSprite = [CCSprite spriteWithFile:@"backGround.png"];
    CCProgressTimer *planeHPBKTimer = [CCProgressTimer progressWithSprite:backGroundSprite];
    planeHPBKTimer.percentage = 100;
    planeHPBKTimer.position = ccp(625,740);
    planeHPBKTimer.scale = 1*scaleXY;
    [self addChild:planeHPBKTimer z:0];
    //血条血量
    CCSprite *planeHPSprite = [CCSprite spriteWithFile:@"planeHP.png"];
    planeHPTimer = [CCProgressTimer progressWithSprite:planeHPSprite];
    planeHPTimer.type = kCCProgressTimerTypeBar;
    planeHPTimer.midpoint = ccp(0,0.5);
    planeHPTimer.barChangeRate = ccp(1,0);
    planeHPTimer.percentage = 100;
    planeHPTimer.position = ccp(625,740);
    planeHPTimer.scale = 1*scaleXY;
    [self addChild:planeHPTimer z:0];
//    [self schedule:@selector(secondUpdate) interval:1.0f];
    
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"DotToDot.mp3"];
    [CDAudioManager sharedManager].backgroundMusic.volume = 0.5f;
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"DotToDot.mp3" loop:YES];

	
//    scaleXY = 1;
	return self;
}

- (void) returnSceneName:(id)sender{
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
    
    [SceneTo toSceneScene:sceneNumber];
    
//	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] withColor:ccWHITE]];
    
}

@end
