//
//  wyMatchGameLayer.m
//  wyMatchGame
//
//  Created by wenyuan on 12-11-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "wyMatchGameLayer.h"
#import "SimpleAudioEngine.h"

#import "CCMenuPopup.h"
#import "PopUp.h"

#import "SceneTo.h"


@implementation wyMatchGameLayer
+(CCScene *) sceneWithGround:(NSString *)g Level:(int)l
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	NSLog(@"SceneName=%@，Level=%d",g, l);
	// 'layer' is an autorelease object.

    wyMatchGameLayer    *layer = [[[wyMatchGameLayer alloc]initWithGround:g Level:l]autorelease];
	// add layer as a child to scene
	[scene addChild: layer];
	// return the scene
	return scene;
}


//
-(id) initWithGround:(NSString *) g Level:(int) l
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        CCLOG(@"---------start---------");
        showIndex=0;
        int Sum;
        
        //Because up to 20 spaces, so the game up to 10 level.     
        Level=l;
        if (Level>10)
            Level=10;
        
        ground=g;
        touchNum=0;
        
        [self arrayWithGound:ground];
        
        if ([SceneTo uiIpadBack]) {
            scaleXY = 2;
        }else
            scaleXY = 1;
        CCLOG(@"scaleXY:%d",scaleXY);

        Sum= [imArray count];
        
        CCLOG(@"imArray count:%d -level:%d",Sum,Level);
        [CDAudioManager sharedManager].backgroundMusic.volume = 1.0f;
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"MemoryGame.mp3" loop:YES];

//        NSLog(@"str=%@",(NSString *)[imArray objectAtIndex:0]);
        [SimpleAudioEngine sharedEngine];
        wy=[[wyGameBrain alloc]initWithLevel:Level Sum:Sum];
        self.isTouchEnabled = YES;
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        //
        showWord=[CCSprite spriteWithFile:@"carteGame.png"];
        showWord.position=ccp(size.width*0.14,size.height*0.40);
        showWord.scale=1.3*scaleXY;
        showWordLabel = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:32];
        showWordLabel.position=ccp(size.width*0.13,size.height*0.23);
        showWordLabel.rotation=10;
        [self addChild:showWordLabel];
        showWord.rotation=10;
        showWord.opacity=0;
        
        showWord.visible=NO;
        showWordLabel.visible=NO;
        [self addChild:showWord];
        
        // background of game
        CCSprite *loginbg = [CCSprite spriteWithFile:@"memorygame.png"];
        loginbg.scale = 1*scaleXY;
        loginbg.position = ccp(size.width/2, size.height/2);
        [self addChild:loginbg z:-1];
        
        //返回按钮
        CCSprite *returnButton = [CCSprite spriteWithFile:[ground stringByAppendingString:@"ReturnButton.png"]];
        returnButton.scale = 1*scaleXY;
        returnButton.anchorPoint = CGPointMake(0, 1);
        returnButton.position = ccp(954, 70);
        returnButton.tag = 11;
        [self addChild:returnButton];
        
//        focusCardI=[NSMutableArray new];
//        focusCardJ=[NSMutableArray new];
//        beforeFocusCardI=[NSMutableArray new];
//        beforeFocusCardJ=[NSMutableArray new];
        [self schedule:@selector(initShowCard:) interval:1.0/(Level*2) ];
        
        for (int i=0;i<CARDHEIGHT ;++i)
        {
            for (int j=0;j<CARDWIDTH;++j)
            {
                Card c=[wy cardOfI:i J:j];
//                NSLog(@"card[%d][%d].value=%d",i,j,c.value);
                if (c.exist==YES)
                {
                    cards[i][j]=[CCSprite spriteWithFile:@"carteGame.png"];
                    cards[i][j].scale = 1*scaleXY;
                    cards[i][j].position=ccp(size.width*0.2,size.height*0.2);
                    blank[i][j]=[CCSprite spriteWithFile:@"blankGame.png"];
                    blank[i][j].scale = 1*scaleXY;
                    blank[i][j].position=cards[i][j].position;
                    [self addChild:blank[i][j] z:0];
                    [self addChild:cards[i][j] z:10];
                    
                }
            }
        }
//        NSLog(@"str=%@",(NSString *)[imArray objectAtIndex:0]);
        
    }
    return self;
}
-(void ) arrayWithGound:(NSString *) ground
{
    CCLOG(@"arrayWithGound:%@",ground);
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:ground ofType:@"ini"];

//    NSString * textContent  = [NSString stringWithContentsOfFile:lrcPath encoding:Nil error:nil];
    NSString * textContent  = [NSString stringWithContentsOfFile:lrcPath encoding:nil error:nil];
   // NSLog(@"文件信息 = %@",textContent);
    // 将字符串切割成数组
    NSMutableArray * array=[[NSMutableArray alloc]init];
    NSArray * tempArray=[textContent componentsSeparatedByString:@"Word"];

    for (int i=2; i<tempArray.count; ++i) {
        {
            NSString * str=[tempArray objectAtIndex:i];
            char word[20];
            int num;
            if ([str length]>40) break;
            const char * ch=[(NSString *)str cStringUsingEncoding:NSASCIIStringEncoding];
            sscanf (ch,"%d=%s",&num,word);
            //  NSLog(@"%d %s",i,word);
            [array addObject:[NSString stringWithFormat:@"%s",word]];
        }
    }
//    for (int i=0;i<array.count;++i)
//    {
//        NSLog(@"i=%d %@",i,[array objectAtIndex:i]);
//    }
    imArray =array;
//    return array;
}
-(void) initShowCard:(ccTime) dt
{
    NSLog (@"initShow %d Level=%d",showIndex,Level);
    if (showIndex>=CARDHEIGHT*CARDWIDTH)
    {
        [self unschedule:@selector(initShowCard:)];
    }
    CGSize size = [[CCDirector sharedDirector] winSize];
    while (showIndex<CARDHEIGHT*CARDWIDTH)
    {
        int i=showIndex/CARDWIDTH;
        int j=showIndex%CARDWIDTH;
        Card c=[wy cardOfI:i J:j];
        if (c.exist==YES)
        {
            [cards[i][j] runAction:[CCMoveTo actionWithDuration:0.3 position:ccp(size.width*(j+3)/(CARDWIDTH+3),size.height*(i+1)/(CARDHEIGHT+1))]];
            
            [blank[i][j] runAction:[CCMoveTo actionWithDuration:0.3 position:ccp(size.width*(j+3)/(CARDWIDTH+3),size.height*(i+1)/(CARDHEIGHT+1))]];

            showIndex++;
            return;
        }
        showIndex++;
    }
}

-(void) CallBack2:(id)sender Data:(void *) data {
    CCLOG(@"CallBack2");
    NSString * str=data;
    UIImage * imagetemp=[UIImage imageNamed:[str stringByAppendingString:@".png"]];
    newTexture=[[CCTextureCache sharedTextureCache]  addCGImage:imagetemp.CGImage forKey:nil];
    
    //newTexture=[[CCTextureCache sharedTextureCache] textureForKey:str];
    [sender setTexture:newTexture];
    if ([str isEqualToString:@"carteGame"]!=YES)
        [[SimpleAudioEngine sharedEngine] playEffect:[(NSString *)str stringByAppendingFormat:@"_us.mp3"]];

}

//UIImage放大(缩小)到指定大小
- (UIImage *) scaleFromImage:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}



-(void) CallBack1:(id)sender Data:(void *) data {
    self.isTouchEnabled=YES;
    int i=(int)data/CARDWIDTH,j=(int)data%CARDWIDTH;
    [wy changeVisiableI:i J:j];
    Card c=[wy cardOfI:i J:j];
    if (wy.tounchCount==2)
    {
        if ([wy judgeTwoCards]==YES)
        {
            wy.cardNum-=2;
            showWord.visible=YES;
            showWordLabel.visible=YES;
            [showWord runAction:[CCFadeIn actionWithDuration:1]];
            NSString *str=[imArray objectAtIndex:c.value];
            UIImage * image=[UIImage    imageNamed:str];
            newTexture=[[CCTextureCache sharedTextureCache]  addCGImage:image.CGImage forKey:nil];
            [showWord setTexture:newTexture];
//            [showWordLabel setString:str];
            [showWordLabel setString:[SceneTo wordSpace:str]];
            if (wy.cardNum==0)
            {
                [self gameScoreWindow];
            }
            
        }
        else
        {
            int ii,jj;
            [wy CardIndex:0 I:&ii J:&jj];
            [self changeCardI:ii J:jj];
            [wy CardIndex:1 I:&ii J:&jj];
            [self changeCardI:ii J:jj];
            
        }
        wy.tounchCount=0;
    }
}

-(void) changeCardI:(int)i J:(int)j
{
    self.isTouchEnabled=NO;
    Card c=[wy cardOfI:i J:j];
    NSLog(@"value=%d",c.value);
    NSString * str=[imArray objectAtIndex:c.value];
    if (c.visiable==YES)
        str=@"carteGame";
    
    [cards[i][j]
     runAction:[CCSequence actions:
                [CCScaleTo actionWithDuration:0.15 scaleX:0.01*scaleXY scaleY:1*scaleXY],
                [CCCallFuncND actionWithTarget:self selector:@selector(CallBack2:Data:) data:(void*)str],
                [CCScaleTo actionWithDuration:0.15 scaleX:1*scaleXY scaleY:1*scaleXY],
                [CCDelayTime actionWithDuration:0.5],
                [CCCallFuncND actionWithTarget:self selector:@selector(CallBack1:Data:) data:(void*) (i*CARDWIDTH+j)],
                
                nil]];
    
    [blank[i][j]
     runAction:[CCSequence actions:
                [CCScaleTo actionWithDuration:0.15 scaleX:0.01*scaleXY scaleY:1*scaleXY],
                [CCScaleTo actionWithDuration:0.15 scaleX:1*scaleXY scaleY:1*scaleXY],
                [CCDelayTime actionWithDuration:0.5],
                
                nil]];
    //    NSLog(@"changeWY eend");
    
}
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    //    NSLog(@"location x=%f %f",location.x,location.y);
    
    //jump to level
    CCSprite *returnButton = (CCSprite *)[self getChildByTag:11];
    if (CGRectContainsPoint([returnButton boundingBox], location)) {
        NSArray *sceneNameArray = [[NSArray alloc] initWithObjects:
                                   @"Livingroom",
                                   @"Kitchen",
                                   @"Garage",
                                   @"Garden",
                                   @"Library",
                                   @"Bathroom",
                                   @"Bedroom",
                                   nil];
        int sceneNumber = [sceneNameArray indexOfObject:ground ];
        [sceneNameArray release];
        
        [SceneTo toSceneScene:sceneNumber];
    }
    
    //Game judgment.
    for (int i=0;i<CARDHEIGHT;++i)
    {
        for (int j=0;j<CARDWIDTH;++j)
        {
            if (wy.tounchCount<2 && [wy touchI:i J:j]==YES && CGRectContainsPoint([cards[i][j] boundingBox], location)) {
                touchNum++;
                [self changeCardI:i J:j];
            }
        }
    }    
}


//调用成绩窗口接口
//在游戏结束和下一关之间，添加了一个成绩窗口。
-(void) gameScoreWindow {
    CCLOG(@"gameScoreWindow ________________");
    int score=1.0*(Level*2)/(touchNum-Level)*10;
    if (score>10) score=10;
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
    [self addChild:pop z:1000];
    
}


-(void) goNextLevel{
     CCLOG(@"goNextLevel ________________");
    [self.parent removeChild:self cleanup:YES];
    [imArray release];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[wyMatchGameLayer sceneWithGround:ground Level:Level+1] withColor:ccBLACK]];
    [self initWithGround:ground Level:Level+1];
    
}


- (void) dealloc
{
	// don't forget to call "super dealloc"
    CCLOG(@"---------------------dealloc");
	[super dealloc];
}

@end
