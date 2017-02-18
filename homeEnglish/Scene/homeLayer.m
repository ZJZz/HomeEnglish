//
//  homeLayer.m
//  homeiTech
//
//  Created by david zhao on 12-3-21.
//  Copyright (c) 2012年 itech. All rights reserved.
//

// Import the interfaces
#import "homeLayer.h"

#import "hGardenLayer.h"
#import "hGarageLayer.h"
#import "hLivingroomLayer.h"
#import "hKitchenLayer.h"
#import "hLibraryLayer.h"
#import "hBathroomLayer.h"
#import "hBedroomLayer.h"
#import "Summary.h"


#import "SceneTo.h"

#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation homeLayer

//@synthesize moleFrameCountArray;
//@synthesize moleFirstNameArray;

@synthesize hotspotAction = _hotspotAction;

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	homeLayer *layer = [homeLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
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
        
        //Animation frame
        moleFrameCountArray = [[NSArray alloc] initWithObjects:@"20", @"19", @"16" ,@"11",@"14",@"16",@"10",@"17",@"13", nil];
        
        moleFirstNameArray = [[NSArray alloc] initWithObjects:
                              @"hLivingroomAction", 
                              @"hKitchenAction", 
                              @"hGarageAction",
                              @"hGardenAction",
                              @"hLibraryAction",
                              @"hBathroomAction",
                              @"hBedroomAction",
                              @"hAtticAction", 
                              @"hDoorAction", 
                              nil];
        
        molePositonXArray = [[NSArray alloc] initWithObjects:@"243", @"651", @"806" ,@"872",@"681",@"501",@"262",@"285",@"483", nil];
        molePositonYArray = [[NSArray alloc] initWithObjects:@"498", @"516", @"568" ,@"160",@"333",@"280",@"306",@"167",@"481", nil];
        
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Home.mp3"];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.3f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Home.mp3" loop:YES];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"hMainAll.plist"];
        
        [self spriteDalayOnce];
        [self spriteDalayAll];
        [self schedule:@selector(spriteDalayAll) interval:8];

      
        CCSprite *bg = [CCSprite spriteWithFile:@"homemain.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:-1 tag:10];
        

        //读取用户名数据
        //参数介绍：
        //   (NSString *)fileName ：需要读取数据的文件名
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"gameData"];
        NSMutableArray *userData = [[NSMutableArray alloc] initWithContentsOfFile:appFile];
        
//        for (int i=0; i<userData.count; i++) {
//            CCLOG(@"i=%d, %@",i,[NSString stringWithFormat:@"%@",[userData objectAtIndex:i] ]);
//        }
        
        int userCurentIndex= 0;
        userCurentIndex = [userData indexOfObject:[SceneTo fromAPPusername] ];
        CCLOG(@"userCurentIndex= %d",userCurentIndex);

//        CCLOG(@"usercount= %d",userCount);
//        if (userCount == 0) {
//            userCount = [userData count]-4;
//            CCLOG(@"usercount    = %d",[userData count]);
//            CCLOG(@"usercount now= %d",userCount);
//        }
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"loginAll_default.plist"];
        
        //初始化时从最后一个用户开始
        NSString *AccessoryName = [NSString stringWithFormat:@"Accessory%04i.png",[[userData objectAtIndex : userCurentIndex +1] intValue]];
        NSString *HeadName = [NSString stringWithFormat:@"Head%04i.png",[[userData objectAtIndex : userCurentIndex +2] intValue]];
        NSString *BodyName = [NSString stringWithFormat:@"Body%04i.png",[[userData objectAtIndex : userCurentIndex +3] intValue]];
        
        NSLog(@"HeadName? %@",HeadName);
        CCSprite *chAccessory = [CCSprite spriteWithSpriteFrameName:AccessoryName];
        chAccessory.position = ccp(101,132);
        [chAccessory setFlipX:TRUE];
		[self addChild:chAccessory z:2 tag:11];
        
        CCSprite *chHead = [CCSprite spriteWithSpriteFrameName:HeadName];
        chHead.position = ccp(101,130);
        [chHead setFlipX:TRUE];
		[self addChild:chHead z:1 tag:12];
        
        CCSprite *chBody = [CCSprite spriteWithSpriteFrameName:BodyName];
        chBody.position = ccp(85,97);
        [chBody setFlipX:TRUE];
		[self addChild:chBody z:0 tag:13];
        
        [userData release];
        
        chAccessory.scale = 0.25*1;
        chHead.scale = 0.25*1;
        chBody.scale = 0.25*1;
        
        if ([SceneTo uiIpadBack]) {
            scaleXY =2;
            bg.scale = 2;
            chAccessory.scale = 0.25*2;
            chHead.scale = 0.25*2;
            chBody.scale = 0.25*2;
        }else
            scaleXY =1;
        
        //THe sprite had the format file of ipdhd，not to scaleXY.
        CCMenuItem *helpSceneItem=[CCMenuItemImage itemWithNormalImage:@"HelpButton.png"
                                                         selectedImage:@"HelpButton_on.png"
                                                                target:self selector:@selector(helpSceneName:)];
        helpSceneItem.scale = 1*scaleXY;
        helpSceneItem.position= ccp(989, 768-35);
        CCMenu *helpSceneMenu =[CCMenu menuWithItems:helpSceneItem, nil];
        helpSceneMenu.position=CGPointZero;
        [self addChild:helpSceneMenu];
        
        BOOL helpSoundPlayIFONT = TRUE;
        NSMutableArray *OldNameSave =(NSMutableArray*)[SceneTo loadGameData:@"gameLevelData"];
        CCLOG(@"OldNameSave.count home:%d",OldNameSave.count);
        for (int i = 0; i<OldNameSave.count/18; i++) {
            int j=i*18;
            CCLOG(@"i=%d, %@    ,%d,%d,%d,%d,%d,%d,%d,%d",i,
                  [OldNameSave objectAtIndex:j],
                  [[OldNameSave objectAtIndex:j+1] integerValue],
                  [[OldNameSave objectAtIndex:j+2] integerValue],
                  [[OldNameSave objectAtIndex:j+3] integerValue],
                  [[OldNameSave objectAtIndex:j+4] integerValue],
                  [[OldNameSave objectAtIndex:j+5] integerValue],
                  [[OldNameSave objectAtIndex:j+6] integerValue],
                  [[OldNameSave objectAtIndex:j+7] integerValue],
                  [[OldNameSave objectAtIndex:j+8] integerValue]
                  );
            
        }
        userCurentIndex = [OldNameSave indexOfObject:[SceneTo fromAPPusername] ];
        //存储各个关卡数据
        //1         +1      +7      +2          +1          +4      +2            =18
        //username  home    Scene   dictionnry  navigation  Game    Karaok/video
        //Scene:bath    bed garage  garden  kitchen library living
        //      1       2   3       4       5       6       7
        if ([[OldNameSave objectAtIndex:userCurentIndex+1] integerValue]) {
            helpSoundPlayIFONT = FALSE;
        }else{
            [OldNameSave replaceObjectAtIndex:userCurentIndex+1 withObject:[NSMutableString stringWithString:@"1"]];
            [SceneTo saveGameData:OldNameSave saveFileName:@"gameLevelData"];

        }
        
        if (helpSoundPlayIFONT) {
            [self helpSceneNamePlay];
        }

	}
	return self;
}

//Call help
- (void) helpSceneName:(id)sender{
    [self helpSceneNamePlay];
}

//play help sound
-(void)helpSceneNamePlay{
    //判断是否播放的时候这样做
    if (myEffect.isPlaying)
    {
        //正在播放
        [myEffect stop];
    }
    else
    {
        //音效没有播放
        CCLOG(@"play");
        myEffect=[[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"home_help.mp3"] retain];
        [myEffect play];
        
    }
}
//stop help sound
-(void)helpSceneNameStop{
    //判断是否播放的时候这样做
    if (myEffect.isPlaying)
    {
        //正在播放
        [myEffect stop];
    }
}


//初始化11个热点，但是注意有些热点是没有的，需要在if (i!=2 && i!=3 && i!=4)语句时进行屏蔽
-(void)spriteDalayOnce{
    int iCurrent = 0;
    CCSprite *mole[9];
    NSString *tempSpriteName;
    
    for (int i=0; i<9; i++) {
        tempSpriteName = [NSString stringWithFormat:@"%@0001.png",[moleFirstNameArray objectAtIndex:iCurrent]];
        
        mole[i] = [CCSprite spriteWithSpriteFrameName:tempSpriteName];
        
        if ([SceneTo uiIpadBack]) {
            mole[i].scale = 2;
        }
        
        mole[i].anchorPoint = CGPointMake(0, 1);
        mole[i].position = ccp([[molePositonXArray objectAtIndex:iCurrent] integerValue] ,768-[[molePositonYArray objectAtIndex:iCurrent] integerValue]);
        [self addChild:mole[i] z:0 tag:iCurrent+1];
        
        iCurrent++;

        
    }
    
    
    
}

//周期运行11个热点，但是注意有些热点是没有的，需要在if (i!=2 && i!=3 && i!=4)语句时进行屏蔽
-(void)spriteDalayAll{
    
    NSString *frameName;
    CCAnimation *a;
    
    int iCurrent = 0;
    CCSprite *molex[9];
    for (int i=0; i<9; i++) {
        molex[i] =  (CCSprite *)[self getChildByTag:(i+1)];
        [molex[i] stopAllActions];
    }
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (int i=0; i<9; i++) {
        [frames removeAllObjects];
        for (int i = 1; i <= [[moleFrameCountArray objectAtIndex:iCurrent] integerValue]; i++) {
            frameName = [NSString stringWithFormat:@"%@%04i.png",[moleFirstNameArray objectAtIndex:iCurrent],i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
        a.restoreOriginalFrame = YES;
        [molex[i] runAction:[CCAnimate actionWithAnimation:a]];
        
        iCurrent++;
        
    }
    
    [frames release];
    
    
}


//运行动画
//when clicked, Animation
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CCLOG(@"home click:%f  ,%f",location.x,location.y);
    
    [self helpSceneNameStop];
    
    //调用10个热点
    CCSprite *mole[9];
    for (int i =0; i<9; i++) {
        mole[i] =  (CCSprite *)[self getChildByTag:(i+1)]; 
    } 
    
    //获取所有触摸点
    NSSet *allTouches = [event allTouches];
    //当前触摸点数量：单点触控为1，多点触控为2。
    int count = [[allTouches allObjects] count];  
    
    //单点触摸
    if (count==1) {
        //获得第一个触摸点，以判断是单点点击还是单点双击。
        UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];                    
        switch ([touch1 tapCount]) {
                //单点点击
            case 1: 
                
                //播放10个热点动画
                for (int i=0; i<9; i++) {          
                    if (CGRectContainsPoint([mole[i] boundingBox], location)) {
                        [self spriteAnimation:i sprite:mole[i]];
                    }
                } 
                break;
                
            default:
                break;
        }
    }
}


- (void) spriteAnimation:(int)j sprite:(CCSprite *)mole {
    
    CCLOG(@"home j:%d",j);
    self.isTouchEnabled = FALSE;
    [self unschedule:@selector(spriteDalayAll)];

    //播放room声音
    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
    homeRoomSound = [moleFirstNameArray objectAtIndex:j]; 
    homeRoomSound = [[homeRoomSound stringByReplacingOccurrencesOfString :@"Action" withString:@""] substringFromIndex:1];    
    homeRoomSound = [NSString stringWithFormat:@"%@_home.mp3", homeRoomSound];

    CCLOG(@"spriteAnimation homeRoomSound:%@",homeRoomSound);
    soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:homeRoomSound];  
   
    CCLOG(@"spriteAnimation all sprite stop");
    //调用10个热点
    CCSprite *molex[9];
    for (int i =0; i<9; i++) {
        molex[i] =  (CCSprite *)[self getChildByTag:(i+1)];
        [molex[i] stopAllActions];
    }
    CCLOG(@"spriteAnimation sprite animation ");
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (int i = 1; i <= [[moleFrameCountArray objectAtIndex:j] integerValue]; i++) {
        NSString *frameName = [NSString stringWithFormat:@"%@%04i.png",[moleFirstNameArray objectAtIndex:j],i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
    a.restoreOriginalFrame = YES;    
    
    CCCallFunc *endCall = [CCCallFuncND actionWithTarget:self selector:@selector(keepQuiet:data:) data:(void*)j];    
    

    [mole runAction:[CCSequence actions:[CCAnimate actionWithAnimation:a],endCall,nil]];
    
    [frames release]; 
}

-(void) keepQuiet:(id)sender data:(void*)j{
    CCLOG(@"keepQuiet is over,%d",(NSInteger)j);
    
    [self exitSound:(NSInteger)j];
    [SceneTo toSceneScene:(NSInteger)j];
    
}



- (void) exitSound:(int)j{
    
    //播放room声音
    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
    homeRoomSound = [moleFirstNameArray objectAtIndex:j]; 
    homeRoomSound = [[homeRoomSound stringByReplacingOccurrencesOfString :@"Action" withString:@""] substringFromIndex:1];                
    homeRoomSound = [NSString stringWithFormat:@"%@_let_s_us.mp3", homeRoomSound];
    CCLOG(@"homeRoomSound:%@",homeRoomSound); 
    
    [[SimpleAudioEngine sharedEngine] playEffect:homeRoomSound];
    CCLOG(@"homeRoomSound play:");
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    CCLOG(@"homeRoomSound back"); 
    
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)

    
    [moleFirstNameArray release];
    [moleFrameCountArray release];
    [molePositonXArray release];
    [molePositonYArray release];

	
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"hMainAll.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"loginAll_default.plist"];
    
    //释放到目前为止所有加载的图片
    [[CCTextureCache sharedTextureCache] removeAllTextures];


	// don't forget to call "super dealloc"
	[super dealloc];
}
@end


