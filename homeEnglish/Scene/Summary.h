//
//  Summary.h
//  demo
//
//  Created by zzn on 12-11-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
@interface Summary : CCLayer {
    CCSprite * SummaryBackground1;
    CCSprite * SummaryBackground2;
    NSMutableDictionary * RoomName;
    NSMutableDictionary * Ball_x ,*Ball_y;
    
    CCLabelTTF *label;
    
    NSString * name;
    
    int count;
    
    //小球转动一次的变量
    BOOL ballOne;
    
    int     scaleXY;
    //Control sound playback and click onflict.
    CDSoundSource *myEffect;
    
}
+(CCScene *) scene;
@end
