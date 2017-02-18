//
//  MagicSpellLayer.m
//  homeEnglish
//
//  Created by Tony Zhao on 12-10-29.
//  Copyright 2012年 itech. All rights reserved.
//

#import "MagicSpellLayer.h"
#import "SimpleAudioEngine.h"
#import "MagicSpellManagerLevel.h"
#import "CCMenuPopup.h"
#import "PopUp.h"
#import "SceneTo.h"

@implementation MagicSpellLayer


+(CCScene *) sceneWithGround:(NSString *)fromScene
{
	
	CCScene *scene = [CCScene node];
    
//	MagicSpellLayer *layer = [MagicSpellLayer node];    
    MagicSpellLayer *layer = [[[MagicSpellLayer alloc]initWithGround:fromScene]autorelease];
	[scene addChild: layer];
	return scene;
}


//-(id) init
-(id) initWithGround:(NSString *) fromScene
{
    printf("-------进入initWithGround:----------\n");

    if((self=[super init]))
    {
        
//        self.isTouchEnabled=YES;
        
        fromSceneName = fromScene;
       
        
       
            level=[MagicSpellManagerLevel nowLevel];//获取当前关数
            printf("当前的关数 level=%d\n",level);
    

        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        CCLOG(@"scaleXY:%d",scaleXY);
        
        fruitPositionX[0]=260;
        fruitPositionX[1]=450;
        fruitPositionX[2]=628;
        fruitPositionX[3]=805;
        
        fruitPositionY[0]=255;
        fruitPositionY[1]=238;
        fruitPositionY[2]=205;
        fruitPositionY[3]=204;

        
        //设置背景图片
        CGSize size =[[CCDirector sharedDirector] winSize];
        CCSprite *msbg=[CCSprite spriteWithFile:@"MagicSpell.png"];
        msbg.position =ccp(size.width/2, size.height/2);
        msbg.scale = 1*scaleXY;
        [self addChild:msbg z:-1];
        
        CCLOG(@"--------scename:%@",fromSceneName);
        
        //返回按钮
        CCSprite *returnButton = [CCSprite spriteWithFile:[fromSceneName stringByAppendingString:@"ReturnButton.png"]];        
        returnButton.scale = 1*scaleXY;
        returnButton.anchorPoint = CGPointMake(0, 1);
        returnButton.position = ccp(954, 70);
        returnButton.tag = 2011;
        [self addChild:returnButton z:1999];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MagicSpell.mp3"];
        [self customInit];
    }
    printf("-------退出initWithGround:----------\n");
    
    return self;
}

-(void) customInit
{
    printf("----------进入customInit----------\n");
    //初始化
   
    numEat=0;
    spiderHaveOrder=0;
    snakeHaveOrder=0;
    choseTime=0;
    askTime=0;
    choseRight=0;
    count=0;
    snakeRight=0;
    spiderRight=0;
    fruitSound=0;
    clownAskFruitSound=0;
    score=10;
    sceneX = 0;//待传入
    
    if(level<3)
        randomFruitCount = 3;
    else if(level >= 3 && level < 6)
        randomFruitCount = 4;
    
    terminate = NO;
    
    //判断从哪个场景进入为sceneX赋值
    [self fromSceneNameToSceneX:fromSceneName];
    
    
    //显示气球 水果图片 小丑
    [self showBaloon];
    [self showFruitImage];
    [self showClown];
    
    
    //确定蛇和蜘蛛吃东西的顺序
    int r1 = arc4random() % 2;
    
    for (int i=0; i<randomFruitCount; i++)
    {
        snakeWillEat[i]=r1;
        spiderWillEat[i]=!r1;
        r1=!r1;
        
    }
    
    //播放蛇或蜘蛛吃东西的动画
    if(snakeWillEat[0])
    {
        if(terminate == NO)
            [self performSelector:@selector(snakeEatAnimation) withObject:nil afterDelay:1];
    }

    else
    {
        if(terminate == NO)
            [self performSelector:@selector(spiderEatAnimation) withObject:nil afterDelay:1];
    }
          
    if(snakeWillEat[1])
    {
        if(terminate == NO)
            [self performSelector:@selector(snakeEatAnimation) withObject:nil afterDelay:4];
    }
    else
    {
        if(terminate == NO)
            [self performSelector:@selector(spiderEatAnimation) withObject:nil afterDelay:4];
    }   

    
    if(snakeWillEat[2])
    {
        if(terminate == NO)
            [self performSelector:@selector(snakeEatAnimation) withObject:nil afterDelay:6.5];
    }
  
    else
    {
        if(terminate == NO)
            [self performSelector:@selector(spiderEatAnimation) withObject:nil afterDelay:6.5];
    }
    if (randomFruitCount == 4)
    {
        if(snakeWillEat[3])
        {
            if(terminate == NO)
                [self performSelector:@selector(snakeEatAnimation) withObject:nil afterDelay:9.5];
        }
    
        else
        {
            if(terminate == NO)
                [self performSelector:@selector(spiderEatAnimation) withObject:nil afterDelay:9.5];
        }
    }

    printf("----------退出customInit----------\n");
}


#pragma mark -
#pragma mark Show At the First

-(void) randomSelect:(int)numberPlist lessBound:(int)lbound greaterBound:(int)gbound numberOfBaloon:(int)number
{
    printf("----------进入randomSelect----------\n");
    
    int j=0,c=0,a=0,d=0;
    
    int min=0,max=0,numberOfBaloon=0;
    
    min=lbound;
    max=gbound;
    numberOfBaloon=number;
    randomFruitCount=number;
    
    d=numberPlist;
    
    j=0;
    
    for (int k=0; k<numberOfBaloon; k++)
    {
        randomFruit[k]=0;
    }
    
    while(j<numberOfBaloon)
    {
        c=0;
        
        a=arc4random()%d+1;
        for(int i=0;i<numberOfBaloon;i++)
        {
            if(randomFruit[i]==a)
                c=1;
            if (a<min)
                c=1;
            if (a>max)
                c=1;
            
        }
        if(c)
            continue;
        else
        {
            randomFruit[j]=a;
            j++;
        }
    }
    printf("第%d关 选出的图片%d %d %d %d\n",level,randomFruit[0],randomFruit[1],randomFruit[2],randomFruit[3]);
    printf("----------退出randomSelect----------\n");
}

-(void)fromSceneNameToSceneX:(NSString *)name
{
    if ([name isEqualToString:@"Livingroom"] == YES)
        sceneX = 2;
    else if ([name isEqualToString:@"Kitchen"] == YES)
        sceneX = 6;
    else if ([name isEqualToString:@"Garage"] == YES)
        sceneX = 4;
    else if ([name isEqualToString:@"Library"] == YES)
        sceneX = 3;
    else if ([name isEqualToString:@"Bathroom"] == YES)
        sceneX = 5;
    else if ([name isEqualToString:@"Bedroom"] == YES)
        sceneX = 1;
    else if ([name isEqualToString:@"Garden"] == YES)
        sceneX = 0;
}

//显示气球
-(void)showBaloon
{
    printf("----------进入showBaloon------------\n");
    int fruitX[4]={260,450,628,805};
    int fruitY[4]={255,238,205,204};
    
    CCSprite *baloon1=[CCSprite spriteWithFile:@"11Ball.png"];
    baloon1.position =ccp(fruitX[0], fruitY[0]);
    baloon1.scale = 1*scaleXY;
    baloon1.tag=11;
    [self addChild:baloon1];
    
    CCSprite *baloon2=[CCSprite spriteWithFile:@"21Ball.png"];
    baloon2.tag=12;
    baloon2.scale = 1*scaleXY;
    baloon2.position =ccp(fruitX[1], fruitY[1]);
    [self addChild:baloon2];
    
    CCSprite *baloon3=[CCSprite spriteWithFile:@"31Ball.png"];
    baloon3.tag=13;
    baloon3.scale = 1*scaleXY;
    baloon3.position =ccp(fruitX[2], fruitY[2]);
    [self addChild:baloon3];
    
    printf("randomFruitCount = %d\n",randomFruitCount);
    if(randomFruitCount==4)
    {
        CCSprite *baloon4=[CCSprite spriteWithFile:@"41Ball.png"];
        baloon4.tag=14;
        baloon4.scale = 1*scaleXY;
        baloon4.position =ccp(fruitX[3], fruitY[3]);
        [self addChild:baloon4];      
    }
    printf("----------退出showBaloon------------\n");
}

//显示气球上的水果
-(void) showFruitImage
{
    printf("----------进入showFruitImage----------\n");
    printf("Before random select randomFruitCount = %d\n",randomFruitCount);
    NSString * fruit1FrameName = nil;
    NSString * fruit2FrameName = nil;
    NSString * fruit3FrameName = nil;
    NSString * fruit4FrameName = nil;
    
 
    //水果的坐标
    int fruitX[4]={260,450,628,805};
    int fruitY[4]={275,250,245,270};
    int max=0,min=0;
    
    
    //随机生成三个水果的代号并存到b数组中
    if(sceneX==0)
    {
        min=121;
        max=136;
    }
    else if (sceneX==1)
    {
        min=21;
        max=36;
    }
    else if (sceneX==2)
    {
        min=41;
        max=52;
    }
    else if (sceneX==3)
    {
        min=61;
        max=76;
    }
    else if (sceneX==4)
    {
        min=81;
        max=100;
    }
    else if (sceneX==5)
    {
        min=101;
        max=118;
    }
    else if (sceneX==6)
    {
        min=140;
        max=153;
    }
    
    [self whichScence:sceneX];
    
    if (level==1)
    {
        [self randomSelect:max lessBound:min greaterBound:max-5 numberOfBaloon:3];
    }
    else if(level==2)
    {
        [self randomSelect:max lessBound:min+1 greaterBound:max-4 numberOfBaloon:3];
    }
    
    else if(level==3)
    {
        [self randomSelect:max lessBound:min+2 greaterBound:max numberOfBaloon:4];
    }
    else if(level==4)
    {
        [self randomSelect:max lessBound:min+3 greaterBound:max-2 numberOfBaloon:4];
    }
    else if (level==5)
    {
        [self randomSelect:max lessBound:min+2 greaterBound:max-1 numberOfBaloon:4];
    }
    else if (level==6)
    {
        [self randomSelect:max lessBound:min+4 greaterBound:max numberOfBaloon:4];
    }
    
    //在气球上显示水果
    fruit1FrameName=[NSString stringWithFormat:@"%d.png",randomFruit[0]];
    CCSprite *fruit1=[CCSprite spriteWithSpriteFrameName:fruit1FrameName];
    fruit1.zOrder=1;
    fruit1.scale = 0.5*scaleXY;
    
    fruit1.tag=201;
    
    fruit1.position=ccp(fruitX[0], fruitY[0]);
    [self addChild:fruit1];
    
    fruit2FrameName=[NSString stringWithFormat:@"%d.png",randomFruit[1]];
    CCSprite *fruit2=[CCSprite spriteWithSpriteFrameName:fruit2FrameName];
    fruit2.zOrder=1;
    fruit2.scale =0.5*scaleXY;
    
    fruit2.tag=202;
    
    fruit2.position=ccp(fruitX[1], fruitY[1]);
    [self addChild:fruit2];
    
    fruit3FrameName=[NSString stringWithFormat:@"%d.png",randomFruit[2]];
    CCSprite *fruit3=[CCSprite spriteWithSpriteFrameName:fruit3FrameName];
    fruit3.zOrder=1;
    fruit3.scale =0.5*scaleXY;
    
    fruit3.tag=203;
    
    fruit3.position=ccp(fruitX[2], fruitY[2]);
    [self addChild:fruit3];
    
    if(randomFruitCount==4)
    {
        printf("After  random select randomFruitCount = %d\n",randomFruitCount);
//        CCSprite *baloon4=[CCSprite spriteWithFile:@"41Ball.png"];
//        baloon4.tag=14;
//        baloon4.scale = 1*scaleXY;
//        baloon4.position =ccp(805, 204);
//        [self addChild:baloon4];
        
        fruit4FrameName=[NSString stringWithFormat:@"%d.png",randomFruit[3]];
        CCSprite *fruit4=[CCSprite spriteWithSpriteFrameName:fruit4FrameName];
        fruit4.zOrder=1;
        fruit4.scale =0.5*scaleXY;
        
        fruit4.tag=204;
        
        fruit4.position=ccp(fruitX[3], fruitY[3]);
        [self addChild:fruit4];
    }
    
    printf("----------退出showFruitImage----------\n");
}




-(void) whichScence:(int) inScence
{
    
    
    switch (inScence)
    {
        case 0:
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"fruitMagicSpell.plist"];
            break;
        case 1:
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bedroomMagicSpell.plist"];
            break;
        case 2:
             [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"livingroomMagicSpell.plist"];
            break;
        case 3:
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"libraryMagicSpell.plist"];
            break;
        case 4:
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"garageMagicSpell.plist"];
            break;
        case 5:
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"bathroomMagicSpell.plist"];
            break;
        case 6:
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"kitchenMagicSpell.plist"];
            break;
        default:
            break;
    }
    
}

#pragma mark -
#pragma mark Clown

//显示正常的小丑
-(void)showClown
{    
    CCSprite *clownNormal=[CCSprite spriteWithFile:@"clownnormal.png"];
    clownNormal.tag = 99;
    clownNormal.scale = 1*scaleXY;
    clownNormal.position=ccp(910, 100);
    [self addChild:clownNormal];
}



-(void) clownAskForFruit
{
    printf("-----------------进入clownAskForFruit-----------------\n");
    
    
    printf("spiderHave:%d %d\n",spiderHave[0],spiderHave[1]);
    printf("snakeHave:%d %d\n",snakeHave[0],snakeHave[1]);
    
    
    printf("numEat=%d\n",numEat);
    printf("askTime=%d\n",askTime);
    int c,j,i,m;
    j=0;

    
    //先删除正常的小丑图片
    if(askTime==0)
    {
        [self removeChildByTag:99 cleanup:YES];
//        printf("已删除Normal小丑 tag 99\n");
    }

    
    
    //载入哭泣小丑图片
    CCSprite *clownCry=[CCSprite spriteWithFile:@"clowncry.png"];
    clownCry.tag=98;
    clownCry.scale = 1*scaleXY;
//    printf("已创建Cry小丑 tag:%d\n",clownCry.tag);
    clownCry.position=ccp(910, 100);
    [self addChild:clownCry];
    
    //小丑说话气泡
    CCSprite *bubble=[CCSprite spriteWithFile:@"bubbleMS.png"];
    bubble.tag=204;
    bubble.scale = 1*scaleXY;
    bubble.zOrder=2;
    bubble.position=ccp(920, 300);
    [self addChild:bubble];
    
    //小丑随机要的顺序
    while(1)
    {
        c=0;
        
        m=arc4random()%randomFruitCount;
        for(i=0;i<randomFruitCount;i++)
        {
            if(clownorder[i]==m)
                c=1;
        }
        if(c)
            continue;
        else
        {
            clownorder[j]=m;
            j++;
            if(j==randomFruitCount-1)
                break;
        }
    }
    
    printf("小丑要水果的下标 clownorder[0]:%d clownorder[1]:%d clownorder[2]:%d clownorder[3]:%d\n",clownorder[0],clownorder[1],clownorder[2],clownorder[3]);
    
    

    
    //小丑随机水果的图片
    if(askTime==0 && count<randomFruitCount)
    {
//        CCLOG(@"---------------%i,%i",askTime,count);
        [self changeAskFruitImage];
        
    }
    
    
//    printf("小丑要水果的名字 %d\n",randomFruit[clownorder[choseTime]]);
    printf("-----------------退出clownAskForFruit-----------------\n");

}


//选对水果后小丑高兴
-(void) clownHappy
{
    //删除哭小丑
    [self removeChildByTag:98 cleanup:YES];
//    printf("已删除Cry小丑 tag 98\n");
    
    //显示高兴小丑
    
    CCSprite *clownHappy=[CCSprite spriteWithFile:@"clownhappy.png"];
    clownHappy.tag = 97;
//    printf("已创建Happy 小丑 tag:%d\n",clownHappy.tag);
    clownHappy.scale = 1*scaleXY;
    clownHappy.position=ccp(910, 120);
    [self addChild:clownHappy];
    
}





-(void) changeAskFruitImage
{
    printf("-----------进入changeAskFruitImage方法------------------\n");
    NSString *askFruitName;
    
    
    
    
    if(askTime==0)
    {
        printf("askTime=%d\n",askTime);
        askFruitName=[NSString stringWithFormat:@"%d.png",randomFruit[clownorder[askTime]]];
        [self askImageAndSound:askFruitName];
    }
    if (askTime>0 && count<randomFruitCount)
    {
        //删除上一个水果图片
        [self removeChildByTag:(50+askTime)-1 cleanup:YES];
        
        printf("askTime=%d\n",askTime);
        askFruitName=[NSString stringWithFormat:@"%d.png",randomFruit[clownorder[askTime]]];
        [self askImageAndSound:askFruitName];
    }
    
    askTime++;
    printf("执行askTime++后  askTime=%d\n",askTime);
    
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    [super setIsTouchEnabled:YES];
    
    
    printf("-----------退出changeAskFruitImage方法------------------\n");
}

-(void) askImageAndSound:(NSString *)askFruitName
{
    int j;
    j=0;
    CCSprite *askFruit=[CCSprite spriteWithSpriteFrameName:askFruitName];
    
    clownAskFruitSound=randomFruit[clownorder[askTime]];
    //添加声音
    
    for(int i=0;i<randomFruitCount;i++)
    {
        if(snakeHave[i]==randomFruit[clownorder[askTime]])
        {
            j=1;
            break;
        }
    }
    
    if(j)
        [[SimpleAudioEngine sharedEngine] playEffect:@"Can_I_have_the_(ze)_US.mp3"];
    else
        [[SimpleAudioEngine sharedEngine] playEffect:@"Give_me_the_(ze)_US.mp3"];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(clownFruitSound) userInfo:nil repeats:NO];
    
    askFruit.scale=0.5*scaleXY;
    askFruit.zOrder=3;
    askFruit.tag=50+askTime;
    askFruit.position=ccp(920, 310);
    [self addChild:askFruit];
}


#pragma mark -
#pragma mark Animal Animation





-(void) snakeEatAnimation
{
    printf("----------进入snakeEatAnimation------------\n");
    
    if( terminate == YES )
        return;

//    printf("numEat=%d\n",numEat);
    
    CGSize s=[[CCDirector sharedDirector] winSize];
    CCSprite *snake=[CCSprite spriteWithFile:@"longsnake.png"];
    
    snake.scale = 1*scaleXY;
    snake.position=ccp(fruitPositionX[numEat], s.height);
    [self addChild:snake];
    
    id action1=[CCMoveTo actionWithDuration:1 position:ccp(fruitPositionX[numEat],545)];
    id action2=[CCMoveTo actionWithDuration:1.5 position:ccp(fruitPositionX[numEat], s.height+200)];
    [self baloon2Animation];
    
//    printf("被蛇吃的水果 randomFruit[%d] %d\n",numEat,randomFruit[numEat]);
    
    //将被吃的水果给蛇
//    printf("snakeHaveOrder=%d\n",snakeHaveOrder);
    snakeHave[snakeHaveOrder]=randomFruit[numEat];
    fruitSound=randomFruit[numEat];
    [snake runAction:[CCSequence actions:action1,action2,nil]];
    
    //播放声音
    [[SimpleAudioEngine sharedEngine] playEffect:@"MoveSnake.mp3"];
    
    [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(snakeIamEating) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.4 target:self selector:@selector(fruitSound) userInfo:nil repeats:NO];
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(baloonExplode) userInfo:nil repeats:NO];
    
    
    if(numEat==0)
        [self baloon1Animation];
    else if(numEat==1)
        [self baloon2Animation];
    else if(numEat==2)
        [self baloon3Animation];
    else if(numEat==3)
        [self baloon4Animation];
    
    snakeHaveOrder++;
    numEat++;
    
//    printf("执行numEat++后\n numEat=%d\n",numEat);
    
    //吃完后蛇和蜘蛛在屏幕左右上角
    if(numEat==randomFruitCount)
    {
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(afterSpider) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(afterSnake) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(clownAskForFruit) userInfo:nil repeats:NO];
    }

    printf("----------退出snakeEatAnimation------------\n");

}

-(void) spiderEatAnimation
{
    printf("----------进入spiderEatAnimation------------\n");
    if(terminate == YES)
        return;

    
    printf("numEat=%d\n",numEat);
    
    CGSize s=[[CCDirector sharedDirector] winSize];
    CCSprite *spider=[CCSprite spriteWithFile:@"longspider.png"];
    spider.scale = 1*scaleXY;
    spider.position=ccp(fruitPositionX[numEat], s.height+60);
    [self addChild:spider];
    
    id action1=[CCMoveTo actionWithDuration:1 position:ccp(fruitPositionX[numEat], 550)];
    id action2=[CCMoveTo actionWithDuration:1.5 position:ccp(fruitPositionX[numEat], s.height+300)];
    [spider runAction:[CCSequence actions:action1,action2,nil]];
    
    if(numEat==0)
        [self baloon1Animation];
    else if(numEat==1)
        [self baloon2Animation];
    else if(numEat==2)
        [self baloon3Animation];
    else if(numEat==3)
        [self baloon4Animation];
    
    
    
    
    //播放声音
    [[SimpleAudioEngine sharedEngine] playEffect:@"MoveSpider.mp3"];
     [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(spiderIamTaking) userInfo:nil repeats:NO];
     [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(fruitSound) userInfo:nil repeats:NO];
     [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(baloonExplode) userInfo:nil repeats:NO];
    
    printf("被蜘蛛吃的水果 randomFruit[%d] %d\n",numEat,randomFruit[numEat]);
    
    //将被吃的水果给蜘蛛
    printf("spiderHaveOrder=%d\n",spiderHaveOrder);
    
    spiderHave[spiderHaveOrder]=randomFruit[numEat];
    fruitSound=randomFruit[numEat];
    
    numEat++;
    spiderHaveOrder++;
    
    printf("执行numEat++后\n numEat=%d\n",numEat);
    
    //吃完后蛇和蜘蛛在屏幕左右上角
    if(numEat==randomFruitCount)
    {
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(afterSpider) userInfo:nil repeats:NO];
        [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(afterSnake) userInfo:nil repeats:NO];

        [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(clownAskForFruit) userInfo:nil repeats:NO];
    }

    printf("----------退出spiderEatAnimation------------\n");

}




#pragma mark -
#pragma mark Baloon Animation
    
-(void) baloon1Animation
{
    if(numEat==0)
    {
        [self removeChildByTag:11 cleanup:YES];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"baloon1MS.plist"];
    
        CCSprite *baloon1 =[CCSprite spriteWithSpriteFrameName:@"baloon_1.png"];
        baloon1.tag=71;
        baloon1.scale = 1*scaleXY;
        baloon1.position=ccp(260,255);
        [self addChild:baloon1];
    
        NSMutableArray *baloon1Frames=[[NSMutableArray alloc] init];
        NSString *snakeFrameName;
    
        for (int i=1; i<=3; i++)
        {
            snakeFrameName=[NSString stringWithFormat:@"baloon_%d.png",i];
            [baloon1Frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:snakeFrameName]];
        }
    
        CCAnimation *a=[CCAnimation animationWithSpriteFrames:baloon1Frames delay:4.5f/24.0f];
        [baloon1 runAction:[CCAnimate actionWithDuration:3 animation:a restoreOriginalFrame:NO]];

        [baloon1Frames release];
    }
}

-(void) baloon2Animation
{
    if(numEat==1)
    {
        [self removeChildByTag:12 cleanup:YES];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"baloon2MS.plist"];
    
        CCSprite *baloon2 =[CCSprite spriteWithSpriteFrameName:@"baloon2_1.png"];
        baloon2.tag=72;
        baloon2.scale = 1*scaleXY;
        baloon2.position=ccp(450,238);
        [self addChild:baloon2];
    
        NSMutableArray *baloon2Frames=[[NSMutableArray alloc] init];
        NSString *snakeFrameName;
    
        for (int i=1; i<=3; i++)
        {
            snakeFrameName=[NSString stringWithFormat:@"baloon2_%d.png",i];
            [baloon2Frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:snakeFrameName]];
        }
    
        CCAnimation *a=[CCAnimation animationWithSpriteFrames:baloon2Frames delay:4.5f/24.0f];
        [baloon2 runAction:[CCAnimate actionWithDuration:3 animation:a restoreOriginalFrame:NO]];
        
        [baloon2Frames release];


    }
}

-(void) baloon3Animation
{
    if(numEat==2)
    {
        [self removeChildByTag:13 cleanup:YES];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"baloon3MS.plist"];
    
        CCSprite *baloon3 =[CCSprite spriteWithSpriteFrameName:@"baloon3_1.png"];
        baloon3.tag=73;
        baloon3.scale = 1*scaleXY;
        baloon3.position=ccp(628,205);
        [self addChild:baloon3];
    
        NSMutableArray *baloon3Frames=[[NSMutableArray alloc] init];
        NSString *snakeFrameName;
    
        for (int i=1; i<=3; i++)
        {
            snakeFrameName=[NSString stringWithFormat:@"baloon3_%d.png",i];
            [baloon3Frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:snakeFrameName]];
        }
    
        CCAnimation *a=[CCAnimation animationWithSpriteFrames:baloon3Frames delay:4.5f/24.0f];
        [baloon3 runAction:[CCAnimate actionWithDuration:3 animation:a restoreOriginalFrame:NO]];
        [baloon3Frames release];
    }
}

-(void) baloon4Animation
{
    if(numEat==3)
    {
        [self removeChildByTag:14 cleanup:YES];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"baloon4MS.plist"];
    
        CCSprite *baloon4 =[CCSprite spriteWithSpriteFrameName:@"baloon4_1.png"];
        baloon4.scale = 1*scaleXY;
        baloon4.position=ccp(805,204);
        [self addChild:baloon4];
    
        NSMutableArray *baloon4Frames=[[NSMutableArray alloc] init];
        NSString *snakeFrameName;
    
        for (int i=1; i<=3; i++)
        {
            snakeFrameName=[NSString stringWithFormat:@"baloon4_%d.png",i];
            [baloon4Frames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:snakeFrameName]];
        }
    
        CCAnimation *a=[CCAnimation animationWithSpriteFrames:baloon4Frames delay:4.5f/24.0f];
        [baloon4 runAction:[CCAnimate actionWithDuration:3 animation:a restoreOriginalFrame:NO]];
        
        [baloon4Frames release];
    }
}


-(void) blowBaloonAnimation:(int) where
{    
    CCLOG(@"========blowBaloonAnimation========");
   [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"blowbaloonMS.plist"];
    CCSprite *blowbaloon =[CCSprite spriteWithSpriteFrameName:@"blowbaloon_1.png"];

    blowbaloon.tag=(40+choseTime);
    blowbaloon.scale=0.5*scaleXY;
    if(spiderRight)
        blowbaloon.position=ccp(140,570);
    else if (snakeRight)
        blowbaloon.position=ccp(790, 590);
    [self addChild:blowbaloon];
    NSMutableArray *blowBaloonFrames=[[NSMutableArray alloc] init];
    
    NSString *snakeFrameName;
    for (int i=1; i<=4; i++)
    {
        snakeFrameName=[NSString stringWithFormat:@"blowbaloon_%d.png",i];
        [blowBaloonFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:snakeFrameName]];
    }
    
    CCAnimation *a=[CCAnimation animationWithSpriteFrames:blowBaloonFrames delay:4.5f/24.0f];
    a.restoreOriginalFrame = YES; 
    
    CCCallFunc *endCall = [CCCallFuncND actionWithTarget:self selector:@selector(restoreBaloon:data:) data:(void*)where];
    
    [blowbaloon runAction:[CCSequence actions:[CCAnimate actionWithAnimation:a],endCall,nil]];
    
    [self performSelector:@selector(deleteBlowBaloon) withObject:nil afterDelay:1];
    
}

-(void) deleteBlowBaloon
{
    CCLOG(@"========deleteBlowBaloon========");

//    printf("choseTime %d\n",choseTime);
    if((choseTime-1)==0)
        [self removeChildByTag:40 cleanup:YES];
    else if((choseTime-1)==1)
        [self removeChildByTag:41 cleanup:YES];
    else if((choseTime-1)==2)
        [self removeChildByTag:42 cleanup:YES];
    else if((choseTime-1)==3)
        [self removeChildByTag:43 cleanup:YES];
}


//-(void) restoreBaloon:(int) where
-(void) restoreBaloon:(id)sender data:(void*)whereid
{
    int where = (int)whereid;
    
    CCLOG(@"========restoreBaloon========");
    if(where==0)
    {
        [self removeChildByTag:71 cleanup:YES];
        CCSprite *originalBaloon=[CCSprite spriteWithFile:@"originalbaloon1.png"];
        originalBaloon.tag=205;
        originalBaloon.scale = 1*scaleXY;
        originalBaloon.position=ccp(260, 255);
        [self addChild:originalBaloon];
    }
    else if(where==1)
    {
         [self removeChildByTag:72 cleanup:YES];
        CCSprite *originalBaloon=[CCSprite spriteWithFile:@"originalbaloon2.png"];
        originalBaloon.tag=206;
        originalBaloon.scale = 1*scaleXY;
        originalBaloon.position=ccp(450, 238);
        [self addChild:originalBaloon];
    }
    else if(where==2)
    {
        [self removeChildByTag:73 cleanup:YES];

        CCSprite *originalBaloon=[CCSprite spriteWithFile:@"originalbaloon3.png"];
        originalBaloon.tag=207;
        originalBaloon.scale = 1*scaleXY;
        originalBaloon.position=ccp(628, 205);
        [self addChild:originalBaloon];
    }
    else if(where==3)
    {
        [self removeChildByTag:74 cleanup:YES];
        
        CCSprite *originalBaloon=[CCSprite spriteWithFile:@"originalbaloon4.png"];
        originalBaloon.tag=208;
        originalBaloon.scale = 1*scaleXY;
        originalBaloon.position=ccp(805, 204);
        [self addChild:originalBaloon];
    }
}


#pragma mark -
#pragma mark After Animation

-(void) afterSpider
{
    CCSprite *afterSpider=[CCSprite spriteWithFile:@"afterspider.png"];
    afterSpider.tag=1;
    afterSpider.scale = 1*scaleXY;
    afterSpider.position=ccp(150, 690);
    [self addChild:afterSpider];

}

-(void)afterSnake
{
    CGSize s=[[CCDirector sharedDirector] winSize];
    CCSprite *afterSpider=[CCSprite spriteWithFile:@"aftersnake.png"];
    afterSpider.tag=2;
    afterSpider.scale = 1*scaleXY;
    afterSpider.position=ccp(890,s.height+100);
    [self addChild:afterSpider];
}


#pragma mark -
#pragma mark Touch Animal

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event 
{
    printf("----------进入ccTouchesBegan方法----------\n");
    printf("count=%d\n",count);
//    int whereBaloon;//那个气球被恢复
//    
//    snakeRight=0;
//    spiderRight=0;

    
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    //back
    CCSprite *returnButton = (CCSprite *)[self getChildByTag:2011];
    if (CGRectContainsPoint([returnButton boundingBox], location)) {
        printf("************Push return Button***************\n");
        
        terminate = YES;
        
        NSArray *sceneNameArray = [[NSArray alloc] initWithObjects:
                                   @"Livingroom",
                                   @"Kitchen",
                                   @"Garage",
                                   @"Garden",
                                   @"Library",
                                   @"Bathroom",
                                   @"Bedroom",
                                   nil];
        int sceneNumber = [sceneNameArray indexOfObject:fromSceneName ];
        [sceneNameArray release];
        
        
        [SceneTo toSceneScene:sceneNumber];
        
        [MagicSpellManagerLevel playFromStart];
       
    }
    

 
    printf("----------退出ccTouchesBegan方法----------\n");    
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    printf("----------进入ccTouchesEnded方法----------\n");
    
    UITouch *touch =[touches anyObject];
    CGPoint location =[touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    
    printf("count=%d\n",count);
    int whereBaloon;//那个气球被恢复
    
    snakeRight=0;
    spiderRight=0;
    
    
    CCSprite *animal[2];
    
    for(int i=1;i<=2;i++)
    {
        animal[i]=(CCSprite *)[self getChildByTag:i];
    }
    
    
    //如果是蛇
    if(CGRectContainsPoint([animal[2] boundingBox],location))
    {
        printf("选蛇\n");
        //can i have
        CCSprite *sentence1=[CCSprite spriteWithFile:@"CanIHaveThe.png"];
        sentence1.tag=701;
        sentence1.scale = 1*scaleXY;
        sentence1.position=ccp(650, 670);
        [self addChild:sentence1];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeCanIHave) userInfo:nil repeats:NO];
        
        for (int k=0;k<4; k++)//根据小丑要水果的次序搜索蛇数组
        {
            
            if(snakeHave[k]==randomFruit[clownorder[choseTime]])
            {
                choseRight=1;
                break;
            }
            else
                choseRight=0;
        }
        
        if(choseRight==1)
        {
            
            [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
            [super setIsTouchEnabled:NO];
            
            snakeRight=1;
            
            
            //找到水果在哪个位置
            for(int h=0;h<=3;h++)
            {
                if(randomFruit[h]==randomFruit[clownorder[choseTime]])
                {
                    whereBaloon=h;
                    
                }
            }
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"Here_you_are_US.mp3"];
            [self blowBaloonAnimation:whereBaloon];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(blownBaloonSound) userInfo:nil repeats:NO];
            
            //                [self restoreBaloon:whereBaloon];
            
            //延时换图片
            if(count<randomFruitCount)
            {
                printf("执行count++前 count=%d\n",count);
                [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(changeAskFruitImage) userInfo:nil repeats:NO];
            }
            
            
            choseTime++;
            count++;
            printf("执行count++后 count=%d\n",count);
        }
        else
            score--;
        
        
    }
    
    //如果是蜘蛛
    else if(CGRectContainsPoint([animal[1] boundingBox],location))
    {
        printf("选蜘蛛\n");
        
        CCSprite *sentence2=[CCSprite spriteWithFile:@"GiveMeThe.png"];
        sentence2.tag=702;
        sentence2.scale = 1*scaleXY;
        sentence2.position=ccp(350, 650);
        [self addChild:sentence2];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(removeGiveMeThe) userInfo:nil repeats:NO];
        
        for(int l=0;l<4;l++)
        {
            
            if(spiderHave[l]==randomFruit[clownorder[choseTime]])
            {
                choseRight=1;
                break;
            }
            else
                choseRight=0;
        }
        
        if(choseRight==1)
        {
            [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
            [super setIsTouchEnabled:NO];
            
            spiderRight=1;
            
            //找到水果在哪个位置
            
            for(int h=0;h<=3;h++)
            {
                if(randomFruit[h]==randomFruit[clownorder[choseTime]])
                {
                    whereBaloon=h;
                    
                }
            }
            
            [[SimpleAudioEngine sharedEngine] playEffect:@"Take_it_US.mp3"];
            [self blowBaloonAnimation:whereBaloon];
            
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(blownBaloonSound) userInfo:nil repeats:NO];
            //                [self restoreBaloon:whereBaloon];
            //延时换图片
            if(count<randomFruitCount)
            {
                printf("执行count++前 count=%d\n",count);
                [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(changeAskFruitImage) userInfo:nil repeats:NO];
            }
            
            choseTime++;
            count++;
            printf("执行count++后 count=%d\n",count);
        }
        else
            score--;
        
        
    }
    
    
    if(count==randomFruitCount)
    {
       
        [self clownHappy];
        [[SimpleAudioEngine sharedEngine] playEffect:@"Happy.mp3"];
        //弹出窗口

        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(gameLevelPopup) userInfo:nil repeats:NO];
    
        printf("score=%d\n",score);
       
        
        
        
        printf("\n");
        printf("进入下一关\n");
        printf("\n");

//        [MagicSpellManagerLevel enterNextLevel];
    }
  
    printf("----------退出ccTouchesEnded方法----------\n");
}

-(void) removeCanIHave
{
    [self removeChildByTag:701 cleanup:YES];
}

-(void) removeGiveMeThe
{
    [self removeChildByTag:702 cleanup:YES];
}

#pragma mark -
#pragma mark Sound

-(void) snakeIamEating
{
     [[SimpleAudioEngine sharedEngine] playEffect:@"I_m_eating_the_(ze)_US.mp3"];
}

-(void) spiderIamTaking
{
     [[SimpleAudioEngine sharedEngine] playEffect:@"I_m_taking_the_(ze)_US.mp3"];
}

-(void) fruitSound
{
    printf("----------进入fruitSound------------\n");
    NSString *fruitName;
    printf("声音 吃水果的名字 fruitSound=%d\n",fruitSound);
    fruitName=[NSString stringWithFormat:@"%dMagicSpell.mp3",fruitSound];
    [[SimpleAudioEngine sharedEngine] playEffect:fruitName];
    printf("----------退出fruitSound------------\n");
}

-(void) clownFruitSound
{
    NSString *fruitName;
    printf("小丑要水果的名字 clownAskFruitSound=%d\n",clownAskFruitSound);
    fruitName=[NSString stringWithFormat:@"%dMagicSpell.mp3",clownAskFruitSound];
    [[SimpleAudioEngine sharedEngine] playEffect:fruitName];
}

-(void) blownBaloonSound
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"BalloonBlow.mp3"];
}

-(void) baloonExplode
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"BalloonExplode.mp3"];
}

#pragma mark -
#pragma mark Popup

-(void)gameLevelPopup
{
    CCLOG(@"gameScoreWindow ________________");
//    int score=1.0*(Level*2)/(touchNum-Level)*10;
    if (score>10)
        score=10;
    //游戏成绩变量，值大小：1-10整形；
    int scoreNow = score;
    NSString *scoreNowSt = [NSString stringWithFormat:@"%d",scoreNow];
    
    CCSprite *goldNormal3 = [CCSprite spriteWithFile:@"BtnBall0001.png"];
    CCSprite *goldSelected3 = [CCSprite spriteWithFile:@"BtnBall0002.png"];
    
    CCMenuItemSprite *spriteMenuItem3 = [CCMenuItemSprite itemWithNormalSprite:goldNormal3
                                                                selectedSprite:goldSelected3
                                                                        target:self
                                                                      selector:@selector(goNextLevel)];
    
    
    //附上tag值，方便在菜单项被选中时判断哪一个被选中
    spriteMenuItem3.tag = 3;
    
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:spriteMenuItem3, nil];
    if (scaleXY == 2) {
        menu.position = ccp(117, 35);
    }else{
        menu.position = ccp(234, 72);
    }
    
    PopUp *pop = [PopUp popUpWithTitle:@"" description:@"" sprite:menu scoreNowSt:scoreNowSt];
    [self addChild:pop z:1000];}

-(void)goNextLevel
{
    CCLOG(@"againPlay001");
    [self.parent removeChild:self cleanup:YES];
    [MagicSpellManagerLevel enterNextLevel:fromSceneName];
}

-(void)mainMenu
{
    CCLOG(@"mainMenu");
}


#pragma mark -
#pragma mark Dealloc

- (void) dealloc
{
	// don't forget to call "super dealloc"
    CCLOG(@"---------------------dealloc");
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"fruitMagicSpell.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"bedroomMagicSpell.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"livingroomMagicSpell.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"libraryMagicSpell.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"garageMagicSpell.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"bathroomMagicSpell.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"kitchenMagicSpell.plist"];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"baloon1MS.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"baloon2MS.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"baloon3MS.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"baloon4MS.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"blowbaloonMS.plist"];

    
	[super dealloc];
}

@end
