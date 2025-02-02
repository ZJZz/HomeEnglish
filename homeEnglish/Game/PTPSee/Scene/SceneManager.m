#import "SceneManager.h"

@interface SceneManager ()
+(void) go: (CCLayer *) layer;
+(CCScene *) wrap: (CCLayer *) layer;
@end


@implementation SceneManager
+(void) goMenu{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	CCLayer *layer = [MenuLayer node];
	[SceneManager go: layer];
}
+(void) goPlay{
	CCLayer *layer = [PlayLayer node];
	[SceneManager go: layer];
}

+(void) goPause{
	CCLayer *layer = [PauseLayer node];
	CCScene *newScene = [SceneManager wrap:layer];
    [ [CCDirector sharedDirector] replaceScene:newScene ];
//	[[CCDirector sharedDirector] pushScene:[CCFlipYTransition transitionWithDuration: 1.0f scene: scene]];
}

+(void) goHighScores{
	CCLayer *layer = [HighScoresLayer node];
	[SceneManager go: layer];
}

+(void) goCredits{
	CCLayer *layer = [CreditsLayer node];
	[SceneManager go: layer];
}

+(void) goLost{
	CCLayer *layer = [HighScoresLayer node];
	[SceneManager go: layer];
}

+(void) go: (CCLayer *) layer{
	CCDirector *director = [CCDirector sharedDirector];
	CCScene *newScene = [SceneManager wrap:layer];
	if ([director runningScene]) {
        [ director replaceScene:newScene ];
//		[director replaceScene:[CCFlipYTransition transitionWithDuration: 1.0f scene: newScene]];
        
        [director replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:newScene withColor:ccBLACK]];
	}else {
		[director runWithScene:newScene];		
	}
}
+(CCScene *) wrap: (CCLayer *) layer{
	CCScene *newScene = [CCScene node];
	[newScene addChild: layer];
	return newScene;
}
@end
