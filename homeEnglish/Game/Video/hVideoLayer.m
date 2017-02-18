//
//  hVideoLayer.m
//  homeiTech
//
//  Created by david zhao on 12-3-21.
//  Copyright (c) 2012年 itech. All rights reserved.
//


#import "hVideoLayer.h"
// To use audio with cocos2d seperate headers must be added. In this case I'll go with the SimpleAudioEngine.
#import "SimpleAudioEngine.h"

#import "SceneTo.h"

// hVideoLayer implementation
@implementation hVideoLayer
//@synthesize array;

#define VWIDTH  560
#define VHEIGHT 455

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	hVideoLayer *layer = [hVideoLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer z:0 tag:202];
	
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
        
        arraySpeaker    =[[NSMutableArray alloc]init];
        arrayEnglish    =[[NSMutableArray alloc]init];
        arrayTimeStart  =[[NSMutableArray alloc]init];
        arrayTimeEnd    =[[NSMutableArray alloc]init];
        arraySpeakerAll       =[[NSMutableArray alloc]init];
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        
        fromSceneName = [SceneTo SceneNameF];
        videoCurrentNumber =1;
        videoOneFive = TRUE;
        
        
        //THe sprite had the format file of ipdhd，not to scaleXY. 
        CCMenuItem *returnSceneItem=[CCMenuItemImage itemWithNormalImage:[fromSceneName stringByAppendingString:@"ReturnButton.png"] selectedImage:[fromSceneName stringByAppendingString:@"ReturnButton.png"] target:self selector:@selector(returnSceneName:)];
        returnSceneItem.scale = 1*scaleXY;
        returnSceneItem.position= ccp(989, 35);
        CCMenu *returnSceneMenu =[CCMenu menuWithItems:returnSceneItem, nil];
        returnSceneMenu.position=CGPointZero;
        [self addChild:returnSceneMenu];
        
        rolePositonXArray = [[NSArray alloc] initWithObjects:@"700", @"800", @"900" ,@"700",@"800",@"900", nil];
        rolePositonYArray = [[NSArray alloc] initWithObjects:@"730", @"730", @"730" ,@"625",@"625",@"625", nil];
        
        CCSprite *mole[7];
        
        CCSprite *loginbg = [CCSprite spriteWithFile:@"BGVideo.png"];
        loginbg.position = ccp(s.width/2, s.height/2);
        loginbg.scale = 1*scaleXY;
        [self addChild:loginbg z:-1];
        
        CCSprite *videoCurrent = [CCSprite spriteWithFile:@"Bedroom01.png"];
        [videoCurrent setAnchorPoint:ccp(0,1)];
//        videoCurrent.textureRect=CGRectMake(0, 0, VWIDTH, VHEIGHT);//设置其为宽20，高20.
        videoCurrent.position = ccp((60),(768-62));
        videoCurrent.tag = 80;
        videoCurrent.scaleX = 1.59*scaleXY;
        videoCurrent.scaleY = 1.58*scaleXY;
        [self addChild:videoCurrent z:999];
        
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"VideoAll.plist"];
        
        sunSprite= [CCSprite spriteWithSpriteFrameName:@"Cursor.png"];
        sunSprite.position = ccp(75,220);
        sunSprite.scale = 1*scaleXY;
        [self addChild:sunSprite];
        
        //1. play        
        mole[0] = [CCSprite spriteWithSpriteFrameName:@"homeVideoBtPlay0002.png"];
        mole[0].position = ccp((850),(198));
        mole[0].scale = 1*scaleXY;
        [self addChild:mole[0]];
        mole[0].tag = 101;
        
        //2. stop
        mole[1] = [CCSprite spriteWithSpriteFrameName:@"homeVideoBtStop0001.png"];
        mole[1].position = ccp((850),(198));
        mole[1].scale = 1*scaleXY;
        [self addChild:mole[1]];
        mole[1].tag = 102;
        mole[1].visible = FALSE;
        
        //3.1 one
        mole[2] = [CCSprite spriteWithSpriteFrameName:@"homeVideoOne0003.png"];
        mole[2].position = ccp((870),(90));
        mole[2].scale = 1*scaleXY;
        [self addChild:mole[2]];
        mole[2].tag = 103;
        
        //3.2 Two
        mole[3] = [CCSprite spriteWithSpriteFrameName:@"homeVideoTwo0001.png"];
        mole[3].position = ccp((920),(103));
        mole[3].scale = 1*scaleXY;
        [self addChild:mole[3]];
        mole[3].tag = 104;
        
        //3.3 Three
        mole[4] = [CCSprite spriteWithSpriteFrameName:@"homeVideoThree0001.png"];
        mole[4].position = ccp((970),(125));
        mole[4].scale = 1*scaleXY;
        [self addChild:mole[4]];
        mole[4].tag = 105;
        
        //3.4 Four
        mole[5] = [CCSprite spriteWithSpriteFrameName:@"homeVideoFour0001.png"];
        mole[5].position = ccp((905),(50));
        mole[5].scale = 1*scaleXY;
        [self addChild:mole[5]];
        mole[5].tag = 106;
        
        //3.5 Five
        mole[6] = [CCSprite spriteWithSpriteFrameName:@"homeVideoFive0001.png"];
        mole[6].position = ccp((950),(70));
        mole[6].scale = 1*scaleXY;
        [self addChild:mole[6]];
        mole[6].tag = 107;
        
        
        
        //歌词CCLabelTTF控件
        videoTextLabel = [CCLabelTTF labelWithString:@"" fontName:@"GeezaPro" fontSize:32];
		videoTextLabel.position =  ccp( 390 , 126);
        videoTextLabel.color=ccc3(255, 122, 0);
		[self addChild: videoTextLabel z:1 tag:90];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"btncheck.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"typein.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"gardenm.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"gardenk.mp3"];
        
        //Default to initialize "01" file.
        [self arrayDictionary:@"01"];
	}
	return self;
}



//点击开始实现按钮的动画
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CCSprite *mole[7];
    
    //0:play 1:stop
    for (int i =0; i<7; i++) {
        mole[i] =  (CCSprite *)[self getChildByTag:(i+101)];
    }
    
    //播放Video按钮动画
    for (int i =0; i<7; i++) {
        if (CGRectContainsPoint([mole[i] boundingBox], location)) {
            
            if (videoOneFive) {
                
                //5个按钮
                if ( 1 < i && i < 7 ) {
                    videoCurrentNumber = i-1;
                    
                    CCLOG(@"videoCurrentNumber: %d",videoCurrentNumber);
                    [self spriteAnimation:videoCurrentNumber sprite:mole[i]];
                    
                    //To init information.
                    [self arrayDictionary:[NSString stringWithFormat:@"%@%d", @"0",i-1]];
                }
            }
        }
    }
}

- (void) spriteAnimation:(int)j sprite:(CCSprite *)mole {
    
    CCLOG(@"home j:%d",j);
    NSString * ClickMoleName;
    switch (j) {
        case 1:
            ClickMoleName = @"homeVideoOne";
            break;
        case 2:
            ClickMoleName = @"homeVideoTwo";
            break;
        case 3:
            ClickMoleName = @"homeVideoThree";
            break;
        case 4:
            ClickMoleName = @"homeVideoFour";
            break;
        case 5:
            ClickMoleName = @"homeVideoFive";
            break;
    }
    
    //播放热点动画声音
    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
    soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:@"btncheck.mp3"];
    
    //停止5个Video button动画
    CCSprite *molex[5];
    for (int i =0; i<5; i++) {
        molex[i] =  (CCSprite *)[self getChildByTag:(i+103)];
        [molex[i] stopAllActions];
    }
    //需要更换图片时
    CCSpriteFrame *buttonFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"homeVideoOne0001.png"];
    [molex[0] setDisplayFrame:buttonFrame];
    buttonFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"homeVideoTwo0001.png"];
    [molex[1] setDisplayFrame:buttonFrame];
    buttonFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"homeVideoThree0001.png"];
    [molex[2] setDisplayFrame:buttonFrame];
    buttonFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"homeVideoFour0001.png"];
    [molex[3] setDisplayFrame:buttonFrame];
    buttonFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"homeVideoFive0001.png"];
    [molex[4] setDisplayFrame:buttonFrame];

    
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 3; i++) {
        NSString *frameName = [NSString stringWithFormat:@"%@%04i.png",ClickMoleName ,i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
    a.restoreOriginalFrame = NO;
    [mole runAction:[CCAnimate actionWithAnimation:a]];
    
    [frames release];
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CCLOG(@"x:%f, y:%f",location.x,location.y);
    CCSprite *mole[7];
    
    //0:play 1:stop
    for (int i=0; i<7; i++) {
        mole[i] =  (CCSprite *)[self getChildByTag:(i+101)];
    }
    
    //播放Video
    if (CGRectContainsPoint([mole[0] boundingBox], location)) {
        CCLOG(@"videoOneFive  p-----------");
        if(videoOneFive)
        {
            CCLOG(@"videoOneFive-----------");
            mole[0].visible = FALSE;
            mole[1].visible = TRUE;
            
            for (int i=2; i<7; i++) {
                mole[i].color=ccGRAY;
                videoOneFive = FALSE;
            }
            
            [self playVideo];
            
            //定时器起点
            startCFTime = CFAbsoluteTimeGetCurrent();
            arrayi = 0;
            
        }
        else if (CGRectContainsPoint([mole[1] boundingBox], location))
        {
            CCLOG(@"videoOneFive s-----------");
            [self stopVideo];
            
        }
    }
}


//According to the type of "ini", read the subtitles, Actor, starttime and endtime.
- (void) arrayDictionary:(NSString *) number{
    
    //    NSString *tempxx = @"Bedroom01";
    NSString *tempxx = [(NSString *)fromSceneName stringByAppendingFormat:number];
    
    CCLOG(@"tempxx:%@",tempxx);
    
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:tempxx ofType:@"ini"];
    NSLog(@"lrcPath=%@",lrcPath);
    
    //
    CCSprite *  videoCurrent=(CCSprite *)[self getChildByTag:(80)];
    UIImage * image=[UIImage imageNamed:[(NSString *)tempxx stringByAppendingFormat:@".png"]];
    CCTexture2D  * newTexture=[[CCTextureCache sharedTextureCache]  addCGImage:image.CGImage forKey:nil];
    [videoCurrent  setTexture:newTexture];
    
    NSString *temp;
    NSString *tempTime;
    NSRange range;
    
    [arraySpeaker   removeAllObjects];
    [arrayEnglish   removeAllObjects];
    [arrayTimeStart removeAllObjects];
    [arrayTimeEnd   removeAllObjects];
    [arraySpeakerAll   removeAllObjects];
    
    NSArray * arrayTemp;
    
    NSArray *readline=[[NSString stringWithContentsOfFile:lrcPath] componentsSeparatedByString:@"\n"];
    NSEnumerator *nse=[readline objectEnumerator];
    while(temp=[nse nextObject])
    {
        //        NSLog(@"%@",temp);
        
        range=[temp rangeOfString:@"NamePNG="];//获取位置
        if (range.location!=NSNotFound) {
            [arraySpeakerAll addObject:[self tempstrSub:temp]];
            continue;
        }
        
        range=[temp rangeOfString:@"Speaker#"];//获取位置
        if (range.location!=NSNotFound) {
            [arraySpeaker addObject:[self tempstrSub:temp]];
            continue;
        }
        
        range=[temp rangeOfString:@"EnglishUK#"];//获取位置
        if (range.location!=NSNotFound) {
            [arrayEnglish addObject:[self tempstrSub:temp]];
            continue;
        }
        range=[temp rangeOfString:@"EnglishUS#"];//获取位置
        if (range.location!=NSNotFound) {
            [arrayEnglish addObject:[self tempstrSub:temp]];
            continue;
        }
        
        range=[temp rangeOfString:@"Time#"];//获取位置
        if (range.location!=NSNotFound) {
            arrayTemp = [[self tempstrSub:temp] componentsSeparatedByString:@":"];
            
            int x = ([[arrayTemp objectAtIndex:0] intValue]*60 + [[arrayTemp objectAtIndex:1] intValue]+ 3) * 1000;
            int y = [[arrayTemp objectAtIndex:2] intValue]*10;
            
            tempTime = [NSString stringWithFormat:@"%d", x+y];
            
            [arrayTimeStart addObject:tempTime];
            continue;
        }
        
        range=[temp rangeOfString:@"End#"];//获取位置
        if (range.location!=NSNotFound) {
            tempTime = [NSString stringWithFormat:@"%d", [[self tempstrSub:temp] intValue]*10 + [[arrayTimeStart objectAtIndex:arrayTimeStart.count -1] intValue]];
            [arrayTimeEnd addObject:tempTime ];
            
            continue;
        }
    }
    
    //To display all the roles.
    if ( arraySpeakerAll.count>0 ) {
        CCSprite *role[6];
        
        //When rebuilding the object, to prevent the lost of memory.
        for (int j =0; j<6; j++) {
            role[j] = (CCSprite *)[self getChildByTag: (50+j)];
            if (role[j]) {
                [self removeChild: role[j] cleanup: YES];
            }
        }
        
        NSString *tempstrRole1,*tempstrRole2;
        
        for (int i =0; i<arraySpeakerAll.count; i++) {
            //Delete the last character.
            tempstrRole1 = [arraySpeakerAll objectAtIndex:i];
            tempstrRole2 = [tempstrRole1 substringToIndex:tempstrRole1.length-1];
            
            role[i] = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"homeVideoT%@0001.png",tempstrRole2]];
            
            role[i].anchorPoint = CGPointMake(0, 1);
            role[i].position = ccp([[rolePositonXArray objectAtIndex:i] integerValue] ,[[rolePositonYArray objectAtIndex:i] integerValue]);
            role[i].tag = i+50;
            role[i].scale = 1*scaleXY;
            [self addChild:role[i]];
            
        }
        
    }
    //    for (int i = 0; i<arraySpeaker.count ;i++) {
    //        NSLog(@"i=%d %@zzz",i,[arraySpeaker objectAtIndex:i]);
    //    }
    //
    //    for (int i = 0; i<arrayEnglish.count ;i++) {
    //        NSLog(@"i=%d %@",i,[arrayEnglish objectAtIndex:i]);
    //    }
    //    for (int i = 0; i<arrayTimeStart.count ;i++) {
    //        NSLog(@"i=%d %@",i,[arrayTimeStart objectAtIndex:i]);
    //    }
    //    for (int i = 0; i<arrayTimeEnd.count ;i++) {
    //        NSLog(@"i=%d %@",i,[arrayTimeEnd objectAtIndex:i]);
    //    }
    
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


//Play Video
-(void) playVideo{
    CCLOG(@"playVideo");
    
    NSString *tempxx = [(NSString *)fromSceneName stringByAppendingFormat:[NSString stringWithFormat:@"%@%d",@"0",videoCurrentNumber]];
    
    CCLOG(@"tempxx movie:%@",tempxx);
    
    
    NSString *loc = [[NSBundle mainBundle] pathForResource:tempxx ofType:@"mov"];
    NSURL *urlVideo=[NSURL fileURLWithPath:loc];
    mpControler = [[MPMoviePlayerController alloc] initWithContentURL:urlVideo];
    
    // get the cocos2d view (it's the EAGLView class which inherits from UIView)
    UIView* glView = [[CCDirector sharedDirector] view];
    
    [glView addSubview:mpControler.view];
    
    mpControler.view.frame = CGRectMake(60, 62, VWIDTH, VHEIGHT);
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callbackFunction:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:mpControler];
    
    mpControler.controlStyle = MPMovieControlStyleNone;
    mpControler.repeatMode = MPMovieRepeatModeNone;
    //    self.view.userInteractionEnabled = NO;
    [self schedule:@selector(displayVideoText) interval:0.01];
    [mpControler play];
    
    //计算视频长度
    NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                     forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:urlVideo options:opts]; // 初始化视频媒体文件
    float secondVideo = 0;
    //获取视频总时长,单位秒 NSLog(@"movie duration : %d", second);
    secondVideo = urlAsset.duration.value / urlAsset.duration.timescale;
    // 在X秒内，从节点的当前位置移动到(100, 80)这个位置
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:(int)secondVideo position:CGPointMake(605,220)];
    [moveTo setTag:91];
    [sunSprite runAction:moveTo];
    CCLOG(@"video:%@ ,time:%f",urlVideo, secondVideo);
    
}

-(void) stopVideo{
    CCLOG(@"stopVideo");
    [sunSprite stopActionByTag:91];
    sunSprite.position = ccp(75,220);
    
    CCSprite *mole[7];
    for (int i=0; i<7; i++) {
        mole[i] =  (CCSprite *)[self getChildByTag:(i+101)];
    }
    
    mole[0].visible = TRUE;
    mole[1].visible = FALSE;
    
    
    videoOneFive = TRUE;
    
    for (int i=2; i<7; i++) {
        mole[i].color=ccWHITE;
    }
    
    [mpControler stop];
    [mpControler.view removeFromSuperview];
    //    [mpControler release];
    
    [self unschedule:@selector(displayVideoText)];
    [videoTextLabel setString:@""];
}


//the callback function of the video finished.
-(void) callbackFunction:(NSNotification*)notification {
    CCLOG(@"callbackFunction");
    [self stopVideo];
}


// To display subtitles.
-(void) displayVideoText{
    nowCFTime = CFAbsoluteTimeGetCurrent();
    NSString *objB = [NSString stringWithFormat:@"%0.01f", (double)(nowCFTime - startCFTime)];
    
    int temp =[objB doubleValue] * 1000;
    
    
    // TimeStart <= temp <= TimeEnd
    if (arrayi < [arrayTimeStart count]) {
        if (temp >= [[arrayTimeStart objectAtIndex:arrayi] intValue] && temp >= [[arrayTimeEnd objectAtIndex:arrayi] intValue]) {
            //subtitle
            [videoTextLabel setString:[arrayEnglish objectAtIndex:arrayi ]];
            
            //speaker
            //When rebuilding the object, to prevent the lost of memory.
            CCSprite *role = (CCSprite *)[self getChildByTag:70];
            if (role) {
                [self removeChild: role cleanup: YES];
            }
            
            NSString *tempstrRole1,*tempstrRole2;
            //Delete the last character.
            tempstrRole1 = [arraySpeaker objectAtIndex:arrayi];
            tempstrRole2 = [tempstrRole1 substringToIndex:tempstrRole1.length-1];
            
            role = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"homeVideoT%@0001.png",tempstrRole2]];
            role.anchorPoint = CGPointMake(0, 1);
            role.position = ccp(32,168);
            role.tag = 70;
            role.scale = 1*scaleXY;
            [self addChild:role];
            
            arrayi++;
        }
    }else {
        [self scheduleOnce:@selector(videoTextLabelBlank:) delay:2];
    }
}

-(void) videoTextLabelBlank:(ccTime)dt
{
    [videoTextLabel setString:@""];
}

-(void) backgroundToFrontVideo{
    CCLOG(@"backgroundToFrontVideo+++++++++++ %d",mpControler.playbackState);
    //pause
    if (mpControler.playbackState == 2 ) {
        [mpControler play];
    }
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
    
    //防止转场时，视频在屏幕上显示
    [arraySpeaker   release];
    [arrayEnglish   release];
    [arrayTimeStart release];
    [arrayTimeEnd   release];
    [arraySpeakerAll      release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self stopVideo];
    CCLOG(@"removeMP");
    [mpControler stop];
    [mpControler.view removeFromSuperview];
    [mpControler autorelease];
    
    
    [SceneTo toSceneScene:sceneNumber];
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"VideoAll.plist"];

	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
