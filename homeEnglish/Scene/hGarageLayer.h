//
//  hGarageLayer.h
//  homeEnglish
//
//  Created by zzn on 12-11-5.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "imagePointLocation.h"

#import "SimpleAudioEngine.h"
@interface hGarageLayer : CCLayer {
    NSArray *moleFrameCountArray;
    NSArray *moleFirstNameArray;
    NSArray *molePositonXArray;
    NSArray *molePositonYArray;
    
    
    NSDictionary *wordsGarage;
    
    NSString *wordSound, *wordName, *wordImage;
    
    int         scaleXY;
    //Control sound playback and click onflict.
    CDSoundSource *myEffect;
}

@property (nonatomic, retain) NSDictionary* wordsGarage;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
- (void)spriteDalayOnce;
- (void) spriteAnimation:(int)j sprite:(CCSprite *)mole;
@end
