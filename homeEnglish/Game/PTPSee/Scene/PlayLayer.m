#import "PlayLayer.h"

#import "CCMenuPopup.h"
#import "PopUp.h"
#import "SimpleAudioEngine.h"
#import "SceneTo.h"


extern CCLabelTTF * ccLP(NSString * value, float fontSize, CGPoint pos);
@interface PlayLayer ()
-(void) initBallsSprite;
-(void) initNumberLabel;
-(void) initMenu;
-(void) showStartHint;
-(void) startHintCallback: (id) sender;
-(void) goNextLevel;
@end

@implementation PlayLayer

static int  wordCount;

#pragma mark init part
-(id) init {
	if( (self=[super init] )) {
        
        //防止数组内存泄露
//        imArray=[self arrayWithGound:[SceneTo SceneNameF]];
        [self arrayWithGound:[SceneTo SceneNameF]];

        wordCount = [imArray count];
        CCLOG(@"wordCount:%d",wordCount);
        
        
		game  = [[Game alloc] init];
        CCLOG(@"game:-------:%d",[game level].no);
        CCLOG(@"game:-------:%d",[game level].timeLimit);
        CCLOG(@"game:-------:%d",game.timeAllCount);
        CCLOG(@"game:-------:%f",(float)game.timeAllCount/200);
		chart = [[Chart alloc] initWith: [game level]];

		
		Skill *bombSkill = [[Bomb alloc] initWithChart:chart linkDelegate:self];
		Skill *suffleSkill = [[Suffle alloc] initWithChart:chart linkDelegate:self];
		
		game.bombSkill = bombSkill;
		game.suffleSkill = suffleSkill;

		[game setState: GameStatePrepare];
		startHintIndex = 0;
//		startHintArray = [NSArray arrayWithObjects:
//							[NSString stringWithFormat:@"Level %d",[game.level no]],@"Ready",@"Go",nil];
        startHintArray = [NSArray arrayWithObjects:@" ",@" ",@" ",nil];
		[startHintArray retain];
		
		self.isTouchEnabled = NO;
		[self initBallsSprite];
		[self initNumberLabel];
		[self initMenu];
        
        [bombSkill release];
        [suffleSkill release];
	}
	
	return self;
}


//初始化单词图片到sprite
-(void) initBallsSprite{
    NSMutableArray *spriteNumber = [[NSMutableArray alloc] init];
	for (int y=0; y<kRowCount; y++) {
		for (int x=0; x<kColumnCount; x++) {
			Tile *tile = [chart get: ccp(x,y)];
			int posX = (x-1)*kTileSize + kLeftPadding + kTileSize/2;
			int posY = (y-1)*kTileSize + kTopPadding + kTileSize/2;
			
			if (tile.kind < 0) {
				continue;
			}
            [spriteNumber addObject:[NSString stringWithFormat:@"%d", tile.kind]];
            
//            CCLOG(@"playlayer.m initBallsSprite tile.kind:         %d",tile.kind);
			NSString *imageName = [NSString stringWithFormat:@"%@-64.png",[imArray objectAtIndex:tile.kind]];
//            CCLOG(@"playlayer.m imageName:%@",imageName);

//            CCLOG(@"playlayer.m initBallsSprite tile.kind:%d",tile.kind);
//			NSString *imageName = [NSString stringWithFormat: @"q%d.png", tile.kind];
			tile.sprite = [CCSprite spriteWithFile:imageName];
            
			tile.sprite.scaleX = kDefaultScaleX;
			tile.sprite.scaleY = kDefaultScaleY;
			tile.sprite.position = ccp(posX, posY);
    
            tile.sprite.scale = 1;
			[self addChild: tile.sprite z: 3];
		}
	}
    
    NSLog(@"spriteNumber count:%d",spriteNumber.count);

    NSLog(@"spriteNumber:%@",spriteNumber);
    
    NSMutableArray *spriteNumberUsed = [[NSMutableArray alloc] init];
    
    allScore = 0;
    int iCurrentAll = 0;
    
    for (int i = 0; i<spriteNumber.count; i++) {
        int currentTemp =  [[spriteNumber objectAtIndex:i] intValue];
        
        CCLOG(@"        ");
        CCLOG(@"        ");
        CCLOG(@"currentTemp:%d",currentTemp);
        CCLOG(@"spriteNumberUsed.count:%d",spriteNumberUsed.count);
        
        
        if (spriteNumberUsed.count == 0) {
            CCLOG(@"spriteNumberUsed.count=========0");
            [spriteNumberUsed addObject:[NSString stringWithFormat:@"%d", currentTemp]];
            
            //获取成员的数量
            iCurrentAll = 1;
            for (int ix= i+1; ix<spriteNumber.count; ix++) {
                if ([[spriteNumber objectAtIndex:ix] intValue] == currentTemp) {
                    iCurrentAll++;
                }
            }
            CCLOG(@"iCurrentAll:%d",iCurrentAll);
            
            
            //通过成员的数量，计算总成绩
            int tempScore = 0;
            for (int iScore = 1; iScore <= iCurrentAll/2; iScore++) {
                tempScore = tempScore + iScore;
            }
            
            CCLOG(@"tempScore:%d",tempScore);
            
            allScore = allScore + tempScore*50;
            
            CCLOG(@"allScore:%d",allScore);
        }else{
            CCLOG(@"spriteNumberUsed.count！！！！！！！！！！0");
            if ( [self spriteNumberIsOrNot:currentTemp B:spriteNumberUsed]) {
                
                [spriteNumberUsed addObject:[NSString stringWithFormat:@"%d", currentTemp]];
                //获取成员的数量
                iCurrentAll = 1;
                for (int ix= i+1; ix<spriteNumber.count; ix++) {
                    if ([[spriteNumber objectAtIndex:ix] intValue] == currentTemp) {
                        iCurrentAll++;
                    }
                }
                CCLOG(@"iCurrentAll:%d",iCurrentAll);
                
                
                //通过成员的数量，计算总成绩
                int tempScore = 0;
                for (int iScore = 1; iScore <= iCurrentAll/2; iScore++) {
                    tempScore = tempScore + iScore;
                }
                
                CCLOG(@"tempScore:%d",tempScore);
                
                allScore = allScore + tempScore*50;
                
                CCLOG(@"allScore:%d",allScore);
            }

            
        }

    }

    CCLOG(@"allScore:%d",allScore);
    
    [spriteNumber release];
    [spriteNumberUsed release];
}

-(BOOL) spriteNumberIsOrNot:(int)currentTemp B:(NSMutableArray *) spriteNumberUsed{
    CCLOG(@"spriteNumberUsed.count:%d",spriteNumberUsed.count);

        
        for (int j=0; j<spriteNumberUsed.count; j++) {
            if ([[spriteNumberUsed objectAtIndex:j] intValue] == currentTemp) {
                return FALSE;
            }else{
                return TRUE;
                
            }
        }
    
}



-(void) initNumberLabel{
	{
		CCLabelTTF *scoreValueLabel = 	ccLP(@"0", 28.0f, ccp(120,225));
		[self addChild: scoreValueLabel z:1 tag:kScoreLabelTag];	
	}
    
    {
		CCLabelTTF *wordnameValueLabel = 	ccLP(@"", 28.0f, ccp(135,435));
		[self addChild: wordnameValueLabel z:1 tag:kWordNameLableTag];
	}

	{
		int time = [game.level timeLimit];        
		NSString *timeValueString = [NSString stringWithFormat: @"%d", time];
		CCLabelTTF *timeValueLabel = 	ccLP(timeValueString, 28.0f, ccp(950,738));
		[self addChild: timeValueLabel z:1 tag:kTimeLabelTag];
	}
	
//	{			
//		CCLabelTTF *timeLabel = ccLP(@"time", 28.0f, ccp(120,300));
//		[self addChild:timeLabel];
//	}
	
	{
		CCLabelTTF *scoreLabel = ccLP(@"score", 28.0f, ccp(120,250));
		[self addChild:scoreLabel];
	}
	
}

-(void) initMenu{
//	CCMenuItemFont *bombItem = [CCMenuItemFont itemFromString:@"Bomb" target:game.bombSkill selector: @selector(run:)];
//	CCMenuItemFont *suffleItem = [CCMenuItemFont itemFromString:@"Suffle" target:game.suffleSkill selector: @selector(run:)];
    
    CCSprite *bombNormal = [CCSprite spriteWithFile:@"button_bomb_0.png"];
    CCSprite *bombSelected = [CCSprite spriteWithFile:@"button_bomb_1.png"];
    CCSprite *suffleNormal = [CCSprite spriteWithFile:@"button_refresh_0.png"];
    CCSprite *suffleSelected = [CCSprite spriteWithFile:@"button_refresh_1.png"];
 
    

    
    CCMenuItemSprite *bombItem = [CCMenuItemSprite itemWithNormalSprite:bombNormal selectedSprite:bombSelected target:game.bombSkill selector:@selector(run:)];
    CCMenuItemSprite *suffleItem = [CCMenuItemSprite itemWithNormalSprite:suffleNormal selectedSprite:suffleSelected target:game.suffleSkill selector:@selector(run:)];

    bombItem.scale = 1*scaleXY;
    suffleItem.scale = 1*scaleXY;
	
	game.bombSkill.assItem = bombItem;
	game.suffleSkill.assItem = suffleItem;
	
	CCMenu *menu = [CCMenu menuWithItems:bombItem, suffleItem, nil];
    [menu alignItemsHorizontallyWithPadding:35];
	menu.position = ccp(350,73);
    
	[self addChild:menu z: 2 tag: kMenuTag];
    
}

-(void) goPause: (id) sender{
	[SceneManager goPause];
}

#pragma mark inherit method
-(void) onEnterTransitionDidFinish{
	[super onEnterTransitionDidFinish];
	if(startHintArray){
		[self showStartHint];
	}
}

-(void) onEnter{
	[super onEnter];
	if (!startHintArray) {
		[self schedule:@selector(checkGameState) interval: kScheduleInterval];	
	}
}
-(void) onExit{
	[super onExit];
	[self unschedule:@selector(checkGameState)];
}

#pragma mark custom method
-(void) showStartHint{
    //菜单位置
	if (startHintIndex >= [startHintArray count]) {
		[self schedule:@selector(checkGameState) interval: kScheduleInterval];
		[startHintArray release];
		startHintArray = nil;
		[game setState:GameStatePlaying];
		self.isTouchEnabled = YES;
//		CCNode *menu = [self getChildByTag:kMenuTag];
//		[menu runAction:[CCMoveTo actionWithDuration:0.5F position:ccp(50,65)]];
	}else {
//		NSString *hintText = [startHintArray objectAtIndex:startHintIndex];		
		
//		CCLabelTTF *label = ccLP(hintText, 30.0f, ccp(240,160));
//		label.opacity = 170;
//		CCAction *action = [CCSequence actions:
//							[CCSpawn actions:
//							 [CCScaleTo actionWithDuration:0.8f scaleX:2.5f scaleY:2.5f],
//							 [CCSequence actions: 
//							  [CCFadeTo actionWithDuration: 0.6f opacity:255],
//							  [CCFadeTo actionWithDuration: 0.2f opacity:128],
//							  nil],
//							 nil],
//							[CCCallFuncN actionWithTarget:self  selector:@selector(startHintCallback:)],
//							nil
//							];
//		[self addChild:label z:5 tag: kStartHint];
//		[label runAction: action];		
		startHintIndex++;
        [self showStartHint];
	}
}

-(void) startHintCallback: (id) sender{
	[self removeChild:sender cleanup:YES];
	[self showStartHint];
}

-(void) dealloc{
	[super dealloc];
	[game release];
	[chart release];
}


-(void) checkGameState{
//    CCLOG(@"playlayer checkGameState:");
	if (game.state == GameStateWin) {
		[self unschedule:@selector(checkGameState)];
		CCLabelTTF *levelClear = ccLP(@" ", 28.0f, ccp(240, 160));
		levelClear.opacity = 60;
		[self addChild: levelClear z: 5];
		[levelClear runAction: [CCSequence actions:
							 [CCFadeTo actionWithDuration:0.5f opacity:244],
							 [CCDelayTime actionWithDuration:1.0f],
							 [CCCallFunc actionWithTarget:self selector:@selector(gameScoreWindow)],
							 nil]];
		return;
	}
	
	[game plusUsedTime:kScheduleInterval];
	if (game.state == GameStateLost) {
		[self unschedule:@selector(checkGameState)];
		
		CCLabelTTF *timerUp = ccLP(@" ", 28.0f, ccp(240, 160));
		timerUp.opacity = 60;
		[self addChild: timerUp z: 5];
		[timerUp runAction: [CCSequence actions:
							 [CCFadeTo actionWithDuration:0.5f opacity:244],
							 [CCDelayTime actionWithDuration:1.0f],
							 [CCCallFunc actionWithTarget:self selector:@selector(goNextLevel)],
							 nil]];
		 
		return;
	}else {
		NSString *timeString = [NSString stringWithFormat:@"%d", (int)[game usedTime]];
		CCLabelTTF *timeLabel = (CCLabelTTF *)[self getChildByTag:kTimeLabelTag];
		[timeLabel setString:timeString];
        
        
        float HP = planeHPTimer.percentage;
//        HP -= 0.5;        
        HP -= (float)100/[game level].timeLimit/2;
        planeHPTimer.percentage = HP;    

	}
}


//调用成绩窗口接口
//在游戏结束和下一关之间，添加了一个成绩窗口。
-(void) gameScoreWindow {
   
    //游戏成绩变量，值大小：1-10整形；  
    //分数低，提分：开平方*10    double sqrt (double);开平方
    
    CCLOG(@"---------------game.score                   :%d",game.score);
    CCLOG(@"---------------allScore                     :%d",allScore);
    CCLOG(@"---------------game.score/allScore*10       :%d",game.score * 10 / allScore);
    

    int scoreNow;
    if ((game.score * 10 / allScore + 3)>10) {
        scoreNow = 10;
    }else
        scoreNow = game.score * 10 / allScore + 3;
    
    
    CCLOG(@"scoreNow---------------:%d",scoreNow);
    NSString *scoreNowSt = [NSString stringWithFormat:@"%d",scoreNow];
    
    CCSprite *goldNormal3 = [CCSprite spriteWithFile:@"BtnBall0001.png"];
    CCSprite *goldSelected3 = [CCSprite spriteWithFile:@"BtnBall0002.png"];
    CCSprite *goldDisabled3 = [CCSprite spriteWithFile:@"BtnBall0003.png"];
    
    
    CCMenuItemSprite* spriteMenuItem3 = [CCMenuItemSprite itemFromNormalSprite:goldNormal3
                                                                selectedSprite:goldSelected3
                                                                disabledSprite:goldDisabled3
                                                                        target:self
                                                                      selector:@selector(goNextLevel)];
    
    //附上tag值，方便在菜单项被选中时判断哪一个被选中
    spriteMenuItem3.tag = 3;
    
    CCMenuPopup *menu = [CCMenuPopup menuWithItems:spriteMenuItem3, nil];
//    menu.anchorPoint = ccp(0, 0);
    CCLOG(@"scaleXY:-----------%d",scaleXY);
    if (scaleXY == 2) {
        menu.position = ccp(117, 36);
    }else{
        
        menu.position = ccp(234, 72);
        
    }
    
    PopUp *pop = [PopUp popUpWithTitle:@"   " description:@"" sprite:menu scoreNowSt:scoreNowSt];
    [self addChild:pop z:1000];  

}


-(void) goNextLevel{
    CCLOG(@"playlayer goNextLevel:");
    [self.parent removeChild:self cleanup:YES];
	if (GameStateLost == game.state) {
//		[SceneManager goMenu];
        [SceneManager goPlay];
	}else {
		[User saveScore: game.score + [User score]];
        
        if ([game.level no] >= kMaxLevelNo) {
            [User saveWinedLevel: 9];
        }else{
            [User saveWinedLevel: [game.level no]];
        }
		
		[User saveUsedTime: game.usedTime];        
        [SceneManager goPlay];	
		
//		if([game.level no] == kMaxLevelNo){	
//			[NameInputAlertViewDelegate showWinView];
//		}else{
//			[SceneManager goPlay];		
//		}		
	}
}

-(void) ballConnectedA: (Tile *) aTile B: (Tile *) bTile{
	int fireKind = aTile.kind;
	{
		[chart dismissTile: aTile];
		[chart dismissTile: bTile];
	}
	[MusicHandler notifyConnect];
	
	int scorePrevious = game.score;
	[game notifyNewLink: fireKind];
	
	int kindCount =game.lastKindCount;
	int kind = game.lastKind;
	int scoreAdd = game.score - scorePrevious;
	
	NSString *scoreAddString = [NSString stringWithFormat:@"%d", scoreAdd];
	CCLabelTTF *scoreAddLabel = ccLP(scoreAddString, 18.0f, ccp(120,160));
	scoreAddLabel.scaleX = 1.0f+kindCount/4;
	scoreAddLabel.scaleY = 1.0f+kindCount/4;
	[self addChild: scoreAddLabel z:1];
	CCAction *action = [CCSequence actions:
						[CCSpawn actions:
						 [CCMoveTo actionWithDuration: 1.0F position:ccp(120,225)],
						 [CCFadeOut actionWithDuration: 1.0F ],
						 nil],
						[CCCallFuncN actionWithTarget: self selector: @selector(scoreAddLabelActionDone:)],				
						nil];
	[scoreAddLabel runAction: action]; 
	
    //移动后的Sprite的位置,解决相同类点击第二次，没有播放声音问题。
//	if (kindCount==1) {
		CCSprite *previousComboSprite = (CCSprite *)[self getChildByTag: kComboTag];
		if (previousComboSprite) {
			[self removeChild: previousComboSprite cleanup: YES];
		}
        NSString *imageName = [NSString stringWithFormat:@"%@-64.png",[imArray objectAtIndex:kind]];
//		NSString *imageName = [NSString stringWithFormat:@"q%d.png", kind];
		CCSprite *comboSprite = [CCSprite spriteWithFile: imageName];
        
        comboSprite.scale = 1;
		
		comboSprite.scaleX = kDefaultScaleX*3.0;
		comboSprite.scaleY = kDefaultScaleY*3.0;
		comboSprite.tag = kComboTag;
		comboSprite.position = ccp(150,570);
		[self addChild: comboSprite z:1];
        
        CCLabelTTF *WordNameLable = (CCLabelTTF *)[self getChildByTag: kWordNameLableTag];
        
        [WordNameLable setString: [NSString stringWithFormat:@"%@", [SceneTo wordSpace:[imArray objectAtIndex:kind]]]];
        
        
        //播放room声音
        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundID];

        NSString * wordNameSound = [(NSString *)[imArray objectAtIndex:kind] stringByAppendingFormat:@"_us.mp3"];
        
        soundID = (NSNumber*)[[SimpleAudioEngine sharedEngine] playEffect:wordNameSound];
        
//        [[SimpleAudioEngine sharedEngine] playEffect:[(NSString *)[imArray objectAtIndex:kind] stringByAppendingFormat:@"_us.mp3"]];
//	}
	
	CCLabelTTF *comboNoLabel = (CCLabelTTF *)[self getChildByTag: kComboNOTag];
	if (!comboNoLabel) {
		comboNoLabel = ccLP(@"0", 24.0F, ccp(120,160));
		comboNoLabel.tag = kComboNOTag;
		[self addChild: comboNoLabel z:1];
	}
	[comboNoLabel setString: [NSString stringWithFormat:@"X %d", kindCount]];
	
	[chart packA: aTile B: bTile];	
}

//触屏事件
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    CCLOG(@"ccTouchesBegan 00");
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
    CCLOG(@"location: %f  %f",location.x,location.y);
	
	int x = (location.x -kLeftPadding) / kTileSize + 1;
	int y = (location.y -kTopPadding) / kTileSize + 1;

	
	if (x == selectedTile.x && y== selectedTile.y) {
		return;
	}
	
	Tile *tile = [chart get: ccp(x,y)];
	if (!tile) {
		return;
	}
	
	if(tile.kind < 0){
		return;
	}
	if (selectedTile && [chart isConnectStart: tile end:  selectedTile]) {	
		[self ballConnectedA: selectedTile B:tile];
		selectedTile = nil;
	}else{
		
        CCLOG(@"ccTouchesBegan 001");
		CCSprite *sprite = tile.sprite;
		sprite.scaleX = kDefaultScaleX;
		sprite.scaleY = kDefaultScaleY;
        
		CCSequence *someAction = [CCSequence actions: 
								   [CCScaleBy actionWithDuration:0.5f scale:0.5f],
								   [CCScaleBy actionWithDuration:0.5f scale:2.0f],
								   [CCCallFuncN actionWithTarget:self selector:@selector(afterOneShineTrun:)],
								   nil];
		selectedTile = tile;
		[sprite runAction:someAction];
	}
}

//TODO rename
-(void) scoreAddLabelActionDone: (id) node{
	CCLabelTTF *scoreLabel = (CCLabelTTF *)[self getChildByTag: kScoreLabelTag];
	[scoreLabel setString: [NSString stringWithFormat:@"%d", game.score]];
		
}

//TODO  try another way
-(void)afterOneShineTrun: (id) node{
    CCLOG(@"afterOneShineTrun 00");
	if (selectedTile && node == selectedTile.sprite) {
		CCSprite *sprite = (CCSprite *)node;
		CCSequence *someAction = [CCSequence actions: 
								  [CCScaleBy actionWithDuration:0.5f scale:0.5f],
								  [CCScaleBy actionWithDuration:0.5f scale:2.0f],
								  [CCCallFuncN actionWithTarget:self selector:@selector(afterOneShineTrun:)],
								  nil];
		
		[sprite runAction:someAction];
	}
}

-(void) arrayWithGound:(NSString *) ground
{
//    NSLog(@"ground=%@",ground);
    NSString *lrcPath = [[NSBundle mainBundle] pathForResource:ground ofType:@"ini"];
//    NSLog(@"lrcPath=%@",lrcPath);
    
    NSString * textContent  = [NSString stringWithContentsOfFile:lrcPath encoding:nil error:nil];
//     NSLog(@"文件信息 = %@",textContent);
    // 将字符串切割成数组
    NSMutableArray * array=[[NSMutableArray alloc]init];
    NSArray * tempArray=[textContent componentsSeparatedByString:@"Word"];

    for (int i=2; i<tempArray.count; ++i) {
        {           
            
            NSString * str=[tempArray objectAtIndex:i];
//            NSLog(@"文件信息 tempArray = %@",str);
            
            char word[20];
            int num;
            if ([str length]>40)
                break;
            const char * ch=[(NSString *)str cStringUsingEncoding:NSASCIIStringEncoding];
            sscanf (ch,"%d=%s",&num,word);
            //  NSLog(@"%d %s",i,word);
            [array addObject:[NSString stringWithFormat:@"%s",word]];
        }
    }
    for (int i=0;i<array.count;++i)
    {
//        NSLog(@"i=%d %@",i,[array objectAtIndex:i]);
    }
    
    imArray = array;
//    return array;
}

+(int) wordCountF{
    return wordCount;    
}



@end
