//
//  hVideoLayer.h
//  homeiTech
//
//  Created by david zhao on 12-3-21.
//  Copyright (c) 2012年 itech. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "Visualizer.h"


// HelloWorldLayer
@interface hVideoLayer : CCLayer
{
    MPMoviePlayerController     *mpControler;
    CCLabelTTF                  *videoTextLabel;
    
    NSMutableArray              *arraySpeaker;
    NSMutableArray              *arrayEnglish;
    NSMutableArray              *arrayTimeStart;
    NSMutableArray              *arrayTimeEnd;
    NSMutableArray              *arraySpeakerAll;
    
    NSArray                     *rolePositonXArray;
    NSArray                     *rolePositonYArray;
    
    CFAbsoluteTime              startCFTime, nowCFTime;
    
    int         arrayi;
    NSArray     *moleFirstNameArray;
    NSString    *fromSceneName;
    int         videoCurrentNumber;
    BOOL        videoOneFive;
    
    int         scaleXY;            //判断屏幕分辨率
    
    NSNumber    *soundID;
    CCSprite    *sunSprite;


    
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(NSMutableArray* ) arrayWithImageName:(NSArray *)imageName;
-(void)levelTimerCallback:(NSTimer *)timer;

@end
