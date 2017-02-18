//
//  flashLayger.m
//  homeEnglish
//
//  Created by david zhao on 12-5-18.
//  Copyright 2012年 itech. All rights reserved.
//

#import "flashLayger.h"
#import "loginLayger.h"

#import "SceneTo.h"

#define VHEIGHT 360
#define VWIDTH  480

// flashLayger implementation
@implementation flashLayger

+(CCScene *) scene
{
    // 'scene' is an autorelease object.
    CCScene *scene = [CCScene node];

    // 'layer' is an autorelease object.
    flashLayger *layer = [flashLayger node];

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
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        CCSprite *loginbg = [CCSprite spriteWithFile:@"flashmain.png"];
        loginbg.position = ccp(s.width/2, s.height/2);
        if ([SceneTo uiIpadBack]) {
            loginbg.scale = 2;          
        }
        [self addChild:loginbg z:-1];
            
        [self scheduleOnce:@selector(videoplay:) delay:1];

	}
	return self;
}

-(void) videoplay:(ccTime)dt{
    
    CGSize s = [[CCDirector sharedDirector] winSize];
    //播放视频
    NSString *loc = [[NSBundle mainBundle] pathForResource:@"generique" ofType:@"mov"];
    NSURL *urlVideo=[NSURL fileURLWithPath:loc];
    mpcontrol = [[MPMoviePlayerController alloc] initWithContentURL:urlVideo];
    
    // get the cocos2d view (it's the EAGLView class which inherits from UIView)
//    UIView* glView = [CCDirector sharedDirector].openGLView;
    UIView* glView = [[CCDirector sharedDirector] view];

//    [[CCDirector sharedDirector] view];
    
    [glView addSubview:mpcontrol.view];     
    
    mpcontrol.view.frame = CGRectMake(s.width/2 - VWIDTH/2, s.height/2 - VHEIGHT/2 - 75, VWIDTH, VHEIGHT);	    
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(callbackFunction:)  
                                                 name:MPMoviePlayerPlaybackDidFinishNotification object:mpcontrol];        
    
    mpcontrol.controlStyle = MPMovieControlStyleNone;
    mpcontrol.repeatMode = MPMovieRepeatModeNone;	
    
    [mpcontrol play];
    
}




-(void) callbackFunction:(NSNotification*)notification {
    CCLOG(@"callbackFunction");
    
    [self removeMpcontrol]; 
}

-(void) removeMpcontrol{   
    [[NSNotificationCenter defaultCenter] removeObserver:self     
                                                    name:MPMoviePlayerPlaybackDidFinishNotification     
                                                  object:mpcontrol ]; 
    [mpcontrol stop];    
    [mpcontrol.view removeFromSuperview];     
    [mpcontrol autorelease];
    
    //场景直接切换
    [[CCDirector sharedDirector]replaceScene:[loginLayger scene]];    
}



- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self removeMpcontrol]; 
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    //释放到目前为止所有加载的图片
    [[CCTextureCache sharedTextureCache] removeAllTextures];
	// don't forget to call "super dealloc"
	[super dealloc];
}




@end
