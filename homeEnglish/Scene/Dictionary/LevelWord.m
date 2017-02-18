//
//  LevelWord.m
//  homeEnglish
//
//  Created by zhao david on 13-6-9.
//  Copyright 2013年 itech. All rights reserved.
//

#import "LevelWord.h"


@implementation LevelWord

+(CCScene *) sceneWithWord:(NSString *) wordPath Level:(NSString *) l
{
    // 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	// 'layer' is an autorelease object.
    
    LevelWord    *layer = [[[LevelWord alloc]initWithWord:wordPath Level:l]autorelease];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
    
}

-(id) initWithWord:(NSString *) wordPath Level:(NSString *) l
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CCLOG(@"---------start---------");

        
    }
    return self;
}

- (void) dealloc
{
	// don't forget to call "super dealloc"
    CCLOG(@"---------------------dealloc");
	[super dealloc];
}


@end
