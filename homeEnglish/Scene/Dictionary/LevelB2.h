//
//  LevelB2.h
//  homeEnglish
//
//  Created by zyq on 12-11-8.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"


@interface LevelB2 : CCLayer {
    NSMutableArray *mWordList;
    NSMutableArray *sss;
    CCSprite *word[16];
    CCMenuItem *pb[16];
    CCMenu *button[16];
    CGSize size;
    int get_count;
    
    int scaleXY;
    
    NSNumber *soundID;
    NSNumber *soundPNID;
    
    //Control sound playback and click onflict.
    CDSoundSource *myEffect;
}
@property (nonatomic ,retain) NSMutableArray *m;
@property (nonatomic ,retain) NSMutableArray *sss;
//@property (nonatomic ,retain) CCSprite *word;
+(CCScene *) scene;
//+(void ) getRandArrayOfSum:(int) sum Need:(int) need;
+(void) get_flag:(int) number;
-(void) set_image;
@end
