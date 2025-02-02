#import "MenuLayer.h"

@implementation MenuLayer

-(id) init{
	self = [super init];
		
	CCLabelTTF *titleLeft = [CCLabelTTF labelWithString:@"Fruit " fontName:@"Marker Felt" fontSize:48];
	CCLabelTTF *titleRight = [CCLabelTTF labelWithString:@" Link" fontName:@"Marker Felt" fontSize:48];
	CCMenuItemFont *startNew = [CCMenuItemFont itemFromString:@"New Game" target:self selector: @selector(onStartNew:)];

	CCMenuItemFont *resume = [CCMenuItemFont itemFromString:@"Continue" target:self selector: @selector(onResume:)];

	CCMenuItemFont *highscores = [CCMenuItemFont itemFromString:@"Record" target:self selector: @selector(onHighscores:)];

	CCMenuItemFont *credits = [CCMenuItemFont itemFromString:@"Credits" target:self selector: @selector(onCredits:)];
	
	CCMenu *menu = [CCMenu menuWithItems:startNew, resume, highscores, credits, nil];
	
	float delayTime = 0.3f;
	
	for (CCMenuItemFont *each in [menu children]) {
		each.scaleX = 0.0f;
		each.scaleY = 0.0f;
		CCAction *action = [CCSequence actions:
		 [CCDelayTime actionWithDuration: delayTime],
		 [CCScaleTo actionWithDuration:0.5F scale:1.0],
		 nil];
		delayTime += 0.2f;
		[each runAction: action];
	}
	
	titleLeft.position = ccp(-80, 245);
	CCAction *titleLeftAction = [CCSequence actions:
			[CCDelayTime actionWithDuration: delayTime],
			[CCEaseBackOut actionWithAction:
			 [CCMoveTo actionWithDuration: 1.0 position:ccp(200,245)]],
			nil];
	[self addChild: titleLeft];
	[titleLeft runAction: titleLeftAction];
	
	titleRight.position = ccp(560, 245);
	CCAction *titleRightAction = [CCSequence actions:
								 [CCDelayTime actionWithDuration: delayTime],
								 [CCEaseBackOut actionWithAction:
								  [CCMoveTo actionWithDuration: 1.0 position:ccp(280,245)]],
								 nil];
	[self addChild: titleRight];
	[titleRight runAction: titleRightAction];
	
	menu.position = ccp(240, 130);
	[menu alignItemsVerticallyWithPadding: 40.0f];
	[self addChild:menu z: 2];

	return self;
}

- (void)onStartNew:(id)sender{
	[MusicHandler notifyButtonClick];
	[User clear];
	[self onResume: sender];
}
- (void)onResume:(id)sender{
	[MusicHandler notifyButtonClick];
	[SceneManager goPlay];
}

- (void)onHighscores:(id)sender{
	[MusicHandler notifyButtonClick];
	[SceneManager goHighScores];
}
- (void)onCredits:(id)sender{
	[MusicHandler notifyButtonClick];
	[SceneManager goCredits];
}
@end
