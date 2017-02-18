//
//  LevelB3.h
//  homeEnglish
//
//  Created by zyq on 12-11-13.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "wyViewWave.h"

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "Visualizer.h"


@interface LevelB3 : CCLayer {
    wyViewWave * wy;
    NSString *tmpPath,*temp,*wordGroupName;
    
    int scaleXY;
    
    CFAbsoluteTime startCFTime, nowCFTime;
    IBOutlet Visualizer *visualizer; // store    Visualizer
    AVAudioRecorder *recorder; // records user sound input
    AVAudioPlayer *player; // records user sound input
    NSTimer *timer; // updates the visualizer every .05 seconds
    NSMutableArray *powers; // past power levels in the recording
    float minPower; // the lowest recorded power level
    
    UIImageView *iRecordsoundSubview;
    double lowPassResults;
    NSNumber *soundID;
    
}

+(CCScene *) sceneWithWordGroup:(NSString *) wordAndGroup;
//+(CCScene *) scene;
//-(id) initwithWord:(NSString *)word secondGroup:(NSString *)wordGroup;

// declare visualizer and recordButton as properties
@property (nonatomic, retain) Visualizer *visualizer;
- (void)levelTimerCallback:(NSTimer *)timer;
- (void)setPower:(float)p;

@end
