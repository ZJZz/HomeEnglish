//
//  Level1-Bathroom.m
//  homeEnglish
//
//  Created by zhangshuzhen on 12-11-12.
//  Copyright 2012年 itech. All rights reserved.
//

#import "LevelGame.h"
#import "hGardenLayer.h"
#import "SimpleAudioEngine.h"
#import "InterfaceManager.h"

#import "SceneTo.h"


@implementation LevelGame

-(void)upset:(NSString *)tempSceneName{
    CCLOG(@"------   %@   ————————",tempSceneName);
    
    //Garage Circus Flat Hair Leisurepark School Market Park Restaurant
    //从文件中读取不点点单词数据
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:tempSceneName ofType:@"std"];
    
    //不同点的单词名称、左上角点坐标、右下角点坐标
    NSMutableArray  *arrayWordName      =[[NSMutableArray alloc]init];
    NSMutableArray  *arrayWordNameX1    =[[NSMutableArray alloc]init];
    NSMutableArray  *arrayWordNameY1    =[[NSMutableArray alloc]init];
    NSMutableArray  *arrayWordNameX2    =[[NSMutableArray alloc]init];
    NSMutableArray  *arrayWordNameY2    =[[NSMutableArray alloc]init];
    NSMutableArray  *arrayWord1Temp    =[[NSMutableArray alloc]init];
    
    
    arrayWordIndexTemp    =[[NSMutableArray alloc]init];
    data_x = [[NSMutableArray alloc]init];
    data_y = [[NSMutableArray alloc]init];
    datas  = [[NSMutableArray alloc]init];
    data_x2 = [[NSMutableArray alloc]init];
    data_y2 = [[NSMutableArray alloc]init];
    
    
    NSArray * arrayTemp;
    NSString *temp;
    NSRange range;
    
    NSArray *readline=[[NSString stringWithContentsOfFile:lrcPath ] componentsSeparatedByString:@"\n"];
    //    NSArray *readline=[[NSString stringWithContentsOfFile:lrcPath] componentsSeparatedByString:@"\n"];
    NSEnumerator *nse=[readline objectEnumerator];
    while(temp=[nse nextObject])
    {
        range=[temp rangeOfString:@"Name="];//获取位置
        if (range.location!=NSNotFound) {
            NSString *tempRr = [[self tempstrSub:temp] stringByReplacingOccurrencesOfString:@"\r"withString:@""];
            [arrayWordName addObject:tempRr];
            continue;
        }
        
        range=[temp rangeOfString:@"Rect="];//获取位置
        if (range.location!=NSNotFound) {
            
            arrayTemp = [[self tempstrSub:temp] componentsSeparatedByString:@" "];
            
            [arrayWordNameX1 addObject:[arrayTemp objectAtIndex:0]];
            [arrayWordNameY1 addObject:[arrayTemp objectAtIndex:1]];
            [arrayWordNameX2 addObject:[arrayTemp objectAtIndex:2]];
            [arrayWordNameY2 addObject:[arrayTemp objectAtIndex:3]];
            
            continue;
        }
    }
    
    //循环一次：查出符合条件的数据（矩形包含每关的不同点数），并存储到数组arrayRectPoint：（tempRectx，tempRecty,currentPoint，向下/上）
    NSMutableArray *arrayRectPoint =  [[NSMutableArray alloc] init];
    
    //初始化矩形，查看矩形内包含多少个点;arrayWordName.count-2:最后两个点比较没有意义。
    int countRect;          //包含几个点
    //缩放比例
    if ([InterfaceManager countForNowGame]<4) {
        countRectMultiple =1.0;
    }else
        countRectMultiple =1.4;
    
    for (int i=0; i<(arrayWordName.count-2); i++) {
        //从左上角向右下角组建矩形
        //        tempRectx = (arc4random() % 30) ;
        //        tempRecty = (arc4random() % 10) ;
        tempRectx = 0;
        tempRecty = 0;
        
        
        //从左上角向右下角组建矩形
        backgroudRect = CGRectMake([[arrayWordNameX1 objectAtIndex:i] integerValue],[[arrayWordNameY1 objectAtIndex:i] integerValue],310*countRectMultiple,462*countRectMultiple);
        
        countRect = 0;
        
        for (int j=0; j<arrayWordName.count; j++) {
            CGPoint pointTempA = CGPointMake([[arrayWordNameX1 objectAtIndex:j] integerValue],[[arrayWordNameY1 objectAtIndex:j] integerValue]);
            CGPoint pointTempB = CGPointMake([[arrayWordNameX2 objectAtIndex:j] integerValue],[[arrayWordNameY2 objectAtIndex:j] integerValue]);
            
            if (CGRectContainsPoint( backgroudRect,pointTempA) && CGRectContainsPoint( backgroudRect, pointTempB) ) {
                countRect++;
            }
        }
        
        if (countRect >= [InterfaceManager countForNowGame]) {
            
            
            //            CCLOG(@"width:%0.0f,lengh:%0.0f",[[arrayWordNameX1 objectAtIndex:i] integerValue]+tempRectx + 310*countRectMultiple, 768 - [[arrayWordNameY1 objectAtIndex:i] integerValue]-tempRecty - 462*countRectMultiple);
            
            if ([[arrayWordNameX1 objectAtIndex:i] integerValue] + 310*countRectMultiple >1024) {
                firstPx = 1024 - 310*countRectMultiple;
            }else
                firstPx = [[arrayWordNameX1 objectAtIndex:i] integerValue];
            
            if( [[arrayWordNameY1 objectAtIndex:i] integerValue] + 462*countRectMultiple - 768 > 0 ){
                firstPy = 768 - 462*countRectMultiple;
            }else
                firstPy = [[arrayWordNameY1 objectAtIndex:i] integerValue];
            
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",firstPx]];
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",firstPy]];
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",i]];
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",1]];         //1：左上角——右下角
            
            
        }
        
        //从左下角向右上角组建矩形
        backgroudRect = CGRectMake([[arrayWordNameX1 objectAtIndex:i] integerValue],[[arrayWordNameY1 objectAtIndex:i] integerValue],310*countRectMultiple,-462*countRectMultiple);
        countRect = 0;
        
        for (int j=0; j<arrayWordName.count; j++) {
            CGPoint pointTempA = CGPointMake([[arrayWordNameX1 objectAtIndex:j] integerValue],[[arrayWordNameY1 objectAtIndex:j] integerValue]);
            CGPoint pointTempB = CGPointMake([[arrayWordNameX2 objectAtIndex:j] integerValue],[[arrayWordNameY2 objectAtIndex:j] integerValue]);
            
            firstPx = [[arrayWordNameX1 objectAtIndex:i] integerValue]+tempRectx;
            firstPy = [[arrayWordNameY1 objectAtIndex:i] integerValue]+tempRecty;
            
            if (CGRectContainsPoint( backgroudRect,pointTempA) && CGRectContainsPoint( backgroudRect, pointTempB) ) {
                countRect++;
            }
        }
        
        if (countRect >= [InterfaceManager countForNowGame]) {
            
            if ([[arrayWordNameX1 objectAtIndex:i] integerValue] + 310*countRectMultiple >1024) {
                firstPx = 1024 - 310*countRectMultiple;
            }else
                firstPx = [[arrayWordNameX1 objectAtIndex:i] integerValue];
            
            if( 462*countRectMultiple -[[arrayWordNameY1 objectAtIndex:i] integerValue] > 0 ){
                firstPy = 462*countRectMultiple;
            }else
                firstPy = [[arrayWordNameY2 objectAtIndex:i] integerValue];
            
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",firstPx]];
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",firstPy]];
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",i]];
            [arrayRectPoint addObject:[NSString stringWithFormat:@"%d",0]];     //1：右下角————左上角
            
            //Firt ，if not out of rang 1024*768
            //            CCLOG(@"width:%0.0f,lengh:%0.0f",[[arrayWordNameX1 objectAtIndex:i] integerValue]+tempRectx + 310*countRectMultiple,
            //                  [[arrayWordNameY2 objectAtIndex:i] integerValue]-tempRecty - 462*countRectMultiple);
        }
        
        
        
    }
    CCLOG(@"arrayRectPoint.count:%d",arrayRectPoint.count/4);
    
    int qualifyRectPointIndex = (arc4random() % (arrayRectPoint.count/4)) ;
    CCLOG(@"arrayRectPoint.count current:%d",qualifyRectPointIndex);
    
    //    int qualifyRectPointIndex = 0;
    
    //组建矩形：左上角——右下角 或者 左下角——右上角
    int temptemp = qualifyRectPointIndex*4;
    backgroudRectHigh = 462*countRectMultiple;
    if (![[arrayRectPoint objectAtIndex:temptemp+3] integerValue]) {
        backgroudRectHigh = -backgroudRectHigh;
    }
    CCLOG(@"backgroudRectHigh:%d",backgroudRectHigh);
    countRect =0;
    
    firstPx = [[arrayRectPoint objectAtIndex:temptemp] integerValue];
    firstPy = [[arrayRectPoint objectAtIndex:temptemp+1] integerValue];
    
    backgroudRect = CGRectMake( firstPx, firstPy, 310*countRectMultiple, backgroudRectHigh );
    
    //获取矩形内的点
    for (int j=0; j<arrayWordName.count; j++) {
        CGPoint pointTempA = CGPointMake([[arrayWordNameX1 objectAtIndex:j] integerValue],[[arrayWordNameY1 objectAtIndex:j] integerValue]);
        CGPoint pointTempB = CGPointMake([[arrayWordNameX2 objectAtIndex:j] integerValue],[[arrayWordNameY2 objectAtIndex:j] integerValue]);
        
        if (CGRectContainsPoint( backgroudRect,pointTempA) && CGRectContainsPoint( backgroudRect,pointTempB) ) {
            //put point into temp array
            [arrayWordIndexTemp addObject:[NSString stringWithFormat:@"%d",j]];
            countRect++;
        }
    }
    
    [datas removeAllObjects];
    [arrayWord1Temp removeAllObjects];
    [data_x removeAllObjects];
    [data_y removeAllObjects];
    [data_x2 removeAllObjects];
    [data_y2 removeAllObjects];
    
    if (countRect >= [InterfaceManager countForNowGame]) {
        
        for (int k=0; k<arrayWordIndexTemp.count; k++) {
            [datas addObject:[NSString stringWithFormat:@"%d",k+1]];
            
            [data_x addObject:[arrayWordNameX1 objectAtIndex:[[arrayWordIndexTemp objectAtIndex:k] integerValue]]];
            [data_y addObject:[arrayWordNameY1 objectAtIndex:[[arrayWordIndexTemp objectAtIndex:k] integerValue]]];
            [data_x2 addObject:[arrayWordNameX2 objectAtIndex:[[arrayWordIndexTemp objectAtIndex:k] integerValue]]];
            [data_y2 addObject:[arrayWordNameY2 objectAtIndex:[[arrayWordIndexTemp objectAtIndex:k] integerValue]]];
            [arrayWord1Temp addObject:[arrayWordName objectAtIndex:[[arrayWordIndexTemp objectAtIndex:k] integerValue]]];
        }
    }
    
    word1   =[[NSArray alloc]init];
    word1 = arrayWord1Temp;
    
    //手电筒的图片坐标
    rightOrError_x = [[NSArray alloc]initWithObjects:@"509",@"509",@"509",@"509",@"509",@"509",nil];
    rightOrError_y = [[NSArray alloc]initWithObjects:@"634",@"564",@"498",@"428",@"355",@"285",nil];
    useData = [[NSMutableArray alloc]init];
    int flag;
    CCLOG(@"开始初始化Garage数组");
    for (int i=datas.count;i>0;i--) {
        flag = arc4random() % i;
        [useData addObject:[datas objectAtIndex: flag]];
        [datas removeObjectAtIndex:flag];
    }
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


-( id ) init
{
	if( (self = [super init]) ) {
        self.isTouchEnabled = YES;
        NSString * tempSceneName = [SceneTo SceneNameF];
        [self upset:tempSceneName];
        
        
        //Background sound
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"SpotTheDifferences.mp3"];
        [CDAudioManager sharedManager].backgroundMusic.volume = 0.5f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"SpotTheDifferences.mp3" loop:YES];
        
        rightOrErrorCount =0;
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        winSize = s;
        
#pragma mark --------初始化返主2界面的menuButton  回到主页的home图片
        int imageBgPx,imageBgPy;
        NSString * tempReturn = [tempSceneName stringByAppendingString:@"ReturnButton.png" ];
        CCLOG(@"tempReturn-------:%@",tempReturn);
        CCSprite *menuButton = [CCSprite spriteWithFile:[tempSceneName stringByAppendingString:@"ReturnButton.png" ]];
        menuButton.position = ccp(989, 35);
        [self addChild:menuButton];
        menuButton.tag = 1;
        menuButton.scale = 1 * scaleXY;
        
        
        //以下是游戏左右背景 + 主背景
		CCSprite *gamepic1 ;
        if (scaleXY == 2) {
            gamepic1 = [ CCSprite spriteWithFile:[NSString stringWithFormat:@"%@Game-bgdf.png",tempSceneName] rect:backgroudRect];
        }else
            gamepic1 = [ CCSprite spriteWithFile:[NSString stringWithFormat:@"%@Game.png",tempSceneName] rect:backgroudRect];
		[ gamepic1 setPosition:ccp(128+164, 51+475-45)];
        [ self addChild:gamepic1 z:0 ];
        gamepic1.tag = 2;
        gamepic1.scale = 1 / countRectMultiple  ;
//        gamepic1.scale = 1 * scaleXY;
       
		CCSprite *gamepic2;
        if (scaleXY == 2) {
            gamepic2 = [ CCSprite spriteWithFile:[NSString stringWithFormat:@"%@Game-bgdf.png",tempSceneName] rect:backgroudRect];
        }else
            gamepic2 = [ CCSprite spriteWithFile:[NSString stringWithFormat:@"%@Game.png",tempSceneName] rect:backgroudRect];
		[ gamepic2 setPosition: ccp(567+164, 51+475-45) ];
		[ self addChild:gamepic2 z:0 ];
        gamepic2.tag =3;
        gamepic2.scale = 1 / countRectMultiple ;
//        gamepic2.scale = 1 * scaleXY;
        
        CCSprite *bg = [CCSprite spriteWithFile:@"BkgrNight.png"];
        bg.anchorPoint = ccp(0,0);
        [self addChild:bg z:-1];
        bg.scale = 1 * scaleXY;
#pragma mark ----------初始化需要放置的 三张不同图片 ------------------
         
        CCLOG(@"现在这关的不同数%i",[InterfaceManager countForNowGame]);

        int tempx,tempy,tempIndex;
        for (int i=0; i<[InterfaceManager countForNowGame]; i++) {
            
            tempIndex = [[arrayWordIndexTemp objectAtIndex:[[useData objectAtIndex:i] integerValue]-1] integerValue] +1;
            if (tempIndex < 10) {
                wn1 = [NSString stringWithFormat:@"%@_0%d.png",tempSceneName, tempIndex];
            }else{
                wn1 = [NSString stringWithFormat:@"%@_%d.png",tempSceneName, tempIndex];
            }
            CCLOG(@"i=%d,name:%@",i,wn1);
            
            
            CCTexture2D *left1_texture = [ [CCTextureCache sharedTextureCache] addImage:wn1 ];
            HandleSprite *left1 = [ HandleSprite paddleWithTexture: left1_texture ];
            
            tempx = ([[data_x objectAtIndex:[[useData objectAtIndex:i]integerValue]-1]integerValue]+[[data_x2 objectAtIndex:[[useData objectAtIndex:i]integerValue]-1]integerValue])/2 - firstPx;
            
            if (backgroudRectHigh > 0 ) {
                tempy = 462*countRectMultiple - (([[data_y objectAtIndex:[[useData objectAtIndex:i]integerValue]-1]integerValue]+[[data_y2 objectAtIndex:[[useData objectAtIndex:i]integerValue]-1]integerValue])/2 - firstPy) ;
                
            }else
                tempy = firstPy - ([[data_y objectAtIndex:[[useData objectAtIndex:i]integerValue]-1]integerValue]+[[data_y2 objectAtIndex:[[useData objectAtIndex:i]integerValue]-1]integerValue])/2 - 462*countRectMultiple;
            CCLOG(@"i=%d,name:%@,   tempx:%d,tempy:%d",i,wn1,tempx,tempy);
            
            
            [left1 setPosition: ccp(tempx,tempy) ];
            left1.tag =[[useData objectAtIndex:i]integerValue];
            left1.flags =i+1;
            left1.scale = 1* scaleXY;
            [ gamepic1 addChild:left1 z:3 ];
            [left1 setSynSprint:gamepic2];//在第二张背景图上操作同样操作
            
            CCTexture2D *right1_texture = [ [CCTextureCache sharedTextureCache] addImage:wn1 ];
            HandleSprite *right1 = [ HandleSprite paddleWithTexture: right1_texture ];
            
            
            //            CCLOG(@"dif right---- x:%d    y:%d",tempx,tempy);
            right1.anchorPoint = CGPointMake(0, 1);
            [ right1 setPosition: ccp(tempx,tempy) ];
            right1.tag =[[useData objectAtIndex:i]integerValue];
            right1.flags =i+1;
            right1.opacity=YES;
            right1.scale = 1* scaleXY;
            [ gamepic2 addChild:right1 z:3  ];
            [right1 setSynSprint:gamepic1];//在第二张背景图上操作同样操作
            
            rightOrError1 = [CCSprite spriteWithFile:[NSString stringWithFormat:@"Picture%d.png",i+1]];
            rightOrError1.position = ccp([ [rightOrError_x objectAtIndex:i]integerValue],[[rightOrError_y objectAtIndex:i]integerValue]);
            rightOrError1.scale = 1* scaleXY;
            [self addChild:rightOrError1 z:1] ;
            rightOrError1.tag = 91+i;
            
            
        }
          
        
#pragma mark ----------初始化需要放置的 三张不同图片 ------------------
//        CCLOG(@"---level1---初始化完毕");
    }
    
	return self;
}


-( void ) nextScene
{
    
}

-( void ) dealloc
{
	[ super dealloc ];
}

@end
