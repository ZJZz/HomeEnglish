//
//  hKitchenLayer.m
//  homeEnglish
//
//  Created by zzn on 12-11-5.
//  Copyright 2012年 itech. All rights reserved.
//
#import "hKitchenLayer.h"
#import "SimpleAudioEngine.h"
#import "homeLayer.h"

#import "SceneTo.h"

@implementation hKitchenLayer
@synthesize wordsKitchen;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	hKitchenLayer *layer = [hKitchenLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		self.isTouchEnabled = YES;        
        
        wordsKitchen = [[NSDictionary alloc] initWithObjectsAndKeys:
                        @"chair",@"252",
                        @"bowl",@"249",
                        @"orange_fruit",@"246",
                        @"pear",@"243",
                        @"glass",@"240",
                        @"fork",@"237",
                        @"spoon",@"234",
                        @"knife",@"231",
                        @"plate",@"228",
                        @"dishwasher",@"225",
                        @"water",@"222",
                        @"tomato",@"219",
                        @"lettuce",@"216",
                        @"sponge",@"213",
                        @"bread",@"210",
                        @"table",@"207",
                        @"coffee",@"204",
                        @"dog",@"201",
                        @"painting",@"198",
                        @"book",@"195",
                        @"flower",@"192",
                        @"tree",@"189",
                        @"carrot",@"186",
                        @"sky",@"183",
                        @"sea",@"180",
                        @"cloud",@"177",
                        nil];
        
        //Animation frame
        moleFrameCountArray = [[NSArray alloc] initWithObjects:@"12", @"16", @"22",@"10",@"12",@"22",@"9",@"8",@"6",@"3", nil];
        //Animation frame name
        moleFirstNameArray = [[NSArray alloc] initWithObjects:
                              @"KitchenAnimMagic",
                              @"KitchenAnimDot",
                              @"KitchenAnimColoriage",
                              @"KitchenAnimStory",
                              @"KitchenAnimOdd",
                              @"KitchenAnimMemory",
                              @"KitchenAnimDifference",
                              @"RemoteAnim",
                              @"MicroAnim",
                              @"homeReturnBt",  
                              nil];
        //Animation Position XY
        molePositonXArray = [[NSArray alloc] initWithObjects:@"858", @"402", @"32" ,@"623",@"870",@"268",@"16",@"551",@"125",@"954", nil];
        molePositonYArray = [[NSArray alloc] initWithObjects:@"768", @"768", @"537" ,@"495",@"362",@"249",@"749",@"160",@"653",@"70", nil];
        
        //Background sound
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Kitchenmainbg.mp3"];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.5f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Kitchenmainbg.mp3" loop:YES];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"Kitchenanimall.plist"];

        
        //Background
        CCSprite *bg = [CCSprite spriteWithFile:@"KitchenMain.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:-1];  
        
        //Animation: 9+1 ClickPoint
        [self spriteDalayOnce];
        [self spriteDalayAll];
        [self schedule:@selector(spriteDalayAll) interval:5];
        
        
        //Word：currentWordSound
        wordSound = [NSString stringWithFormat:@"%@_us.mp3", wordName];        
        //Word：wordBlank
        CCSprite *wordBlank = [CCSprite spriteWithFile:@"blankbg.png"];
        wordBlank.position = ccp(-150,-150);
        [self addChild:wordBlank z:3 tag:100];        
        //Word：wordBlankImage
        CCSprite *wordBlankImage = [CCSprite spriteWithFile:@"orange_fruit.png"];
        wordBlankImage.position = ccp(-150,-150);
        [self addChild:wordBlankImage z:4 tag:101];        
        // Word：name
		CCLabelTTF *wordBlankWorld = [CCLabelTTF labelWithString:@"Hello World" fontName:@"AppleGothic" fontSize:28 ]; 
        wordBlankWorld.color=ccc3(0, 0, 0);
		wordBlankWorld.position =  ccp( -150,-150);
		[self addChild: wordBlankWorld z:3 tag:102];   
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
            bg.scale = 2;
            wordBlank.scale = 2;
            wordBlankImage.scale = 2;
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
        
        [self helpSceneNamePlay];
        
        
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
        myEffect=[[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"Kitchen_help.mp3"] retain];
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
    CCSprite *mole[10];
    NSString *tempSpriteName;
    
    for (int i=0; i<10; i++) {
        if (i!=2 && i!=3 && i!=4) {
            tempSpriteName = [NSString stringWithFormat:@"%@0001.png",[moleFirstNameArray objectAtIndex:iCurrent]];
            
            mole[i] = [CCSprite spriteWithSpriteFrameName:tempSpriteName];
            
            if ([SceneTo uiIpadBack]) {
                mole[i].scale = 2;
            }
            
            mole[i].anchorPoint = CGPointMake(0, 1);
            mole[i].position = ccp([[molePositonXArray objectAtIndex:iCurrent] integerValue] ,[[molePositonYArray objectAtIndex:iCurrent] integerValue]);
            [self addChild:mole[i] z:0 tag:iCurrent+1];
            
            iCurrent++;
        }else{
            iCurrent++;
        }
        
    }
    
    
    
}

//周期运行11个热点，但是注意有些热点是没有的，需要在if (i!=2 && i!=3 && i!=4)语句时进行屏蔽
-(void)spriteDalayAll{
    
    NSString *frameName;
    CCAnimation *a;
    
    int iCurrent = 0;
    CCSprite *molex[10];
    for (int i=0; i<10; i++) {
        molex[i] =  (CCSprite *)[self getChildByTag:(i+1)];
        [molex[i] stopAllActions];
    }
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    for (int i=0; i<10; i++) {
        if (i!=2 && i!=3 && i!=4) {
            
            [frames removeAllObjects];
            for (int i = 1; i <= [[moleFrameCountArray objectAtIndex:iCurrent] integerValue]; i++) {
                frameName = [NSString stringWithFormat:@"%@%04i.png",[moleFirstNameArray objectAtIndex:iCurrent],i];
                [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
            }
            a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
            a.restoreOriginalFrame = YES;
            [molex[i] runAction:[CCAnimate actionWithAnimation:a]];
            
            iCurrent++;
        }else{
            iCurrent++;
        }
        
    }
    
    [frames release];
    
    
}




//事件响应
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    [self helpSceneNameStop];
    
    //调用10个热点
    CCSprite *mole[10];
    for (int i =0; i<10; i++) {
        mole[i] =  (CCSprite *)[self getChildByTag:(i+1)]; 
    } 
    
    //获取所有触摸点
    NSSet *allTouches = [event allTouches];
    //当前触摸点数量：单点触控为1，多点触控为2。
    int count = [[allTouches allObjects] count];    
    
    //返回主界面场景
    if (CGRectContainsPoint([mole[9] boundingBox], location)) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

        
        CCScene* scene = [homeLayer scene];
        [[CCDirector sharedDirector] replaceScene:scene];       
        //CTransition
        CCTransitionFade* transitionScene = [CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccBLACK];
        [[CCDirector sharedDirector] replaceScene:transitionScene];        
        
    }else{
        //单点触摸
        if (count==1) {
            //获得第一个触摸点，以判断是单点点击还是单点双击。
            UITouch *touch1 = [[allTouches allObjects] objectAtIndex:0];
            BOOL tempWordORSpot = TRUE;
            switch ([touch1 tapCount]) {
                    //单点点击
                case 1:
                    //播放10个热点动画
                    for (int i=0; i<10; i++) {
                        if (i!=2 && i!=3 && i!=4) {
                            if (CGRectContainsPoint([mole[i] boundingBox], location)) {
                                tempWordORSpot = FALSE;
                                [self spriteAnimation:i sprite:mole[i]];
                                
                            }
                            
                        }
                    }
                    
                    if (tempWordORSpot) {
                        //播放单词
                        [self playWordSound:location];
                    }
                    break;
                    
                   
                default:
                    break;
            }
        }
    }
}

- (void) spriteAnimation:(int)j sprite:(CCSprite *)mole {    
    
    //播放room声音
    //        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
    //        homeRoomSound = [moleFirstNameArray objectAtIndex:j]; 
    //        homeRoomSound = [[homeRoomSound stringByReplacingOccurrencesOfString :@"Action" withString:@""] substringFromIndex:1];                
    //        homeRoomSound = [NSString stringWithFormat:@"%@.mp3", homeRoomSound];
    //        CCLOG(@"homeRoomSound:%@",homeRoomSound); 
    //        
    //        soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:homeRoomSound];  
    //
    //播放room动画
    
    CCSprite *molex[10];
    for (int i =0; i<10; i++) {
        molex[i] =  (CCSprite *)[self getChildByTag:(i+1)];
        [molex[i] stopAllActions];
    }
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    for (int i = 1; i <= [[moleFrameCountArray objectAtIndex:j] integerValue]; i++) {
        NSString *frameName = [NSString stringWithFormat:@"%@%04i.png",[moleFirstNameArray objectAtIndex:j],i];
        [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
    }
    CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
    a.restoreOriginalFrame = YES;
    [mole runAction:[CCAnimate actionWithAnimation:a ]];
    
    [frames release];
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    [SceneTo toSceneGame:j];    
    
}

//显示单词，并播放单词声音
- (void) playWordSound:(CGPoint)location{
    //判断单词
    int clickColorTemp;
    NSString *imageName = @"KitchenAlpha.png";
    
    clickColorTemp = [imagePointLocation getPixelColorAtLocation:location secondX:imageName];
    
    if ( clickColorTemp != 255 ) {
        NSString *keyString = [NSString stringWithFormat:@"%d", clickColorTemp];
        
        wordName = [wordsKitchen objectForKey:keyString];
        
        if (wordName) {
            [self unschedule:@selector(destory)];
            wordSound = [NSString stringWithFormat:@"%@_us.mp3", wordName]; 
            wordImage = [NSString stringWithFormat:@"%@.png",wordName];
            
            CGPoint wordAndBlankPosition = [SceneTo wordPositonX:location];                
            
            CCLabelTTF *wordBlankWorld = (CCLabelTTF *) [self getChildByTag:102];
            wordBlankWorld.position = ccp( wordAndBlankPosition.x,wordAndBlankPosition.y -BLANKHEIGHT/2 + 40  );
            

            
            CCSprite *wordBlankImage = (CCSprite *)[self getChildByTag:101];                
            CCTexture2D * newTexture=[[CCTextureCache sharedTextureCache] addImage: wordImage];     
            [wordBlankImage  setTexture:newTexture]; 
            wordBlankImage.position = ccp( wordAndBlankPosition.x + 5,wordAndBlankPosition.y+18 );
            
            CCSprite *wordBlank = (CCSprite *) [self getChildByTag:100];
            wordBlank.position = ccp( wordAndBlankPosition.x,wordAndBlankPosition.y );  
            
            [[SimpleAudioEngine sharedEngine] playEffect:[NSString stringWithFormat:@"%@_us.mp3", wordName]];
            
            //解决orange单词重复问题。
            if ([wordName isEqualToString:@"orange_fruit"]) {
                wordName = @"orange";
            }
            
            NSString *temp100 =[wordName stringByReplacingOccurrencesOfString:@"_" withString:@" "];
            wordBlankWorld.string = temp100;
            
            [self schedule:@selector(destoryWord) interval:3];
        }
    }
}

- (void) destoryWord{    
    NSLog(@"destory");
    
    [self getChildByTag:100].position = ccp(-150,-150);
    [self getChildByTag:101].position = ccp(-150,-150);
    [self getChildByTag:102].position = ccp(-150,-150);
    
    [self unschedule:@selector(destoryWord)];
    
    //    [self.parent removeChild:self cleanup:YES];
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    [self unschedule:@selector(spriteDalayAll)];
    
    [moleFrameCountArray release];
    [moleFirstNameArray release];
    [molePositonXArray release];
    [molePositonYArray release];
    
	[wordsKitchen release];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"Kitchenanimall.plist"];

    
    
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end


