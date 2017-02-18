//
//  hKaraokeLayer.m
//  homeiTech
//
//  Created by david zhao on 12-3-21.
//  Copyright (c) 2012年 itech. All rights reserved.
//


#import "hKaraokeLayer.h"
#import "SimpleAudioEngine.h"

#import "SceneTo.h"
@implementation hKaraokeLayer

#define VHEIGHT 420
#define VWIDTH  560

#define RECORDWAVERW 540
#define RECORDWAVERH 90

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	hKaraokeLayer *layer = [hKaraokeLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer z:0 tag:201];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        self.isTouchEnabled = YES;
		CGSize s = [[CCDirector sharedDirector] winSize];
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        CCLOG(@"scaleXY:%d",scaleXY);
        
        CCSprite *loginbg = [CCSprite spriteWithFile:@"bgkaraoke.png"];
        loginbg.position = ccp(s.width/2, s.height/2);
        loginbg.scale = 1*scaleXY;
        [self addChild:loginbg z:-1];

//        sceneName = @"Bathroom";
        sceneName = [SceneTo SceneNameF];
        idStateKaraok = 0;
        
        //return button
        CCMenuItem *returnSceneItem=[CCMenuItemImage itemWithNormalImage:[sceneName stringByAppendingString:@"ReturnButton.png"] selectedImage:[sceneName stringByAppendingString:@"ReturnButton.png"] target:self selector:@selector(returnSceneName:)];
        returnSceneItem.scale = 1*scaleXY;
        returnSceneItem.position= ccp(989, 35);
        CCMenu *returnSceneMenu =[CCMenu menuWithItems:returnSceneItem, nil];
        returnSceneMenu.position=CGPointZero;
        [self addChild:returnSceneMenu];
        
        playToStopState         = TRUE;
        recordToStopState       = TRUE;
        recordPlayToStopState   = TRUE;
        
        
        sunSprite= [CCSprite spriteWithFile:@"CursorImage.png"];
        sunSprite.position = ccp(435,265);
        sunSprite.scale = 1*scaleXY;
        [self addChild:sunSprite];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hKaraokeAll.plist"];
        
        //101. play to stop
        CCMenuItem *play =
        [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BtnPlay0001.png"]
                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BtnPlay0003.png"]];
        play.scale = 1*scaleXY;
        CCMenuItem *playstop =
        [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BtnStop0001.png"]
                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BtnStop0003.png"]];
        playstop.scale = 1*scaleXY;
        playStopButton =
        [CCMenuItemToggle itemWithTarget:self
                                selector:@selector(playToStopStateFuncT:)
                                   items:play, playstop, nil];
        
        togglePlayStop = [CCMenu menuWithItems:playStopButton, nil];
        togglePlayStop.position = ccp(525, 52);
//        togglePlayStop.scale = 1*scaleXY;
        [self addChild:togglePlayStop z:101];
        
        
        //102. record to stop
        CCMenuItem *record =
        [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BtnRecord0001.png"]
                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BtnRecord0003.png"]];
        record.scale = 1*scaleXY;
        CCMenuItem *recordStop =
        [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BtnStop0001.png"]
                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BtnStop0003.png"]];        
        recordStop.scale = 1*scaleXY;
        recordStopButton =
        [CCMenuItemToggle itemWithTarget:self
                                selector:@selector(recordToStopStateFuncT:)
                                   items:record, recordStop, nil];
        
        toggleRecordStop = [CCMenu menuWithItems:recordStopButton, nil];
        toggleRecordStop.position = ccp(675, 52);
//        toggleRecordStop.scale = 1*scaleXY;
        [self addChild:toggleRecordStop z:102];
        
        //103. recordPlay to stop
        CCMenuItem *recordPlay =
        [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BtnRecordPlay0001.png"]
                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BtnRecordPlay0001.png"]];
        recordPlay.scale = 1*scaleXY;
        CCMenuItem *recordPlayStop =
        [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"BtnStop0001.png"]
                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"BtnStop0003.png"]];
        recordPlayStop.scale = 1*scaleXY;
        recordPlayStopButton =
        [CCMenuItemToggle itemWithTarget:self
                                selector:@selector(recordPlayToStopStateFuncT:)
                                   items:recordPlay, recordPlayStop, nil];
        
        toggleRecordPlayStop = [CCMenu menuWithItems:recordPlayStopButton, nil];
        toggleRecordPlayStop.position = ccp(825, 52);
//        toggleRecordPlayStop.scale = 1*scaleXY;
        [self addChild:toggleRecordPlayStop z:103];

        //If the file of karaOK is exit, button of playRecord is visible
        [self is_recordPlayToStopStateFuncT];
        
        CCSprite *bear = [CCSprite spriteWithSpriteFrameName:@"TeddyMicro.png"];
        bear.position = ccp((200),(250));
        bear.scale = 1*scaleXY;
        [self addChild:bear];
        
        //歌词
        videoTextLabel = [CCLabelTTF labelWithString:@"" fontName:@"GeezaPro" fontSize:32];
		videoTextLabel.position =  ccp( 730 , 210);
        videoTextLabel.color=ccc3(245, 222, 179);
		[self addChild: videoTextLabel z:1 tag:90];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"btncheck.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"typein.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"gardenm.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"gardenk.mp3"];
        
        arrayEnglish    =[[NSMutableArray alloc]init];
        arrayTimeStart  =[[NSMutableArray alloc]init];
        arrayTimeEnd    =[[NSMutableArray alloc]init];        
        
        
        //According to the SceneName to init text.
        [self arrayDictionary];
        
        // initialize powers with an entry for every other pixel of width
        powers = [[NSMutableArray alloc] initWithCapacity:RECORDWAVERW / 2];
        
        CGRect frame = CGRectMake(444, 575, RECORDWAVERW, RECORDWAVERH);
        iRecordingview = [[UIImageView alloc] initWithFrame: frame];
        
        //inite video file
//        [self initVideo];
        [self scheduleOnce:@selector(initVideo:) delay:1];
	}
	return self;
}
- (void) is_recordPlayToStopStateFuncT{
    //If the file of karaOK is exit, button of playRecord is visible
    NSString *karaName = [(NSString *)sceneName stringByAppendingFormat:@"karaoke.caf"];
    if ([self is_file_exist:karaName])
        toggleRecordPlayStop.visible = TRUE;
    else
        toggleRecordPlayStop.visible = FALSE;
}

- (void) returnSceneName:(id)sender{
    NSArray *sceneNameArray = [[NSArray alloc] initWithObjects:
                               @"Livingroom",
                               @"Kitchen",
                               @"Garage",
                               @"Garden",
                               @"Library",
                               @"Bathroom",
                               @"Bedroom",
                               nil];
    int sceneNumber = [sceneNameArray indexOfObject:[SceneTo SceneNameF] ];
    [sceneNameArray release];
    
    // 调用视频播放回调函数，解决场景跳转时的内存问题。
    [self callbackFunction:NULL];
    
    // don't forget to call "super dealloc"
    [recorder release]; // release the recorder AVAudioRecorder
//    [playerMp3 release]; // release the recorder AVAudioRecorder
//    [playerRecorder release]; // release the recorder AVAudioRecorder
    
    [mpControler stop];
    [mpControler.view removeFromSuperview];
    [mpControler autorelease];
    
    [iRecordingview removeFromSuperview];
    [iRecordingview autorelease];
    
    [SceneTo toSceneScene:sceneNumber];
    
}

#pragma mark buttonAction
- (void) playToStopStateFuncT:(id)sender{
    CCLOG(@"playToStopStateFuncT");
    if (playToStopState) {
        playToStopState = FALSE;
        
        idStateKaraok = 1;
        
        toggleRecordStop.isTouchEnabled     =  FALSE;
        toggleRecordPlayStop.isTouchEnabled =  FALSE;
        toggleRecordStop.color              =  ccBLUE;
        toggleRecordPlayStop.color          =  ccBLUE;
        

        
        [self playVideo];                                //play video
        [self playVideoSound];                           //play mp3
        
        //定时器起点
        arrayiCurrent = 0;
        startCFTime = CFAbsoluteTimeGetCurrent();
        [self schedule:@selector(displayVideoText) interval:0.01];
        //Display Text
    }else{
        playToStopState = TRUE;
        
        idStateKaraok = 0;
        
        togglePlayStop.isTouchEnabled       =  TRUE;
        toggleRecordStop.isTouchEnabled     =  TRUE;
        toggleRecordPlayStop.isTouchEnabled =  TRUE;        
        togglePlayStop.color                =  ccWHITE;
        toggleRecordStop.color              =  ccWHITE;
        toggleRecordPlayStop.color          =  ccWHITE;
                
        [self stopKaraoke];
    }
    
}
- (void) recordToStopStateFuncT:(id)sender{
    CCLOG(@"recordToStopStateFuncT");
    if (recordToStopState) {
        recordToStopState = FALSE;
        
        idStateKaraok = 2;
        
        togglePlayStop.isTouchEnabled       =  FALSE;
        toggleRecordPlayStop.isTouchEnabled =  FALSE;
        togglePlayStop.color                =  ccBLUE;
        toggleRecordPlayStop.color          =  ccBLUE;
        
        //To show record image
        iRecordingview.clearsContextBeforeDrawing = TRUE;
        
        
        [self startRecord];
        [self playVideo];    //play video
        [self playVideoSound];      //play mp3 with no sound
        
        
        //定时器起点
        startCFTime = CFAbsoluteTimeGetCurrent();
        arrayiCurrent = 0;
        [self schedule:@selector(displayVideoText) interval:0.01];

        
    }else{
        recordToStopState = TRUE;
        
        idStateKaraok = 0;
        
        togglePlayStop.isTouchEnabled       =  TRUE;
        toggleRecordStop.isTouchEnabled     =  TRUE;
        toggleRecordPlayStop.isTouchEnabled =  TRUE;        
        togglePlayStop.color                =  ccWHITE;
        toggleRecordStop.color              =  ccWHITE;
        toggleRecordPlayStop.color          =  ccWHITE;
        
        [self stopKaraoke];
        //停止计时器
        [self stopRecorder];
        //既是停止录制，又是开始录音
        [self startRecord];
    }
    [self is_recordPlayToStopStateFuncT];
    
}
- (void) recordPlayToStopStateFuncT:(id)sender{
    CCLOG(@"recordPlayToStopStateFuncT");
    if (recordPlayToStopState) {
        recordPlayToStopState = FALSE;
        
        idStateKaraok = 3;
        
        togglePlayStop.isTouchEnabled       =  FALSE;
        toggleRecordStop.isTouchEnabled     =  FALSE;
        togglePlayStop.color                =  ccBLUE;
        toggleRecordStop.color              =  ccBLUE;
        
        if (iRecordingview.image != nil) {
            iRecordingview.image = nil;
        }
        
        [self playVideo];           //play video
        [self playVideoSound];      //play mp3 with no sound
        [self playRecordSound];
        
        //定时器起点
        startCFTime = CFAbsoluteTimeGetCurrent();
        arrayiCurrent = 0;
        [self schedule:@selector(displayVideoText) interval:0.01];
    }else{
        recordPlayToStopState = TRUE;
        
        idStateKaraok = 0;
        
        togglePlayStop.isTouchEnabled       =  TRUE;
        toggleRecordStop.isTouchEnabled     =  TRUE;
        toggleRecordPlayStop.isTouchEnabled =  TRUE;
        togglePlayStop.color                =  ccWHITE;
        toggleRecordStop.color              =  ccWHITE;
        toggleRecordPlayStop.color          =  ccWHITE;
        
        
        [self stopKaraoke];
        
//        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundIdRecorder];
        if([playerRecorder isPlaying]){
            [playerRecorder stop];
            [playerRecorder release];
        }
//        [playerRecorder stop];
//        [playerRecorder release];
//        [self stopVideo];
//        [self unschedule:@selector(displayVideoText)];
//        [videoTextLabel setString:@""];
    }
    
}


// plays the current recording
- (void)playRecordSound
{
    // get the file name for the touches row
    NSURL *documentsDictoryURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSString *filename = [NSString stringWithFormat:@"%@karaoke.caf", sceneName];
    NSLog(@"file:%@",filename);

    
    // create a URL with the file's path
    NSURL *url = [documentsDictoryURL URLByAppendingPathComponent:filename];
    NSLog(@"file url:%@",url);
    NSString *temp = [url absoluteString];
    NSLog(@"file str:%@",temp);
    
//    NSString *filename = [NSString stringWithFormat:@"%@karaoke", sceneName];
//    
//    NSString *loc = [[NSBundle mainBundle] pathForResource:filename ofType:@"caf"];
//    CCLOG(@"file loc:%@",loc);
//    soundIdRecorder = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:temp];
    
//    soundIdRecorder = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:@"Bathroommainbg.mp3"];
    
    
//    // create a new AVAudioPlayer with the URL
    playerRecorder = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

    playerRecorder.numberOfLoops  = 0;

    // set the audio session's category to playback
//    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [playerRecorder prepareToPlay];
    [playerRecorder play]; // play the audio player
}



//According to the type of "ini", read the subtitles, Actor, starttime and endtime.
- (void) arrayDictionary{
    
    //    NSString *tempxx = @"Bedroom01";
    NSString *tempxx = [(NSString *)sceneName stringByAppendingFormat:@"kara"];
    
//    CCLOG(@"tempxx:%@",tempxx);
    
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:tempxx ofType:@"ini"];
//    NSLog(@"lrcPath=%@",lrcPath);
    
    NSString *temp;
    NSRange range;
    
    [arrayEnglish   removeAllObjects];
    [arrayTimeStart removeAllObjects];
    [arrayTimeEnd   removeAllObjects];
       
    NSArray *readline=[[NSString stringWithContentsOfFile:lrcPath] componentsSeparatedByString:@"\n"];
    NSEnumerator *nse=[readline objectEnumerator];
    while(temp=[nse nextObject])
    {
        //        NSLog(@"%@",temp);        
    
        range=[temp rangeOfString:@"English="];//获取位置
        if (range.location!=NSNotFound) {
            [arrayEnglish addObject:[self tempstrSub:temp]];
            continue;
        }
        
        range=[temp rangeOfString:@"Start="];//获取位置
        if (range.location!=NSNotFound) {
            [arrayTimeStart addObject:[self tempstrSub:temp]];
            continue;
        }
        
        range=[temp rangeOfString:@"End="];//获取位置
        if (range.location!=NSNotFound) {
            [arrayTimeEnd addObject:[self tempstrSub:temp]];
            continue;
        }
    }  
}

//Get string after the equal sign.
- (NSString *) tempstrSub:(NSString *)tempstr{
    
    NSRange range;
    
    range=[tempstr rangeOfString:@"="];//获取位置
    if (range.location!=NSNotFound) {
        return [tempstr substringFromIndex:range.location + range.length];
    }
    return NULL;
}


- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CCLOG(@"login－touch position:x:%0.2f,y:%0.2f",location.x,location.y);
}


-(void) initVideo:(ccTime)dt{
    //初始化视频
    NSString *temploc = [(NSString *)sceneName stringByAppendingFormat:@"kara"];
    NSString *loc = [[NSBundle mainBundle] pathForResource:temploc ofType:@"mov"];
    CCLOG(@"loc:%@",loc);
    NSURL *urlVideo=[NSURL fileURLWithPath:loc];
    CCLOG(@"urlVideo:%@",urlVideo);
    mpControler = [[MPMoviePlayerController alloc] initWithContentURL:urlVideo];
    
    // get the cocos2d view (it's the EAGLView class which inherits from UIView)
    UIView* glView = [[CCDirector sharedDirector] view];
    
    [glView addSubview:mpControler.view];
    
    mpControler.view.frame = CGRectMake(430, 36, VWIDTH, VHEIGHT);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callbackFunction:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mpControler];
    mpControler.controlStyle = MPMovieControlStyleNone;
    mpControler.repeatMode = MPMovieRepeatModeNone;
    
    [mpControler stop];
    
    //计算视频长度
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:urlVideo options:opts]; // 初始化视频媒体文件
    secondVideo = 0;
    //获取视频总时长,单位秒 NSLog(@"movie duration : %d", second);
    secondVideo = urlAsset.duration.value / urlAsset.duration.timescale;
    
    CCLOG(@"video:%@ ,time:%f",urlVideo, secondVideo);
}

-(void) playVideo{
    //播放视频
    [mpControler play];
    
    // 在X秒内，从节点的当前位置移动到(100, 80)这个位置
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:(int)secondVideo position:CGPointMake(985,265)];
    [moveTo setTag:91];
    [sunSprite runAction:moveTo];
}

-(void) playVideoSound{
    CCLOG(@"idStateKaraok =%d ",idStateKaraok);
    NSString *temploc;
    temploc = @"";
    
    if (idStateKaraok == 1) {
        temploc = [(NSString *)sceneName stringByAppendingFormat:@"kara"];
    }else if(idStateKaraok == 2 || idStateKaraok == 3){
        temploc = [(NSString *)sceneName stringByAppendingFormat:@"karaNo"];
    }
    if (temploc.length > 0) {
        NSString *loc = [[NSBundle mainBundle] pathForResource:temploc ofType:@"mp3"];
        CCLOG(@"loc:%@",loc);
        soundIdMp3 = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:loc];
        
//        NSURL *url=[NSURL fileURLWithPath:loc];
//        
//        NSError *error;
//        playerMp3 = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
//        [playerMp3 prepareToPlay];
//        [playerMp3 play];
    }

}


-(void) stopVideo{
    [mpControler stop];
    //停止视频播放进度条
    [sunSprite stopActionByTag:91];
    sunSprite.position = ccp(435,265);
    
}
-(void) stopVideoSound{
    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundIdMp3];
//    [playerMp3  stop];
}

//停止karaoke
-(void) stopKaraoke{
    [self stopVideo];
    [self stopVideoSound];
    [self unschedule:@selector(displayVideoText)];
    [videoTextLabel setString:@""];
}

//停止录音
-(void)stopRecorder{
    [self unschedule:@selector(displayRecorderWaver)];//显示波形
}

//视频播放完回调
-(void) callbackFunction:(NSNotification*)notification {
    CCLOG(@"callbackFunction");
    if (idStateKaraok == 1) {
        [playStopButton setSelectedIndex:0];
        [self playToStopStateFuncT:notification ];
    }else if (idStateKaraok == 2){
        [recordStopButton setSelectedIndex:0];
        [self recordToStopStateFuncT:notification ];
    }
    if (idStateKaraok == 3){
        [recordPlayStopButton setSelectedIndex:0];
        [self recordPlayToStopStateFuncT:notification ];
    }
 
}

//删除mpcontrol
-(void) removeMpcontrol{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:mpControler ];
    [mpControler stop];
    [mpControler.view removeFromSuperview];
    [mpControler autorelease];
}


-(NSString *)get_filename:(NSString *)name
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:name];
}
-(BOOL)is_file_exist:(NSString *)name
{
    NSFileManager *file_manager = [NSFileManager defaultManager];
    return [file_manager fileExistsAtPath:[self get_filename:name]];
}


-(void) startRecord{
    // if we’re currently recording
    if (recorder.recording)
    {
        CCLOG(@"startRecord: recorder.recording");
        
        [timer invalidate]; // stop the timer from generating events
        timer = nil; // set time to nil
        [recorder stop]; // stop recording
        
        // set the category of the current audio session
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error:nil];
   
    } // end if
    else
    {
        CCLOG(@"startRecord no recorder.recording");
        
        NSError *setCategoryError = nil;
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: &setCategoryError];
        
        if (setCategoryError) {
            NSLog(@"%@",[setCategoryError description]);
        }
        
//        OSStatus propertySetError = 0;        
//        UInt32 allowMixing = true;        
//        propertySetError = AudioSessionSetProperty ( kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing);
        
        UInt32 allowMixing = true;
        AudioSessionSetProperty ( kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof (allowMixing), &allowMixing);
        

        
        //---------------------
        
        // set the audio session's category to record
//        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
        
        // find the location of the document directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        // get the first directory
        NSString *dir = [paths objectAtIndex:0];
        
        // create a name for the file using the current system time
        //        NSString *filename = [NSString stringWithFormat:@"%f.caf", [[NSDate date] timeIntervalSince1970]];
        NSString *filename = [NSString stringWithFormat:@"%@karaoke.caf", sceneName];
        
        NSFileManager *file_manager = [NSFileManager defaultManager];
//        BOOL ret;
        if ([file_manager fileExistsAtPath:[self get_filename:filename]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self get_filename:filename] error:nil];
        }
        
        // cre=ate the path using the directory and file name
        NSString *path = [dir stringByAppendingPathComponent:filename];
        
        // create a new NSMutableDictionary for the record settings
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        
        // record using the Apple lossless format
        [settings setValue: [NSNumber numberWithInt:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
        
        // set the sample rate to 44100 Hz
        [settings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        
        // set the number of channels for recording
        [settings setValue:[NSNumber numberWithInt:1]
                    forKey:AVNumberOfChannelsKey];
        
        // set the bit depth
        [settings setValue:[NSNumber numberWithInt:16]
                    forKey:AVLinearPCMBitDepthKey];
        
        // set whether the format is big endian
        [settings setValue:[NSNumber numberWithBool:NO]
                    forKey:AVLinearPCMIsBigEndianKey];
        
        // set whether the audio format is floating point
        [settings setValue:[NSNumber numberWithBool:NO]
                    forKey:AVLinearPCMIsFloatKey];
//        [visualizer clear]; // clear the visualizer
        [powers removeAllObjects]; // remove all objects from powers
        
        [recorder release]; // release the recorder AVAudioRecorder
        
        // initialize recorder with the URL and settings
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:settings error:nil];
        [recorder prepareToRecord]; // prepare the recorder to record
        recorder.meteringEnabled = YES; // enable metering for the recorder
        [recorder record]; // start the recording

        [settings release];
        [self schedule:@selector(displayRecorderWaver) interval:0.01];//显示波形
        
        
    } // end else
    
    
    
}

// called every .05 seconds when the timer generates an event
//- (void)timerFired:(NSTimer *)timer
-(void)displayRecorderWaver
{
    //    CCLOG(@"timerFired start");
    [recorder updateMeters]; // sample the recording to get new data
    
    // set the visualizer's average power level
    [self setPower:[recorder averagePowerForChannel:0]];
    
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    
    CGRect frame = CGRectMake(90, 400, RECORDWAVERW,RECORDWAVERH);
    //RECORDWAVERW,RECORDWAVERH
    //    //1------------------
    CGSize size = frame.size;
    UIGraphicsBeginImageContext(size);
    
    // get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CCLOG(@"powers.count:%d",powers.count);
    
    // draw a line for each point in powers
    for (int i = 0; i < powers.count; i++)
    {
        
        // get next power level
        float newPower = [[powers objectAtIndex:i] floatValue];
        
//        CCLOG(@"newPower:%f",newPower);
        
        // calculate the height for this power level
        float height = (1 - newPower / minPower) * (size.height / 2);
        
        // move to a point above the middle of the screen
        CGContextMoveToPoint(context, i * 2, size.height / 2 - height);
        
        // add a line to a point below the middle of the screen
        CGContextAddLineToPoint(context, i * 2, size.height / 2 + height);
        
        // set the color for this line segment based on f
        CGContextSetRGBStrokeColor(context, 0, 1, 0, 1);
        CGContextStrokePath(context); // draw the line
    } // end for
    
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    iRecordingview.image = nil;
    [iRecordingview setImage:resultingImage];
    [[[CCDirector sharedDirector] view] addSubview:iRecordingview];
  
    
} // end method timerFired:

// sets the current power in the recording
- (void)setPower:(float)p
{
    CGRect frame = CGRectMake(100,400, RECORDWAVERW,RECORDWAVERH);
    [powers addObject:[NSNumber numberWithFloat:p]]; // add value to powers
    
    // while there are enough entries to fill the entire screen
    while (powers.count * 2 > frame.size.width)
        [powers removeObjectAtIndex:0]; // remove the oldest entry
    
    // if the new power is less than the smallest power recorded
    if (p < minPower)
        minPower = p; // update minPower with the new power
} // end method setPower:


//- (void) displayVideoText:(NSTimer *)timer{
-(void) displayVideoText{
    nowCFTime = CFAbsoluteTimeGetCurrent();
    
    NSString *objB = [NSString stringWithFormat:@"%0.1f", (double)(nowCFTime - startCFTime)];
    
    int temp =[objB doubleValue] * 1000;
//    CCLOG(@"temp :%d",temp);
    
    if (arrayiCurrent < [arrayTimeStart count]) {
        if (temp > [[arrayTimeStart objectAtIndex:arrayiCurrent] intValue]) {
            [videoTextLabel setString:[arrayEnglish objectAtIndex:arrayiCurrent ]];
            arrayiCurrent++;
        }
    }else {
        [videoTextLabel setString:@""];
    }
}
-(void) backgroundToFrontVideo{
    CCLOG(@"backgroundToFrontVideo+++++++++++");
    CCLOG(@"backgroundToFrontVideo+++++++++++ %d",mpControler.playbackState);
    //pause
    if (mpControler.playbackState == 2 ) {
        [mpControler play];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
	//释放起始时的视频文件内存
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:MPMoviePlayerPlaybackDidFinishNotification
//                                                  object:mpControler ];
//    [mpControler stop];
//    [mpControler.view removeFromSuperview];
//    [mpControler autorelease];
    
//    if (powers.count != 0) {
//        [powers removeAllObjects];
//        [powers release];
//    }
    
//    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundIdMp3];
//    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundIdRecorder];
    
//	// don't forget to call "super dealloc"
//    [recorder release]; // release the recorder AVAudioRecorder
//    [playerMp3 release]; // release the recorder AVAudioRecorder
//    [playerRecorder release]; // release the recorder AVAudioRecorder


    
//    [iRecordingview removeFromSuperview];
//    [iRecordingview autorelease];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"hKaraokeAll.plist"];

	[super dealloc];
}

@end
