//
//  homeLayer.h
//  homeiTech
//
//  Created by david zhao on 12-3-21.
//  Copyright (c) 2012年 itech. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer
@interface homeLayer : CCLayer
{   
    NSArray *moleFrameCountArray;
    NSArray *moleFirstNameArray;
    NSArray *molePositonXArray;
    NSArray *molePositonYArray;
    
    NSString *homeRoomSound;
    
    NSNumber *soundID;
    int     scaleXY;
    //Control sound playback and click onflict.
    CDSoundSource *myEffect;
    
    CCAction *_hotspotAction;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

//@property(nonatomic,retain) NSArray *moleFrameCountArray;
//@property(nonatomic,retain) NSArray *moleFirstNameArray;
- (void)spriteDalayOnce;


- (void) spriteAnimation:(int)j sprite:(CCSprite *)mole;
- (void) exitSound:(int)j;

@property (nonatomic, retain) CCAction *hotspotAction;

@end
