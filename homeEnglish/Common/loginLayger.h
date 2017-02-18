//
//  loginLayger.h
//  homeiTech
//
//  Created by david zhao on 12-3-21.
//  Copyright (c) 2012年 itech. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer
@interface loginLayger : CCLayer <UITextFieldDelegate>
{
    int bodyCurrent;
    int userCount; //记录用户个数
    UITextField* textFieldSkinned;
    
    
    NSNumber    *soundID;

    int         scaleXY;
    //Control sound playback and click onflict.
    CDSoundSource *myEffect;
}

@property (nonatomic) int chAccessoryCurrent;
@property (nonatomic) int chHeadCurrent;
@property (nonatomic) int chBodyCurrent;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
