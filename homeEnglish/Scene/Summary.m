//
//  Summary.m
//  demo
//
//  Created by zzn on 12-11-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Summary.h"
#import "SimpleAudioEngine.h"
#import "imagePointLocation.h"

#import "homeLayer.h"
#import "SceneTo.h"


@implementation Summary
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	Summary *layer = [Summary node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        self.isTouchEnabled=YES;
        RoomName=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                  @"Bedroom", @"240",
                  @"Bathroom", @"230", 
                  @"Garage", @"215", 
                  @"Kitchen", @"225", 
                  @"Livingroom", @"245", 
                  @"Garden", @"220", 
                  @"Library", @"235",nil ];
        Ball_x=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                @"400",@"240",
                @"545",@"230",
                @"813",@"215",
                @"640",@"225",
                @"393",@"245",
                @"675",@"220",
                @"660",@"235",nil];
        Ball_y=[[NSMutableDictionary alloc]initWithObjectsAndKeys:
                @"395",@"240",
                @"395",@"230",
                @"275",@"215",
                @"275",@"225",
                @"275",@"245",
                @"493",@"220",
                @"395",@"235",nil];
        
		// ask director for the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Summary.mp3"];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.5f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Summary.mp3" loop:YES];
        
        CCSprite* HomeBackground=[CCSprite spriteWithFile:@"Summary.png"];
        HomeBackground.anchorPoint=ccp(0,0);
        [self addChild:HomeBackground z:-1];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"SummaryAll.plist"];
        
        CCSprite *menuButton = [CCSprite spriteWithSpriteFrameName:@"homeReturnBt0001.png"];
        menuButton.position = ccp(930,690);
        [self addChild:menuButton z:100];
        menuButton.tag=11;
        
        CCSprite * ball = [CCSprite spriteWithSpriteFrameName:@"BtnBall0001.png"];
        ball.position = ccp(-100, -100);
        ball.scale = 0.8;
        [self addChild:ball z:100];
        ball.tag=12;
        
        if ([SceneTo uiIpadBack]) {
            scaleXY =2;
            HomeBackground.scale = 2;
            menuButton.scale = 2;
            ball.scale = 2;
        }else
            scaleXY =1;
        
        ballOne = TRUE;
        
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


//动画
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    [self helpSceneNameStop];
    
    CCLOG(@"menuButton 01:%0.2f,%0.2f",location.x,location.y);    
    
    CCSprite * menuButton=(CCSprite *)[self getChildByTag:11];
    
    if (CGRectContainsPoint([menuButton boundingBox], location)) {
        CCLOG(@"menuButton 02");
        NSMutableArray *frames = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 3; i++) {
            NSString *frameName = [NSString stringWithFormat:@"homeReturnBt%04i.png",i];
            [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
        }
        CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
        a.restoreOriginalFrame = YES;
        [menuButton runAction:[CCAnimate actionWithAnimation:a] ];
        
        [frames release];
    } 
}

//事件
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CCSprite * menuButton=(CCSprite *)[self getChildByTag:11];
    CCSprite * ball=(CCSprite *)[self getChildByTag:12];
    
    if (CGRectContainsPoint([menuButton boundingBox], location)) {
        CCScene* scene = [homeLayer scene];
        [[CCDirector sharedDirector] replaceScene:scene];       
        //CTransition
        CCTransitionFade* transitionScene = [CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccBLACK];
        [[CCDirector sharedDirector] replaceScene:transitionScene];     
    } 

    int clickColorTemp;
    NSString *imageName = @"SummaryAlpha.png";
    clickColorTemp = [imagePointLocation getPixelColorAtLocation:location secondX:imageName];
    name=[RoomName objectForKey:[NSString stringWithFormat:@"%d",clickColorTemp]];
    
    //点击有效区域，进行事件响应
    if (clickColorTemp != 0 && clickColorTemp != 255) {
        //小球位置        
        
        int ballx=[[Ball_x objectForKey:[NSString stringWithFormat:@"%d",clickColorTemp]]intValue];
        int bally=[[Ball_y objectForKey:[NSString stringWithFormat:@"%d",clickColorTemp]]intValue];   
        CCLOG(@"Ball_x:%d,Ball_y:%d",ballx,bally);
        ball.position = ccp(ballx, bally);

        if (ballOne) {
            ballOne = FALSE;
            
            NSMutableArray *frames = [[NSMutableArray alloc] init];
            for (int i = 1; i <= 3; i++) {
                NSString *frameName = [NSString stringWithFormat:@"BtnBall000%d.png",i];
                [frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName]];
            }
            CCAnimation *a = [CCAnimation animationWithSpriteFrames:frames delay:4.0f/24.0f];
            
            [ball runAction:[CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:a]]];
            [frames release];
        }
        
        //初次初始化背景元素
        if(count==0)
        {
            count=1;
            CCSprite * display=[CCSprite spriteWithFile:@"Mask.png"];
            if ([SceneTo uiIpadBack]) {
                display.scale = 2;
            }
            display.anchorPoint=ccp(0, 0);
            display.position=ccp(0, 0);
            [self addChild:display z:-1];
            
            for(int i=0;i<5;i++)
            {
                CCSprite *video=[CCSprite spriteWithSpriteFrameName:@"Video.png"];
                if ([SceneTo uiIpadBack]) {
                    video.scale = 2;
                }
                video.anchorPoint=ccp(0, 0);
                video.position=ccp(25, 200+110*i);
                [self addChild:video z:0];
                
            }
            for(int i=0;i<4;i++)
            {
                CCSprite *exercice=[CCSprite spriteWithSpriteFrameName:@"Exercice.png"];
                exercice.anchorPoint=ccp(0, 0);
                exercice.position=ccp(55+260*i, 30);
                [self addChild:exercice z:0];
                CCSprite* imageb=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"Bt000%d.png",i+1]];
                if ([SceneTo uiIpadBack]) {
                    exercice.scale = 2;
                    imageb.scale = 2;
                }                
                imageb.anchorPoint=ccp(0, 0);
                imageb.position=ccp(55+259*i, 55);
                [self addChild:imageb z:1];
            }
            
            label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:64];
            label.position=ccp(620, 690);
            label.color=ccc3(0, 0, 0);
            [self addChild:label z:1];
        }
        [label setString:[NSString stringWithFormat:@"The %@",name]];
        
        for(int i=1;i<=5;i++)
        {
            NSString * imagen=[NSString stringWithFormat:@"%@0%d.png",name,i];
            CCSprite * imagev=[CCSprite spriteWithSpriteFrameName:imagen];
            imagev.anchorPoint=ccp(0, 0);
            imagev.position=ccp(35, 105+110*(6-i));
            [self addChild:imagev z:2];
            CCSprite* imaget=[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@kara.png",name]];
            
            imaget.anchorPoint=ccp(0, 0);
            imaget.position=ccp(215, 645);
            imaget.scale = 1;
            [self addChild:imaget z:1];
            
            if ([SceneTo uiIpadBack]) {
                imagev.scale = 2;
                imaget.scale = 2;
            }
        }
        
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.5f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"%@_US.mp3",name] loop:NO];
    }
    
    

}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"SummaryAll.plist"];
	
    [RoomName release];
    [Ball_x release];
    [Ball_y release];

	// don't forget to call "super dealloc"
	[super dealloc];
}


@end
