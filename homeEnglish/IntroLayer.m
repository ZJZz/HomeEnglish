//
//  IntroLayer.m
//  homeEnglish
//
//  Created by david zhao on 12-10-6.
//  Copyright itech 2012年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"

#import "loginLayger.h"
#import "flashLayger.h"
//#import "hKaraokeLayer.h"
#import "homeLayer.h"
//#import "hVideoLayer.h"

#import "SceneTo.h"

#import "wyMatchGameLayer.h"
#import "MagicSpellLayer.h"
#import "SceneManager.h"

#import "hKaraokeLayer.h"

#import "InterfaceManager.h"


#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];

	// ask director for the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	CCSprite *background;
	
	if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
		background = [CCSprite spriteWithFile:@"Default.png"];
		background.rotation = 90;
	} else {
		background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
	}
	background.position = ccp(size.width/2, size.height/2);
    
    [SceneTo uiIPad2or3];

	// add the label as a child to this Layer
	[self addChild: background];
	
	// In one second transition to the new scene
	[self scheduleOnce:@selector(makeTransition:) delay:1];
}



-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[flashLayger scene] withColor:ccBLACK]];
    
    //找不同
//    [ InterfaceManager goDiffGame:@"Bathroom"];
    
}
@end
