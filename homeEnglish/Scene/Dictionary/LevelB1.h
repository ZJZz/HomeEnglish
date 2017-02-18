//
//  LevelB1.h
//  homeEnglish
//
//  Created by zyq on 12-11-8.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
@interface LevelB1 : CCLayer {
    CGRect rect;
    NSMutableArray *list;
    NSValue *value;
    int array[32];
    int soundPath;
    
    int scaleXY;
    
    //Control sound playback and click onflict.
    CDSoundSource *myEffect;    
    SimpleAudioEngine *mySAE;
}
@property (nonatomic ,retain) NSMutableArray *list;
@property (nonatomic,retain) NSValue *value;
-(void)get_point:(CGPoint) point;
+(CCScene *) scene;
@end
