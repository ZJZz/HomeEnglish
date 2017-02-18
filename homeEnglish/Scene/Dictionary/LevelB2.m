//
//  LevelB2.m
//  homeEnglish
//
//  Created by zyq on 12-11-8.
//  Copyright 2012年 itech. All rights reserved.
//

#import "LevelB2.h"
#import "LevelB1.h"
#import "LevelB3.h"
#import "SimpleAudioEngine.h"
#import "SceneTo.h"
//#import "LevelWord.h"

@implementation LevelB2
//@synthesize mWordList,sss;
//@synthesize word;

static NSString *tempParameter;
static int num;
-(void) getRandArrayOfSum:(int) sum Need:(int) need
{
    int rand;
    NSMutableArray *arr=[[NSMutableArray alloc]init ];
    NSMutableArray * result=[[NSMutableArray alloc]init ];
    for (int i=0;i<sum;++i)
        [arr addObject:[NSNumber numberWithInt:i]];
    for (int i=0;i<need;++i)
    {
        //int s=[arr count];
        
        rand=arc4random()%[arr count];
        [result addObject:[arr objectAtIndex:rand]];
        [arr removeObjectAtIndex:rand];
    }
    
    mWordList = result;
    [arr release];
    
}
+(CCScene *)scene
{
    CCScene *scene=[CCScene node];
    LevelB2 *lb1=[LevelB2 node];
    [scene addChild:lb1];
    return scene;
}
+(void) get_flag:(int)n
{
    //CCLOG(@"%d",n);
    num=n;//根据传过来的表记值确定是需要哪个类别的字典的详细内容
}
-(id) init
{
    if((self = [super init]))
    {
        //加载背景图片
        size=[[CCDirector sharedDirector] winSize];
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Dictionnarybg.mp3"];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.3f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Dictionnarybg.mp3" loop:YES];
        
        CCSprite *dicBackGround=[CCSprite spriteWithFile:@"BgImagier1.png"];
        self.isTouchEnabled=YES;
        [dicBackGround setPosition:ccp(size.width/2 , size.height/2)];
        [dicBackGround setScale:1*scaleXY];
        [self addChild:dicBackGround z:0];
        
        CCSprite *returnButton=[CCSprite spriteWithFile:@"DictionaryReturnButton.png"];
        returnButton.anchorPoint = CGPointMake(0, 1);
        [returnButton setPosition:ccp(954, 70)];
        [returnButton setScale:1*scaleXY];
        [self addChild:returnButton z:1 tag:11];
        
        CCMenuItem *pagePre=[CCMenuItemImage itemWithNormalImage:@"pagep1.png" selectedImage:@"pagep2.png" target:self selector:@selector(p1Taped:)];
        pagePre.anchorPoint = CGPointMake(1, 1);
        pagePre.scale = 1*scaleXY;
        pagePre.position= ccp(115, 110);
        CCMenu *preMenu=[CCMenu menuWithItems:pagePre, nil];
        preMenu.position=CGPointZero;
        
        [self addChild:preMenu];
        
        CCMenuItem *pageNex=[CCMenuItemImage itemWithNormalImage:@"pagen1.png" selectedImage:@"pagen2.png" target:self selector:@selector(n1Taped:)];
        pageNex.anchorPoint = CGPointMake(0, 1);
        pageNex.scale = 1*scaleXY;
        pageNex.position= ccp(910, 107);
        CCMenu *nexMenu=[CCMenu menuWithItems:pageNex, nil];
        nexMenu.position=CGPointZero;
        [self addChild:nexMenu];
        [self set_image];
        
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


-(void) p1Taped:(id) sender
{
    if(num==1)
        num=32;
    if(num>1)
    {
        --num;//如果向前翻页，则将类型的数组向前读取一位，这样就可以获取上一个类别的单词组
        for(int i = 0 ;i<8 ;++i)
        {
            for(int j=0 ; j<2 ;++j)
            {
                [self removeChild:word[i*2+j] cleanup:YES];//晴空当前界面的所有图片精灵，以免翻页后出现覆盖的情况。
                [self removeChild:button[i*2+j] cleanup:YES];
            }
        }
        CCLOG(@"%d----=",num);
        [self set_image];
        NSString * ssoundStr=[[NSString alloc] initWithFormat:@"%@_us.mp3",[sss objectAtIndex:16]];//获取翻页后的类别的类单词名，然后播放出来
        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
        soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:ssoundStr];
    }
   // if(num==1)
      //  num=32;//实现循环翻页
}
-(void ) n1Taped:(id) sender
{
    if(num==31)
        num=0;
    if(num<31)
    {
        ++num;
        for(int i = 0 ;i<8 ;++i)
        {
            for(int j=0 ; j<2 ;++j)
            {
                [self removeChild:word[i*2+j] cleanup:YES];
                [self removeChild:button[i*2+j] cleanup:YES];
            }
        }
        [self set_image];
        NSString *ssoundStr=[[NSString alloc] initWithFormat:@"%@_us.mp3",[sss objectAtIndex:16]];
        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
        soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:ssoundStr];
    }
   

}
-(void) set_image
{
    NSString *lrcPath=[[NSBundle mainBundle] pathForResource:@"vocabulary" ofType:@"txt"];//读取txt文件的信息，包含对应的字典的不同类中的各自的单词
    //CCLOG(@"=======%@",lrcPath);
    NSString *textContent = [NSString stringWithContentsOfFile:lrcPath usedEncoding:nil error:nil];
    //CCLOG(@"文件信息 = %@",textContent);
    NSArray * tempArray=[textContent componentsSeparatedByString:@"\n["]; //第一次截取文件内容，每一个字典大类的内容存到数组元素
    //CCLOG(@"%d",[tempArray count]);
    NSArray * temp;
    temp=[[tempArray objectAtIndex:num] componentsSeparatedByString:@"\n"];   //第二次截取文件内容，将点击选择的字典大类中的每行单词分割存到元素中
//    for(int i=0 ;i<[temp count] ;++i)
//        CCLOG(@"%@",[temp objectAtIndex:i]);
    NSString *str;

    CCLOG(@"%d",[temp count]);//输出对应的字典类别中有多少个单词
    int k=4;//文件中从第四行开始是我们需要的单词
//    int sumn=0;
    NSFileManager *fileManager=[NSFileManager defaultManager];
    str=[[NSString alloc] initWithFormat:@"%@", [temp objectAtIndex:k]]; //获取该字典类中的第一个单词
    CCLOG(@"%@",str);
//     NSString *path=[[NSBundle mainBundle] pathForResource:str ofType:@"png"];
    NSString *path;//获取该单词对应的图片的路径

    sss=[[NSMutableArray alloc ] init];//sss数组用于存储文件中可用的图片的文件名，便于随即函数的使用
    for(int i=4; i<[temp count] ;++i)//读取该类字典中的单词涉及的图片名称
   {
         path=[[NSBundle mainBundle] pathForResource: [temp objectAtIndex:i] ofType:@"png"];//将度渠道的单词存储为png格式的文件名
         if([fileManager fileExistsAtPath:path] &&([[temp objectAtIndex:(i-1)] isEqualToString:[temp objectAtIndex:i]]==NO))//如果文件名存在且不重复，则存储到sss
         {
             str=[[NSString alloc] initWithFormat:@"%@", [temp objectAtIndex:i]];
             [sss addObject:str];
          }
    }    
    
    
    for(int i=[sss count] ; i<16;++i)
    {
        [sss addObject:@"FalseText"];//每页字典存储十六张图片，不足时用fasetext补全
    }	
    [sss addObject:[temp objectAtIndex:3]];//增加一张每类字典的类型名称图片，便于返回和翻页朗读
    CGFloat t=195;
//    NSString *st=[[NSString alloc] init];//用于得到单词名称图片的字符串
    NSString *st;//用于得到单词名称图片的字符串

//    NSMutableArray *arr=[[NSMutableArray alloc]init ];
    mWordList =[[NSMutableArray alloc]init];
//    m=[LevelB2 getRandArrayOfSum:16 Need:16];//随即函数，从0到15的数字中打乱后存到m数组中，便可实现随机一个单词放到该类字典的某处。
    [self getRandArrayOfSum:16 Need:16];//随即函数，从0到15的数字中打乱后存到m数组中，便可实现随机一个单词放到该类字典的某处。

//    CCLOG(@"----%d",[mWordList count]);
    for (int i=0; i<[mWordList count]; ++i) {
//        CCLOG(@"===%d",[[mWordList objectAtIndex: i] intValue]);
    }
    
    for(int i=0 ; i<8 ;++i)
    {
        for(int j=0 ; j<2 ;++j)
        {
            if((i*2+j)==6)
            {
                 st=[[NSString alloc] initWithFormat:@"%@.png", [temp objectAtIndex:3]];//将类别的单词图片放到左上角
                //pb[i*2+j]=[CCSprite spriteWithFile:@"BtnWaveSmall0001.png"];
                word[i*2+j]=[CCSprite spriteWithFile:st];
                word[i*2+j].position=ccp((t+j*175),(150+i*170));
                //CCLOG(@"ffffff=====%f",((t+j*175)/1024*size.width));
                [word[i*2+j] setScale:0.85*scaleXY];
                [self addChild:word[i*2+j]];
            }
            else
            {
                if(i<4)
                {
                    int p=[[mWordList objectAtIndex:(i*2+j)] intValue];
                    st=[[NSString alloc] initWithFormat:@"%@.png",[sss objectAtIndex:p]];//将该类中的单词图片每次都随机的放在不同的位置
                    CCLOG(@"%@",st);
                    word[i*2+j]=[CCSprite spriteWithFile:st];
                    word[i*2+j].position=ccp(t+j*175,151+i*169);

                    if(![st isEqualToString:@"FalseText.png"])
                    {
                        pb[i*2+j]=[CCMenuItemImage itemWithNormalImage:@"BtnWaveSmall0001.png" selectedImage:@"BtnWaveSmall0002.png" target:self selector:@selector(ButtonTarged:) ];
                        pb[i*2+j].tag=(i*2+j);
                        pb[i*2+j].scale = 1*scaleXY;
                        //get_count=[[NSString alloc] initWithString:st];
                        pb[i*2+j].position=ccp(120+j*175, 227+i*169);
                        button[i*2+j]=[CCMenu menuWithItems:pb[i*2+j], nil];
                        button[i*2+j].position=CGPointZero;
                        [word[i*2+j] setScale:0.7*scaleXY];
                        [self addChild:button[i*2+j] z:2];
                    }
                    else
                    {
                        [word[i*2+j] setScale:1*scaleXY];
                    }
                    [self addChild:word[i*2+j] z:1];
                }
                else
                {
                    int p=[[mWordList objectAtIndex:(i*2+j)] intValue];
                    st=[[NSString alloc] initWithFormat:@"%@.png",[sss objectAtIndex:p]];
//                    CCLOG(@"%@",st);
                    word[i*2+j]=[CCSprite spriteWithFile:st];
                    word[i*2+j].position=ccp(650+j*175,151+(i-4)*169);
//                    pb[i*2+j]=[CCSprite spriteWithFile:@"BtnWaveSmall0001.png"];
//                    pb[i*2+j].position=ccp(575+j*175, 230+(i-4)*170);
                    if(![st isEqualToString:@"FalseText.png"])
                    {
//                        pb[i*2+j]=[CCMenuItemImage itemFromNormalImage:@"BtnWaveSmall0001.png" selectedImage:@"BtnWaveSmall0002.png" target:self selector:@selector(ButtonTarged:)];
                        pb[i*2+j]=[CCMenuItemImage itemWithNormalImage:@"BtnWaveSmall0001.png" selectedImage:@"BtnWaveSmall0002.png" target:self selector:@selector(ButtonTarged:)];
                        pb[i*2+j].scale = 1*scaleXY;
                        pb[i*2+j].tag=(i*2+j);
                        //get_count=[[NSString alloc] initWithString:st];
                        pb[i*2+j].position=ccp(575+j*175, 227+(i-4)*169);
                        button[i*2+j]=[CCMenu menuWithItems:pb[i*2+j], nil];
                        button[i*2+j].position=CGPointZero;
                        [word[i*2+j] setScale:0.7*scaleXY];
//                        button[i*2+j].scale = 1*scaleXY;
                        [self addChild:button[i*2+j] z:2];
                    //    [self addChild:pb[i*2+j] z:2];
                    }
                    else
                    {
                        [word[i*2+j] setScale:1*scaleXY];
                    }
                    [self addChild:word[i*2+j] z:1];
                }
            }
        }
    }
    
}
-(void)ButtonTarged:(id) sender
{
   // CCLOG(@"!!!!!!!!=%@",get_count);
    get_count=[[mWordList objectAtIndex:[sender tag]] intValue];
//    CCLOG(@"%@",[sss objectAtIndex:get_count]);
    [self scheduleOnce:@selector(makeTransition:) delay:0];


}
-(void) makeTransition:(ccTime) dt
{
    
    CCLOG(@"makeTransition");
    CCLOG(@"tempWord:%@",[sss objectAtIndex:get_count]);
    CCLOG(@"tempGroup:%@",[sss objectAtIndex:16]);

    NSString *temp = [[NSString alloc] initWithFormat:@"%@:%@",[sss objectAtIndex:get_count],[sss objectAtIndex:16]];
    
    tempParameter = temp;
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];

    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelB3 sceneWithWordGroup:tempParameter] withColor:ccBLACK]];
    

    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =[touches anyObject];
    int p;
    int f=0;
    NSString* soundStr;//用于获取每个单词的声音文件名
    CGPoint touchPoint=[touch locationInView:[touch view]];
    touchPoint=[[CCDirector sharedDirector] convertToGL:touchPoint];
    
    [self helpSceneNameStop];
    
    CCSprite *returnButton = (CCSprite *)[self getChildByTag:11];
    if (CGRectContainsPoint([returnButton boundingBox], touchPoint)) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        [[CCDirector sharedDirector ] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[LevelB1 scene] withColor:ccBLACK]];
        
    }
    
    NSSet *allTouches = [event allTouches];
    CCLOG(@"x=%.0f    y=%.0f",touchPoint.x,touchPoint.y);
    switch ([allTouches count]) 
    {
        case 1:
        {
            touch=[[allTouches allObjects] objectAtIndex:0];
            for(int i=0 ; i<8 ;++i)
            {
                for(int j=0 ; j<2; ++j)
                {
                    if(i<4)
                    {
                            if(CGRectContainsPoint(CGRectMake((125+j*175), (75+i*170), 150, 150), touchPoint))
                            {
                                if((i*2+j) ==6)
                                {
                                    //[[CCDirector sharedDirector] replaceScene:[LevelB1 scene]];
                                    f=2;//如果点击的区域为左上角点，则标志位f为2
                                }
                                else
                                {
                                p=[[mWordList objectAtIndex:(i*2+j)] intValue];
                                soundStr=[[NSString alloc] initWithFormat:@"%@_us.mp3",[sss objectAtIndex:p]];
//                                CCLOG(@"%@",soundStr);
                                f=1;//其他可用点击区域标志位为1，并且得到所要播放的单词的文件名
                               // [[SimpleAudioEngine sharedEngine] playEffect:soundStr];
                                }
                            }
                        
                    }
                    else
                    {
                        if(CGRectContainsPoint(CGRectMake((580+j*175), (75+(i-4)*170), 150, 150), touchPoint))
                        {
                            p=[[mWordList objectAtIndex:(i*2+j)] intValue];
                            soundStr=[[NSString alloc] initWithFormat:@"%@_us.mp3",[sss objectAtIndex:p]];
//                            CCLOG(@"%@",soundStr);
                            f=1;
                            //[[SimpleAudioEngine sharedEngine] playEffect:soundStr];
                        }
                    }
                }
            }

            switch ([touch tapCount]) 
            {
                case 1:
                    if(f==1)
                    {                        
                        //如果单击除左上角以外的单词，播放单词。
                        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
                        soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:soundStr];
                        f=0;
                    }
                    if(f==2)
                    {
//                        CCLOG(@"sss:%@",sss);
                        soundStr=[[NSString alloc] initWithFormat:@"%@_us.mp3",[sss objectAtIndex:16]];
                        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];
                        soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:soundStr];

                    }
                    break;
//                case 2:
//                    if(f==1)
//                    {
//                        [[CCDirector sharedDirector] replaceScene:[LevelB3 scene:[sss objectAtIndex:p]]];//如果双击，进入下一层，将选中的单词名传递到下一层。
//                        f=0;
//                    }
//                    if(f==2)
//                    {
//                        [[CCDirector sharedDirector] replaceScene:[LevelB1 scene]];//如果双击左上角区域，回到上一层。
//                    }
//                    break;
            }
        }
            break;
    }
    }
-(void)dealloc
{

    [mWordList release];
    [sss release];
    [super dealloc];
}

@end
