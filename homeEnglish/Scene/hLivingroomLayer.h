//
//  hLivingroomLayer.h
//  homeiTech
//
//  Created by david zhao on 12-3-22.
//  Copyright (c) 2012年 itech. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "imagePointLocation.h"
#import "SimpleAudioEngine.h"

//@class imagePointLocation;
// HelloWorldLayer
@interface hLivingroomLayer : CCLayer
{
    NSArray *moleFrameCountArray;
    NSArray *moleFirstNameArray;
    NSArray *molePositonXArray;
    NSArray *molePositonYArray;
    
    NSDictionary *wordsLivingroom;
    
    NSString *wordSound, *wordName, *wordImage;
    
    int         scaleXY;
    //Control sound playback and click onflict.
    CDSoundSource *myEffect;

}

@property (nonatomic, retain) NSDictionary* wordsLivingroom;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (void)spriteDalayOnce;
- (void) spriteAnimation:(int)j sprite:(CCSprite *)mole;

@end