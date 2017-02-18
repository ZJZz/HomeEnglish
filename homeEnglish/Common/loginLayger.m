//
//  loginLayger.m
//  homeiTech
//
//  Created by david zhao on 12-3-21.
//  Copyright (c) 2012年 itech. All rights reserved.
//

// Import the interfaces
#import "loginLayger.h"
#import "homeLayer.h"
// To use audio with cocos2d seperate headers must be added. In this case I'll go with the SimpleAudioEngine.
#import "SimpleAudioEngine.h"

#import "SceneTo.h"

// loginLayger implementation
@implementation loginLayger

@synthesize chAccessoryCurrent;
@synthesize chHeadCurrent;
@synthesize chBodyCurrent;


+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	loginLayger *layer = [loginLayger node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    chAccessoryCurrent = 1;
    chHeadCurrent = 1;
    chBodyCurrent = 1;
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        //读取用户名数据
        NSMutableArray *userData =(NSMutableArray*)[self loadGameData:@"gameData"];
        userCount = [userData count];
        NSLog(@"userData count：%d",[userData count]);
        BOOL helpSoundPlayIFONT = FALSE;
        //如果文件为空，就给“格式化”
        if(userCount == 0)
        {
            helpSoundPlayIFONT = TRUE;
            //文件格式化
            NSMutableArray *empty  = [[NSMutableArray alloc] init];
            [self saveGameData:empty saveFileName:@"gameData"];
            [self saveGameData:empty saveFileName:@"gameLevelData"];
            NSMutableArray *init = [NSMutableArray arrayWithObjects:@"Name",[NSString stringWithFormat:@"%d",1],[NSString stringWithFormat:@"%d",1],[NSString stringWithFormat:@"%d",1],nil];
            [self saveGameData:init saveFileName:@"gameData"];
            //重新读取
            userData =(NSMutableArray*)[self loadGameData:@"gameData"];
            userCount = [userData count];
            [empty release];
        }
        
        if ([SceneTo uiIpadBack]) {
            scaleXY=2;
        }
        else
            scaleXY=1;
                
        
        self.isTouchEnabled = YES;
		CGSize s = [[CCDirector sharedDirector] winSize];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"loginAll_default.plist"];
        
        CCSprite *loginbg = [CCSprite spriteWithFile:@"identification.png"];
        loginbg.position = ccp(s.width/2, s.height/2);
        [self addChild:loginbg z:-1];
        CCLOG(@"ipad3:@%i",[SceneTo uiIpadBack]);
        
        //button
        CCSprite *btAccessory = [CCSprite spriteWithSpriteFrameName:@"BtnAccessory0001.png"];
        btAccessory.position = ccp(235,530);
		[self addChild:btAccessory z:0 tag:1];
        
        CCSprite *btHead = [CCSprite spriteWithSpriteFrameName:@"BtnHead0001.png"];
        btHead.position = ccp(235,404);
		[self addChild:btHead z:0 tag:2];
        
        CCSprite *btBody = [CCSprite spriteWithSpriteFrameName:@"BtnBody0001.png"];
        btBody.position = ccp(235,280);
		[self addChild:btBody z:0 tag:3];
        
        NSLog(@"userCount? %d",userCount);
        //Character
        //初始化时从最后一个用户开始
        chAccessoryCurrent = [[userData objectAtIndex : userCount - 3] intValue];
        chHeadCurrent = [[userData objectAtIndex : userCount - 2] intValue];
        chBodyCurrent = [[userData objectAtIndex : userCount - 1] intValue];
        
        NSString *AccessoryName = [NSString stringWithFormat:@"Accessory%04i.png",chAccessoryCurrent];
        NSString *HeadName = [NSString stringWithFormat:@"Head%04i.png",chHeadCurrent];
        NSString *BodyName = [NSString stringWithFormat:@"Body%04i.png",chBodyCurrent];
        
        
        
        NSLog(@"HeadName? %@",HeadName);
        CCSprite *chAccessory = [CCSprite spriteWithSpriteFrameName:AccessoryName];
        chAccessory.position = ccp(636,531);
		[self addChild:chAccessory z:2 tag:11];
        
        CCSprite *chHead = [CCSprite spriteWithSpriteFrameName:HeadName];
        chHead.position = ccp(636,526);
		[self addChild:chHead z:1 tag:12];
        
        CCSprite *chBody = [CCSprite spriteWithSpriteFrameName:BodyName];
        chBody.position = ccp(702,382);
		[self addChild:chBody z:0 tag:13];
        
        
        
        //OK button
        CCSprite *btCheckOK = [CCSprite spriteWithSpriteFrameName:@"BtnCheck0001.png"];
        btCheckOK.position = ccp(235, 173);
        [self addChild:btCheckOK z:0 tag:21];
        
        //添加一个新按钮，用来切换人物
        CCSprite *btCheckChange = [CCSprite spriteWithSpriteFrameName:@"BtnScroll0001.png"];
        btCheckChange.position = ccp(s.width*0.445, s.height*0.847);
        [self addChild:btCheckChange z:1 tag:22];
        
        
        CCLOG(@"uiIpadBack:%d",[SceneTo uiIpadBack]);
        loginbg.scale = 1*scaleXY;
        
        btAccessory.scale = 1*scaleXY;
        btHead.scale = 1*scaleXY;
        btBody.scale = 1*scaleXY;
        
        chAccessory.scale = 1*scaleXY;
        chHead.scale = 1*scaleXY;
        chBody.scale = 1*scaleXY;
        
        btCheckOK.scale = 1*scaleXY;
        btCheckChange.scale = 1*scaleXY;

        // text field that uses an image as background (aka "skinning")
        textFieldSkinned = [[UITextField alloc] initWithFrame:CGRectMake(40, 60, 401, 114)];
        //初始化时，从最后一个用户开始
        textFieldSkinned.text = [userData objectAtIndex : userCount - 4 ];
        //        textFieldSkinned.text = @"Name";
        textFieldSkinned.textAlignment = UITextAlignmentCenter;
        textFieldSkinned.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textFieldSkinned.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:(64)];
        textFieldSkinned.adjustsFontSizeToFitWidth = YES;
        textFieldSkinned.delegate = self;
        
        UIView* glView = [[CCDirector sharedDirector] view];
        
        [glView addSubview:textFieldSkinned];
        
        [textFieldSkinned release];
//        [image release];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"btncheck.mp3"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"typein.mp3"];
        
        //THe sprite had the format file of ipdhd，not to scaleXY.
        CCMenuItem *helpSceneItem=[CCMenuItemImage itemWithNormalImage:@"HelpButton.png"
                                                           selectedImage:@"HelpButton_on.png"
                                                                  target:self selector:@selector(helpSceneName:)];
        helpSceneItem.scale = 1*scaleXY;
        helpSceneItem.position= ccp(989, 768-35);
        CCMenu *helpSceneMenu =[CCMenu menuWithItems:helpSceneItem, nil];
        helpSceneMenu.position=CGPointZero;
        [self addChild:helpSceneMenu];
        
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
        myEffect=[[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"login_help.mp3"] retain];
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

-(void)checkSoundState{
    //判断是否播放的时候这样做
    if (myEffect.isPlaying)
    {
        //正在播放
        self.isTouchEnabled=NO;
    }
    else
    {
        //音效没有播放
        self.isTouchEnabled=YES;
        [self unschedule:@selector(checkSoundState)];
        
    }
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    [self helpSceneNameStop];
    
//    CCLOG(@"login－touch position:x:%0.2f,y:%0.2f",location.x,location.y);
    
    CCSprite *btCheckOK = (CCSprite *)[self getChildByTag:21];
    CCSprite *btCheckChange = (CCSprite *)[self getChildByTag:22];
    CCSprite *btAccessory = (CCSprite *)[self getChildByTag:1];
    CCSprite *btHead = (CCSprite *)[self getChildByTag:2];
    CCSprite *btBody = (CCSprite *)[self getChildByTag:3];
    
    
    NSString *frameName;
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    if (CGRectContainsPoint([btCheckOK boundingBox], location)) {
        for (int i = 1; i <= 6; i++) {
            frameName = [NSString stringWithFormat:@"BtnCheck%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
        a.restoreOriginalFrame = YES;
        [btCheckOK runAction:[CCAnimate actionWithAnimation:a]];
        
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"btncheck.mp3"];
    }else if(CGRectContainsPoint([btCheckChange boundingBox], location)){
        for (int i = 1; i <= 3; i++) {
            frameName = [NSString stringWithFormat:@"BtnScroll%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
        a.restoreOriginalFrame = YES;
        [btCheckChange runAction:[CCAnimate actionWithAnimation:a]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"typein.mp3"];
        
    }else if(CGRectContainsPoint([btAccessory boundingBox], location)){
        for (int i = 1; i <= 3; i++) {
            frameName = [NSString stringWithFormat:@"BtnAccessory%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
        a.restoreOriginalFrame = YES;
        [btAccessory runAction:[CCAnimate actionWithAnimation:a]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"typein.mp3"];
        chAccessoryCurrent++;
        if (chAccessoryCurrent==7) {
            chAccessoryCurrent = 1;
        }
//        CCLOG(@"chAccessoryCurrent:%d",chAccessoryCurrent);
    }else if(CGRectContainsPoint([btHead boundingBox], location)){
        for (int i = 1; i <= 3; i++) {
            frameName = [NSString stringWithFormat:@"BtnHead%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
        a.restoreOriginalFrame = YES;
        [btHead runAction:[CCAnimate actionWithAnimation:a]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"typein.mp3"];
        chHeadCurrent++;
        if (chHeadCurrent==6) {
            chHeadCurrent = 1;
        }
//        CCLOG(@"chHeadCurrent:%d",chHeadCurrent);
    }else if(CGRectContainsPoint([btBody boundingBox], location)){
        for (int i = 1; i <= 3; i++) {
            frameName = [NSString stringWithFormat:@"BtnBody%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
        a.restoreOriginalFrame = YES;
        [btBody runAction:[CCAnimate actionWithAnimation:a]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"typein.mp3"];
        chBodyCurrent++;
        if (chBodyCurrent==7) {
            chBodyCurrent = 1;
        }
//        CCLOG(@"chBodyCurrent:%d",chBodyCurrent);
    }
    
    [frames release];
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    //    CCLOG(@"touch happened at", location.x, location.y);
    
    CCSprite *btCheckOK = (CCSprite *)[self getChildByTag:21];
    CCSprite *btCheckChange = (CCSprite *)[self getChildByTag:22];
    CCSprite *btAccessory = (CCSprite *)[self getChildByTag:1];
    CCSprite *btHead = (CCSprite *)[self getChildByTag:2];
    CCSprite *btBody = (CCSprite *)[self getChildByTag:3];
    CCSprite *chAccessory = (CCSprite *)[self getChildByTag:11];
    CCSprite *chHead = (CCSprite *)[self getChildByTag:12];
    CCSprite *chBody = (CCSprite *)[self getChildByTag:13];
    
    //读取用户数据
    NSMutableArray *userData =(NSMutableArray*)[self loadGameData:@"gameData"];
    
    if (CGRectContainsPoint([btCheckOK boundingBox], location)) {
        
        //如果名字不符合要求，弹窗警告
        if(textFieldSkinned.text.length == 0 || [textFieldSkinned.text isEqualToString:@"Name"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"小朋友，先起名字哦~" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else {
            //如果姓名重复，判断是否需更新
            if([userData containsObject:textFieldSkinned.text]) {
                //如果需更新，找到更新的位置--更新
                int iTemp = [userData indexOfObject:textFieldSkinned.text]+1;
                CCLOG(@"iTemp   :%d",iTemp);
                [SceneTo toUserNumberF:iTemp-1];
                if([[userData objectAtIndex:(iTemp)] intValue] != chAccessoryCurrent ||[[userData objectAtIndex:(iTemp+1)] intValue] != chHeadCurrent ||[[userData objectAtIndex:(iTemp+2)] intValue] != chBodyCurrent)
                {
                    [userData replaceObjectAtIndex:(iTemp) withObject:[NSString stringWithFormat:@"%d",chAccessoryCurrent]];
                    [userData replaceObjectAtIndex:(iTemp+1) withObject:[NSString stringWithFormat:@"%d",chHeadCurrent]];
                    [userData replaceObjectAtIndex:(iTemp+2) withObject:[NSString stringWithFormat:@"%d",chBodyCurrent]];
                    [self saveGameData:userData saveFileName:@"gameData"];
                }
            }
            //不需要更新，存储数据
            else {
                //存储各个关卡数据
                //1         +1      +7      +2          +1          +4      +2            =18
                //username  home    Scene   dictionnry  navigation  Game    Karaok/video
                //创建新的数据数组
                NSMutableArray *newNameSave =[[NSMutableArray alloc]init];
                [newNameSave addObject:textFieldSkinned.text];
                for (int i=0; i<17; i++) {
                    [newNameSave addObject:[NSString stringWithFormat:@"%d",0]];
                }
                
                NSMutableArray *OldNameSave =(NSMutableArray*)[self loadGameData:@"gameLevelData"];
                CCLOG(@"OldNameSave.count:%d",OldNameSave.count);
                [OldNameSave addObjectsFromArray:newNameSave];
                
                
                [self saveGameData:OldNameSave saveFileName:@"gameLevelData"];
                
                NSMutableArray *dataSave =
                [NSMutableArray arrayWithObjects:textFieldSkinned.text,
                 [NSString stringWithFormat:@"%d",chAccessoryCurrent],
                 [NSString stringWithFormat:@"%d",chHeadCurrent],
                 [NSString stringWithFormat:@"%d",chBodyCurrent],
                 nil];
                [userData addObjectsFromArray:dataSave];
                [self saveGameData:userData saveFileName:@"gameData"];
                
          
            }
            
            //获取当前用户的name
            [SceneTo toAPPusername:textFieldSkinned.text];
            
            CCScene* scene = [homeLayer scene];
            CCTransitionFade* transitionScene = [CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccBLACK];
            
            //remove textFieldSkinned of UITextField
            [textFieldSkinned removeFromSuperview];
            
            [[CCDirector sharedDirector] replaceScene:transitionScene];
        }
        
        
    }else if(CGRectContainsPoint([btCheckChange boundingBox], location)){
        //设定按键切换的功能
        
        //保证数据循环
        if(userCount == [userData count])
            userCount = 0;
        //设置控件的显示
        textFieldSkinned.text=[userData objectAtIndex:userCount];
        NSString *AccessoryName = [NSString stringWithFormat:@"Accessory%04i.png",[
                                                                                   [userData objectAtIndex:userCount+1]
                                                                                   intValue]];
        NSString *HeadName = [NSString stringWithFormat:@"Head%04i.png",[
                                                                         [userData objectAtIndex:userCount+2]
                                                                         intValue]];
        NSString *BodyName = [NSString stringWithFormat:@"Body%04i.png",[
                                                                         [userData objectAtIndex:userCount+3]
                                                                         intValue]];
        [chAccessory setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:AccessoryName]];
        [chHead setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:HeadName]];
        [chBody setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:BodyName]];
        userCount += 4;//4个数据算为一个用户
        
    }else if(CGRectContainsPoint([btAccessory boundingBox], location)){
        
        NSString *AccessoryName = [NSString stringWithFormat:@"Accessory%04i.png",chAccessoryCurrent];
        [chAccessory setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:AccessoryName]];
    }else if(CGRectContainsPoint([btHead boundingBox], location)){
        
        NSString *HeadName = [NSString stringWithFormat:@"Head%04i.png",chHeadCurrent];
        [chHead setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:HeadName]];
    }else if(CGRectContainsPoint([btBody boundingBox], location)){
        
        NSString *BodyName = [NSString stringWithFormat:@"Body%04i.png",chBodyCurrent];
        [chBody setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:BodyName]];
    }
    
}

//保存游戏数据
//参数介绍：
//   (NSMutableArray *)data ：保存的数据
//   (NSString *)fileName ：存储的文件名
-(BOOL) saveGameData:(NSMutableArray *)data  saveFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}
//读取游戏数据
//参数介绍：
//   (NSString *)fileName ：需要读取数据的文件名
-(id) loadGameData:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *myData = [[[NSMutableArray alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
	// only by calling this method will the keyboard be dismissed when tapping the RETURN key
	[textField resignFirstResponder];
	
	// if the text is empty, remove the text field
	if ([textField.text length] == 0)
	{
		[textField removeFromSuperview];
	}
	
	return YES;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// don't forget to call "super dealloc"
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"loginAll_default.plist"];
    //释放到目前为止所有加载的图片
    [[CCTextureCache sharedTextureCache] removeAllTextures];

	[super dealloc];
}
@end
