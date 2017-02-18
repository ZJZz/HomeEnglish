//
//  wyViewWave.h
//  wyVoiceWave
//
//  Created by zzn on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WaveSampleProvider.h"
#import "WaveSampleProviderDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "cocos2d.h"
#define VHEIGHT 420
#define VWIDTH  560

#define WAVERW 200
#define WAVERH 200
@interface wyViewWave : NSObject<WaveSampleProviderDelegate>
{
    WaveSampleProvider *wsp;
    AVPlayer *player;
    int sdl;
    float *sd;
    UIImageView *iSubview;
    float playProgress;
    NSMutableArray *powers;
    UIImage *waveImage;
    float tTime;
    CGRect frame;
    BOOL isStatic;
}

- (id) initWithWaveByPathForResoure:(NSString *)path Type:(NSString *) type Frame:(CGRect) _frame Time:(float)_time isStatic:(BOOL)_isStatic;
- (void) startAudio;
- (void) releaseObject;
-(void) waveView;
-(void) pause;
-(void) play;

@end
