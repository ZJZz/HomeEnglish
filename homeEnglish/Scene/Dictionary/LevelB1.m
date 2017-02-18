//
//  LevelB1.m
//  homeEnglish
//
//  Created by zyq on 12-11-8.
//  Copyright 2012年 itech. All rights reserved.
//

#import "LevelB1.h"
#import "LevelB2.h"
#import "SimpleAudioEngine.h"
#import "SceneTo.h"
#import "homeLayer.h"
@implementation LevelB1

@synthesize list,value;
//创建一个scence用于场景的切换
+(CCScene *)scene
{
    CCScene *scene=[CCScene node];
    LevelB1 *lb1=[LevelB1 node];
    [scene addChild:lb1];
    return scene;
}
//初始化
-(id) init
{
    if((self = [super init]))
    {
        
        mySAE=[SimpleAudioEngine sharedEngine];
        //[mySAE preloadEffect:@"myeffect.caf"];
        
        soundPath=0;
        //添加字典的目录图片
        CGSize size=[[CCDirector sharedDirector] winSize];
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Dictionnarybg.mp3"];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.3f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Dictionnarybg.mp3" loop:YES];
        
        CCSprite *dicBackGround=[CCSprite spriteWithFile:@"Imagier1.png"];
        self.isTouchEnabled=YES;
        [dicBackGround setPosition:ccp(size.width /2, size.height/2)];
        [dicBackGround setScale:1*scaleXY];
        [self addChild:dicBackGround z:0];
        
        CCSprite *returnButton=[CCSprite spriteWithFile:@"homeReturnBt0001.png"];
        returnButton.anchorPoint = CGPointMake(0, 1);
//        [returnButton setPosition:ccp(924-77, 100+43)];
        [returnButton setPosition:ccp(954, 70)];
        [returnButton setScale:1*scaleXY];
        [self addChild:returnButton z:1 tag:11];
        
//        [[SimpleAudioEngine sharedEngine] playEffect:@""];
        list=[[NSMutableArray alloc] init];
        //创建点击区域信息，数组array存放字典的目录中31个类别的编号，通过编号访问不同类别包含的单词（每个坐标区域内对应的小图的表记值）
        //int array[31];
        for(int i= 0; i<8 ;++i)
        {
            for(int j=0; j<4; ++j)
            {
                if(i==0 || i==4)
                    array[i*4+j]=(i*4+j+12);
                if(i==1 || i==5)
                    array[i*4+j]=(i*4+j+4);
                if(i==2 || i==6)
                    array[i*4+j]=(i*4+j-4);
                if(i==3 || i==7)
                    array[i*4+j]=(i*4+j-12);
               // CCLOG(@"dddd===%d",array[i*4+j]);
            }
        }
        
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
        myEffect=[[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"DictionaryL1_help.mp3"] retain];
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


//判断点击区域的不同
-(void) get_point:(CGPoint)p
{

    for(int i=0; i<4 ;++i)
    {
        for(int j=0 ;j<4; ++j)
        {
            if((i*4+j)==12)
            {
                
            }
            else
            {
            if(CGRectContainsPoint(CGRectMake(115+j*100, 140+i*160, 90, 90), p))
               {
                   if(soundPath==-1)
                       soundPath=array[i*4+j];
                   else
                   {
                       [LevelB2 get_flag:array[i*4+j]];//调用字典的下一层的函数，既字典的详细内容，将当前点击的是哪个类别的标记传过去
                       [self scheduleOnce:@selector(makeTransition:) delay:2];
                       //[[CCDirector sharedDirector ] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelB2 scene] withColor:ccBLACK]];
                   }
               }
            }
        }
    }
    for(int i=4; i<8 ;++i)
    {
        for(int j=0 ;j<4; ++j)
        {
            if(CGRectContainsPoint(CGRectMake(530+j*100, 140+(i-4)*160, 90, 90), p))
            {
                CCLOG(@"error");
                if(soundPath==-1)
                    soundPath=array[i*4+j];
                else
                {
                [LevelB2 get_flag:array[i*4+j]];//上边是点击左半边区域，这边为点击右半边
               [self scheduleOnce:@selector(makeTransition:) delay:1.5];
                }
            }
        }
    }
}
-(void) makeTransition:(ccTime) dt
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    [[CCDirector sharedDirector ] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelB2 scene] withColor:ccBLACK]];
}
//获取点击坐标
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //CCLOG(@"fuckuuuuuu");
    UITouch *touch =[touches anyObject];
    CGPoint touchPoint=[touch locationInView:[touch view]];
    touchPoint=[[CCDirector sharedDirector] convertToGL:touchPoint];
   // CCLOG(@"x=%.0f    y=%.0f",touchPoint.x,touchPoint.y);
    NSSet *allTouches = [event allTouches];
    
    [self helpSceneNameStop];
    
    CCSprite *returnButton = (CCSprite *)[self getChildByTag:11];
    if (CGRectContainsPoint([returnButton boundingBox], touchPoint)) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        [[CCDirector sharedDirector ] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[homeLayer scene] withColor:ccBLACK]];
        
    }
    
  //  CCLOG(@"tou===%d", [allTouches count]);
    switch ([allTouches count]) 
    {
        case 1:
        {
            touch=[[allTouches allObjects] objectAtIndex:0];
            CCLOG(@"tou===%d", [touch tapCount]);
            switch ([touch tapCount])
            {
                case 1:
                    //[[SimpleAudioEngine sharedEngine] playEffect:@"bear_us.mp3"];
                    soundPath=-1;
                    [self get_point:touchPoint];
                    if(soundPath!=-1)
                    {
                        CCLOG(@"++++++----%d",soundPath);
                        NSString *lrcPath=[[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"txt"];
                        NSString *textContent = [NSString stringWithContentsOfFile:lrcPath usedEncoding:nil error:nil];
                        NSArray * tempArray=[textContent componentsSeparatedByString:@"\n["];
                        NSArray * temp;
                        temp=[[tempArray objectAtIndex:soundPath] componentsSeparatedByString:@"\n"];
//                        NSString *ss=[[NSString alloc] initWithFormat:@"%@_us.mp3",[temp objectAtIndex:3]];
                        NSString *ss = [NSString stringWithFormat:@"%@_us.mp3",[temp objectAtIndex:3]];
                        CCLOG(@"======%@",ss);
                        
                        
                        //[[SimpleAudioEngine sharedEngine] playEffect:ss];
                        
                        myEffect=[[mySAE soundSourceForFile:ss] retain];
                        [myEffect play];
                        
                        [self schedule:@selector(checkSoundState) interval: 0.01];
                        //[self scheduleOnce:@selector(makeTransition:) delay:10];
                        
                
                    }
                    soundPath=-2;
                    [self get_point:touchPoint];
                    break;
//                case 2:         
//                    soundPath=-2;
//                    [self get_point:touchPoint];//获取当前点的坐标，然后根据get—point函数获取该坐标所在的字典类别的标记
//                    break;
            }
            break;
        }
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
-(void)dealloc
{
    

    [list release];
    [value release];
    [super dealloc];
}
@end
