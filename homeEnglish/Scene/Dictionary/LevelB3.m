//
//  LevelB3.m
//  homeEnglish
//
//  Created by zyq on 12-11-13.
//  Copyright 2012年 itech. All rights reserved.
//

#import "LevelB3.h"
#import "LevelB1.h"
#import "LevelB2.h"
#import "SimpleAudioEngine.h"
#import "SceneTo.h"
#import <AVFoundation/AVFoundation.h>

@implementation LevelB3

@synthesize visualizer; // generate get and set methods for visualizer
#define VHEIGHT 420
#define VWIDTH  560

#define WAVERWL 400
#define WAVERHL 200

//创建一个scence用于场景的切换
+(CCScene *)sceneWithWordGroup:(NSString *)wordAndGroup
//+(CCScene *)scene
{
    //    NSString * get_path = @"flower";
    //    NSString * wordGroup = @"beautiful_nature";
    CCScene *scene=[CCScene node];
    LevelB3 *layer=[[[LevelB3 alloc]initwithWordGroup:wordAndGroup]autorelease];

    [scene addChild:layer];
    return scene;
}



//初始化
-(id) initwithWordGroup:(NSString *)wordAndGroup
{
    if((self = [super init]))
    {
        //添加字典的目录图片
        CGSize size=[[CCDirector sharedDirector] winSize];
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        
        //分割字符串：单词和类别
        CCLOG(@"-----wordAndGroup:%@",wordAndGroup);
        NSArray *arry=[wordAndGroup componentsSeparatedByString:@":"];
        NSString *word,*wordGroup;
        word = [arry objectAtIndex:0];
        wordGroup = [arry objectAtIndex:1];
        
        //初始化时，删除录音文件
        NSFileManager *file_manager = [NSFileManager defaultManager];
        if ([file_manager fileExistsAtPath:[self get_filename:@"DictionaryTemp.caf"]]) {
            CCLOG(@"file is");
//            [[NSFileManager defaultManager] removeItemAtPath:@"DictionaryTemp.caf" error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:[self get_filename:@"DictionaryTemp.caf"] error:nil];

        }
        
        CCLOG(@"-----wordGroup:%@",wordGroup);
//        wordGroupName = [NSString stringWithFormat:@"%@",wordGroup];
        wordGroupName = [[NSString alloc] initWithFormat:@"%@",wordGroup];
        CCSprite *dicBackGround=[CCSprite spriteWithFile:@"BgImagier2.png"];
        self.isTouchEnabled=YES;
        [dicBackGround setPosition:ccp(size.width /2, size.height/2)];
        [dicBackGround setScale:1*scaleXY];
        [self addChild:dicBackGround z:-1];
        
        //word button:image
        tmpPath=[NSString stringWithFormat:@"%@.png",word];
        CCMenuItem *back_word=[CCMenuItemImage itemWithNormalImage:tmpPath selectedImage:tmpPath target:self selector:@selector(playWordName:)];
        back_word.scale = 1*scaleXY;
        back_word.position= ccp(670, 620);
        CCMenu *back_wordP=[CCMenu menuWithItems:back_word, nil];
        back_wordP.position=CGPointZero;
        [self addChild:back_wordP];
        
        
        //Word:name 并去除单词中的下划线
		CCLabelTTF *wordBlankWorld = [CCLabelTTF labelWithString:[SceneTo wordSpace:word] fontName:@"AppleGothic" fontSize:28 ];
        wordBlankWorld.color=ccc3(0, 0, 0);
		wordBlankWorld.position = ccp( 665, 525);
		[self addChild: wordBlankWorld z:3 tag:202];
        
        temp = word;
        
        //wordGroup背景
        CCSprite *wordGroupImage = [CCSprite spriteWithFile:@"BtnDictionary0001.png"];
        wordGroupImage.scale = 1*scaleXY;
        wordGroupImage.position= ccp(115,615);
        [self addChild:wordGroupImage];
        //wordGroup发音
//        NSString *tempGroup = [NSString stringWithFormat:@"%@.png",wordGroup];
        NSString *tempGroup = [[NSString alloc] initWithFormat:@"%@.png",wordGroup];
        CCMenuItem *wordGroup_play=[CCMenuItemImage itemWithNormalImage:tempGroup
                                                          selectedImage:tempGroup
                                                                 target:self
                                                               selector:@selector(playWordGroupName: )];
        
        wordGroup_play.scale = 0.8*scaleXY;
        wordGroup_play.position= ccp(110,615);
        CCMenu *wordGroupP=[CCMenu menuWithItems:wordGroup_play, nil];
        wordGroupP.position=CGPointZero;
        [self addChild:wordGroupP];
        
        
        //return group
        CCMenuItem *return_group=[CCMenuItemImage itemWithNormalImage:@"GroupReturnButton001.png"
                                                     selectedImage:@"GroupReturnButton003.png"
                                                            target:self
                                                          selector:@selector(returnGroupbt: )];
        return_group.scale = 1*scaleXY;
        return_group.position= ccp(989, 35);
        CCMenu *return_group_m=[CCMenu menuWithItems:return_group, nil];
        return_group_m.position=CGPointZero;
        [self addChild:return_group_m];
        
        
        //play machine word
        CCMenuItem *word_play=[CCMenuItemImage itemWithNormalImage:@"BtnPlayDic0001.png"
                                                     selectedImage:@"BtnPlayDic0003.png"
                                                            target:self
                                                          selector:@selector(playWordName: )];
        word_play.scale = 1*scaleXY;
        word_play.position= ccp(95, 365);
        CCMenu *wordP=[CCMenu menuWithItems:word_play, nil];
        wordP.position=CGPointZero;
        [self addChild:wordP];
        
        //play myrecord word
        CCMenuItem *wordMy_play=[CCMenuItemImage itemWithNormalImage:@"BtnPlayMyDic0001.png" selectedImage:@"BtnPlayMyDic0003.png" target:self selector:@selector(startPlayRecordMyword:)];
        wordMy_play.scale = 1*scaleXY;
        wordMy_play.position= ccp(95, 120);
        CCMenu *wordMyP=[CCMenu menuWithItems:wordMy_play, nil];
        wordMyP.position=CGPointZero;
        wordMyP.tag = 101;
        [self addChild:wordMyP];
        
        
        //录音按钮
        CCMenuItem *wordGroup_record=[CCMenuItemImage itemWithNormalImage:@"BtnRecordDic0001.png" selectedImage:@"BtnRecordDic0003.png" target:self selector:@selector(startRecord:)];
        wordGroup_record.scale = 1*scaleXY;
        wordGroup_record.position= ccp(929, 593);
        CCMenu *wordGroupR=[CCMenu menuWithItems:wordGroup_record, nil];
        wordGroupR.position=CGPointZero;
        wordGroupR.tag =102;
        [self addChild:wordGroupR];
        
        //停止录音按钮
        CCMenuItem *wordGroup_RStop=[CCMenuItemImage itemWithNormalImage:@"BtnStopDic0001.png" selectedImage:@"BtnStopDic0003.png" target:self selector:@selector(startRecord:)];
        wordGroup_RStop.scale = 1*scaleXY;
        wordGroup_RStop.position= ccp(929, 593);
        CCMenu *wordGroupRS=[CCMenu menuWithItems:wordGroup_RStop, nil];
        wordGroupRS.position=CGPointZero;
        wordGroupRS.tag =103;
        [self addChild:wordGroupRS];
        wordGroupRS.visible = FALSE;
        
        //读取用户名数据
        //参数介绍：
        //   (NSString *)fileName ：需要读取数据的文件名        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"gameData"];
        NSMutableArray *userData = [[NSMutableArray alloc] initWithContentsOfFile:appFile]; 

        int userCount = 0;
        userCount = [SceneTo userNumberF];
        CCLOG(@"usercount= %d",userCount);
        if (userCount == 0) {
            userCount = [userData count]-4;
            CCLOG(@"usercount    = %d",[userData count]);
            CCLOG(@"usercount now= %d",userCount);
        }
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"loginAll_default.plist"];
        
        //初始化时从最后一个用户开始
        NSString *AccessoryName = [NSString stringWithFormat:@"Accessory%04i.png",[[userData objectAtIndex : userCount +1] intValue]];
        NSString *HeadName = [NSString stringWithFormat:@"Head%04i.png",[[userData objectAtIndex : userCount +2] intValue]];
        NSString *BodyName = [NSString stringWithFormat:@"Body%04i.png",[[userData objectAtIndex : userCount +3] intValue]];
        
        NSLog(@"HeadName? %@",HeadName);
        CCSprite *chAccessory = [CCSprite spriteWithSpriteFrameName:AccessoryName];
        chAccessory.position = ccp(685,202);
        chAccessory.scale = 0.25*scaleXY;
		[self addChild:chAccessory z:2 tag:11];
        
        CCSprite *chHead = [CCSprite spriteWithSpriteFrameName:HeadName];
        chHead.position = ccp(685,200);
        chHead.scale = 0.25*scaleXY;
		[self addChild:chHead z:1 tag:12];
        
        CCSprite *chBody = [CCSprite spriteWithSpriteFrameName:BodyName];
        chBody.position = ccp(701,167);
        chBody.scale = 0.25*scaleXY;
		[self addChild:chBody z:0 tag:13];
        
        
        [userData release];
        
        
        tmpPath=[[NSString alloc] initWithFormat:@"%@_us",temp ];
        //用于原始单词波形显示
        [self scheduleOnce:@selector(waveShow:) delay:1];
        
        //录音控件
        powers = [[NSMutableArray alloc] initWithCapacity:WAVERWL / 2];        
        CGRect frame = CGRectMake(185, 535, 430, 200);
        iRecordsoundSubview = [[UIImageView alloc] initWithFrame: frame];
    }
    return self;
}

-(void)waveShow:(ccTime)dt {
    CGRect frame=CGRectMake(185, 300, 600, 200);
    NSString * tempSoundName = tmpPath;
    wy=[[wyViewWave alloc ]initWithWaveByPathForResoure:tempSoundName Type:@"mp3" Frame:frame Time:0.01 isStatic:YES];
}

//返回Group
-(void) returnGroupbt:(id)sender
{
    //检测是否在录音
    // if we’re currently recording
    if (recorder.recording)
    {
        [timer invalidate]; // stop the timer from generating events
        timer = nil; // set time to nil
        [recorder stop]; // stop recording
        
        // set the category of the current audio session
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    }
    
    //删除波形控件资源
    [wy releaseObject];
    [iRecordsoundSubview removeFromSuperview];
    
    [[CCDirector sharedDirector ] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelB2 scene] withColor:ccBLACK]];
}

//播放单词类名
-(void) playWordGroupName:(id)sender
{
    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];    
    NSString * tmpwordGroup=[NSString stringWithFormat:@"%@_us.mp3",wordGroupName ];
//    [wordGroupName release];
    soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:tmpwordGroup];
}

//播放单词
-(void) playWordName:(id)sender
{
    tmpPath=[NSString stringWithFormat:@"%@_us.mp3",temp ];
    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
    soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:tmpPath];
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =[touches anyObject];
    CGPoint touchPoint=[touch locationInView:[touch view]];
    touchPoint=[[CCDirector sharedDirector] convertToGL:touchPoint];
    CCLOG(@"x=%lf,y=%lf",touchPoint.x,touchPoint.y);
}



-(void) startRecord:(id)sender{
    CCLOG(@"array count:%d",powers.count);
    
    //播放按钮
    CCMenu *wordMyP = (CCMenu *)[self getChildByTag:101];
    //录音按钮
    CCMenu *wordGroupR = (CCMenu *)[self getChildByTag:102];
    //停止录音按钮
    CCMenu *wordGroupRS = (CCMenu *)[self getChildByTag:103];
    
    // if we’re currently recording
    if (recorder.recording)
    {
        wordMyP.isTouchEnabled = TRUE;
        wordGroupR.visible = TRUE;
        wordGroupRS.visible = FALSE;
        
        [timer invalidate]; // stop the timer from generating events
        timer = nil; // set time to nil
        [recorder stop]; // stop recording
        
        // set the category of the current audio session
        [[AVAudioSession sharedInstance] setCategory:
         AVAudioSessionCategorySoloAmbient error:nil];
        

    } // end if
    else
    {
        
        wordMyP.isTouchEnabled = FALSE;
        wordGroupR.visible = FALSE;
        wordGroupRS.visible = TRUE;
        
        
        // set the audio session's category to record
        [[AVAudioSession sharedInstance] setCategory:
         AVAudioSessionCategoryRecord error:nil];
        
        // find the location of the document directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        // get the first directory
        NSString *dir = [paths objectAtIndex:0];
        
        // create a name for the file using the current system time
        //        NSString *filename = [NSString stringWithFormat:@"%f.caf",[[NSDate date] timeIntervalSince1970]];
        NSString *filename = @"DictionaryTemp.caf";        
        NSFileManager *file_manager = [NSFileManager defaultManager];
        //        BOOL ret;
        if ([file_manager fileExistsAtPath:[self get_filename:filename]]) {
            [[NSFileManager defaultManager] removeItemAtPath:[self get_filename:filename] error:nil];
        }
        // create the path using the directory and file name
        NSString *path = [dir stringByAppendingPathComponent:filename];
        
        // create a new NSMutableDictionary for the record settings
        NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
        
        // record using the Apple lossless format
        [settings setValue: [NSNumber numberWithInt:kAudioFormatAppleLossless]
                    forKey:AVFormatIDKey];
        
        // set the sample rate to 44100 Hz
        [settings setValue:[NSNumber numberWithFloat:44100.0]
                    forKey:AVSampleRateKey];
        
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
        [powers removeAllObjects];
        [recorder release]; // release the recorder AVAudioRecorder
        
        // initialize recorder with the URL and settings
        recorder =
        [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path]
                                    settings:settings error:nil];
        [recorder prepareToRecord]; // prepare the recorder to record
        recorder.meteringEnabled = YES; // enable metering for the recorder
        [recorder record]; // start the recording
        
        [settings release];
        // start a timer
        timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self
                                               selector:@selector(displayRecorderWaver:) userInfo:nil repeats:YES];
    } // end else
    
    
    
}

-(void) startPlayRecordMyword:(id)sender{
    CCLOG(@"startPlayRecordMyword___");

    NSString *filename = @"DictionaryTemp.caf";
    
    NSFileManager *file_manager = [NSFileManager defaultManager];
    if ([file_manager fileExistsAtPath:[self get_filename:filename]]) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:filename];
        
        CCLOG(@"appFile:%@",appFile);
        // create a URL with the file's path
        NSURL *url = [NSURL URLWithString:appFile];
        
        if (player) {
            [player release]; // release the player AVAudioPlayer
        }
        
        CCLOG(@"startPlayRecordMyword___01");
        // create a new AVAudioPlayer with the URL
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        [self playRecordSound]; // play the selected recording

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"还没有录音，请点击麦克风按钮进行录音！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    
        
}
// plays the current recording
- (void)playRecordSound
{
    CCLOG(@"playRecordSound___");
    // set the audio session's category to playback
    [[AVAudioSession sharedInstance] setCategory:
     AVAudioSessionCategoryPlayback error:nil];
    [player play]; // play the audio player  
    
} // end method playSound

-(void)displayRecorderWaver:(NSTimer *)timer
{
    [recorder updateMeters]; // sample the recording to get new data
    
    // set the visualizer's average power level
    [self setPower:[recorder averagePowerForChannel:0]];
    
    UIGraphicsEndImageContext();//从当前堆栈中删除quartz 2d绘图环境
    
    CGRect frame = CGRectMake(100, 400, WAVERWL, WAVERHL);
    //
    //    //1------------------
    CGSize size = frame.size;
    UIGraphicsBeginImageContext(size);
    
    // get the current graphics context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CCLOG(@"powers.count:%d",powers.count);
    
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
    
    iRecordsoundSubview.image = nil;
    [iRecordsoundSubview setImage:resultingImage];
    [[[CCDirector sharedDirector] view] addSubview:iRecordsoundSubview];
 
} 

// sets the current power in the recording
- (void)setPower:(float)p
{
    CGRect frame = CGRectMake(400, 400, WAVERWL, WAVERHL);
    [powers addObject:[NSNumber numberWithFloat:p]]; // add value to powers
    
    // while there are enough entries to fill the entire screen
    while (powers.count * 2 > frame.size.width)
        [powers removeObjectAtIndex:0]; // remove the oldest entry
    
    // if the new power is less than the smallest power recorded
    if (p < minPower)
        minPower = p; // update minPower with the new power
} // end method setPower:


-(NSString *)get_filename:(NSString *)name
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
            stringByAppendingPathComponent:name];
}


-(void) dealloc
{
    CCLOG(@"level3 dealloc");
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"loginAll_default.plist"];
    [super dealloc];
}
@end

