//
//  hKaraokeLayer.h
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
//#import "wyViewWave.h"
// HelloWorldLayer
@interface hKaraokeLayer : CCLayer
{
    MPMoviePlayerController *mpControler;
    CCLabelTTF              *videoTextLabel;
    
    CFAbsoluteTime          startCFTime, nowCFTime;
    NSTimer                 *timeOnce;
    
    int                     arrayiCurrent;
    
    AVAudioRecorder         *recorder; // records user sound input
    NSTimer                 *timer; // updates the visualizer every .05 seconds
    
    CGPoint                 curpos;
    CGPoint                 originpos;
    
    NSMutableArray          *powers; // past power levels in the recording
    float                   minPower; // the lowest recorded power level
    
    UIImageView             *iRecordingview;
    
    NSMutableArray          *arrayEnglish;
    NSMutableArray          *arrayTimeStart;
    NSMutableArray          *arrayTimeEnd;
    
    NSString                *sceneName;
    
    int                     scaleXY;
    
    int                     idStateKaraok;
    BOOL                playToStopState, recordToStopState, recordPlayToStopState;
    CCMenu              *togglePlayStop, *toggleRecordStop, *toggleRecordPlayStop;
    CCMenuItemToggle    *playStopButton, *recordStopButton, *recordPlayStopButton;
    
    NSNumber            *soundIdMp3, *soundIdRecorder;
    
    AVAudioPlayer       *playerRecorder;
    
    CCSprite            *sunSprite;
    float               secondVideo;
}


// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

-(void)backgroundToFrontVideo;
-(void)levelTimerCallback:(NSTimer *)timer;
-(void)setPower:(float)p;

@end
