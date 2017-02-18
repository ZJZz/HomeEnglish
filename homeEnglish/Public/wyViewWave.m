//
//  wyViewWave.m
//  wyVoiceWave
//
//  Created by zzn on 12-11-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "wyViewWave.h"

@implementation wyViewWave
-(void) sampleProcessed:(WaveSampleProvider *)provider
{
    sdl = 0;
    sd = [wsp dataForResolution:44100 lenght:&sdl];
    NSLog(@"sdl=%d",sdl);
    [self startAudio];    
}
- (void)setPower:(float)p
{
//    static int count=0;
   // NSLog(@"count=%d",count++);
    [powers addObject:[NSNumber numberWithFloat:p]]; // add value to powers
    
    // while there are enough entries to fill the entire screen
    while (powers.count * 2 > frame.size.width)
        [powers removeObjectAtIndex:0]; // remove the oldest entry
}
-(void)	waveView
{
  //  NSLog(@"waveView");
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    //   
    //    //1------------------
    CGSize size = frame.size;    
    UIGraphicsBeginImageContext(size);	
    
    // get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
 
        int index=(int)(playProgress*sdl);
        [self setPower:sd[index]];
        // draw a line for each point in powers
        for (int i = 0; i < powers.count; i++)
        {
            // get next power level
            float newPower = [[powers objectAtIndex:i] floatValue];
            float height = (newPower) * (size.height / 2);
        //  NSLog(@"sd[%d]=%f",i,sd[i]);
        // move to a point above the middle of the screen
            CGContextMoveToPoint(context, i * 2, size.height / 2 - height);
        // add a line to a point below the middle of the screen
            CGContextAddLineToPoint(context, i * 2, size.height / 2 + height);
            // set the color for this line segment based on f
//            CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
            CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
            CGContextStrokePath(context); // draw the line
        } // end for

    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    iSubview.image = nil;
    [iSubview setImage:resultingImage];
    [[[CCDirector sharedDirector] view] addSubview:iSubview];
   
} // end method timerFired:
-(void) pause
{
    [player pause];
}
-(void) play
{
    [player play];
}
- (void ) waveStaticView
{
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境 
    //   
    //    //1------------------
    CGSize size = frame.size;    
    UIGraphicsBeginImageContext(size);	
    
    // get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    // NSLog(@"sdl=%d count=%d",sdl,count);
    int rate=882*tTime;
    int index=0;
    float MMin=1000,MMax=-1000;
    for (int i = 0;; i++)
    {
        // get next power level
        index+=rate;
        if (index>sdl) break;
        if (MMin>sd[index]) MMin=sd[index];
        if (MMax<sd[index]) MMax=sd[index];
        float height = (sd[index]) * (size.height / 2);
        
        
        
//          NSLog(@"sd[%d]=%f",index,sd[index]);
        
        
        
        // move to a point above the middle of the screen
        CGContextMoveToPoint(context, i * 2, size.height / 2 - height);
        // add a line to a point below the middle of the screen
        CGContextAddLineToPoint(context, i * 2, size.height / 2 + height);
        // set the color for this line segment based on f
        CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
        CGContextStrokePath(context); // draw the line
    } // end for
    NSLog(@"max=%f min=%f",MMax,MMin);
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();   
    iSubview.image = nil;
    [iSubview setImage:resultingImage];
    [[[CCDirector sharedDirector] view] addSubview:iSubview];

}

- (void) startAudio
{
	NSLog(@"start Audio");
	player = [[AVPlayer alloc] initWithURL:wsp.audioURL];
    
   //只出现波形，不出现声音的设置处
    //[player play];
    
    
    Float64 duration = CMTimeGetSeconds(player.currentItem.duration);
    NSLog(@"time=%lf",sdl/duration);
    if (isStatic==NO)
    {
    CMTime tm = CMTimeMakeWithSeconds(tTime, NSEC_PER_SEC);
    [player addPeriodicTimeObserverForInterval:tm queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        Float64 duration = CMTimeGetSeconds(player.currentItem.duration);
        Float64 currentTime = CMTimeGetSeconds(player.currentTime);
        playProgress = currentTime/duration;//wenyuan	time
        //	NSLog(@"playProgress=%f dur=%f cur=%f",playProgress,duration,currentTime);
        [self waveView];
    }];
    }
    else
    {
        [self waveStaticView];
    }
       
}

-(id) initWithWaveByPathForResoure:(NSString *)path Type:(NSString *)type Frame:(CGRect)_frame Time:(float) _time
isStatic:(BOOL)_isStatic
{
    if (self =[super init])
    {
        NSLog(@"hello");
        frame=_frame;
        tTime=_time;
        isStatic=_isStatic;
      powers = [[NSMutableArray alloc] initWithCapacity:WAVERW / 2];
        iSubview = [[UIImageView alloc] initWithFrame: frame]; 
        NSString *p = [[NSBundle mainBundle] pathForResource:path   ofType:type];
        NSURL *url = [NSURL fileURLWithPath:p];
        [wsp release];
        wsp = [[WaveSampleProvider alloc]initWithURL:url];
        wsp.delegate = self;
        [wsp createSampleData];
    }
    return self;
}

- (void) releaseObject
{
    CCLOG(@"wy releaseObject");
    free(sd);
    [wsp release];
//    [iSubview release];
    //remove textFieldSkinned of UITextField
    [iSubview removeFromSuperview];
    [powers release];
    [super dealloc];
    
}


-(void) dealloc
{
    CCLOG(@"wy dealloc");
//    free(sd);
//    [wsp release];
//    [iSubview release];
//    [powers release];
    [super dealloc];
}
@end
