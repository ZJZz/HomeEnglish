#import "PlayLayer.h"

#import "CCMenuPopup.h"
#import "PopUp.h"


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

#pragma mark init part
-(id) init {
	if( (self=[super init] )) {
		game  = [[Game alloc] init];
		chart = [[Chart alloc] initWith: [game level]];

		
		Skill *bombSkill = [[Bomb alloc] initWithChart:chart linkDelegate:self];
		Skill *suffleSkill = [[Suffle alloc] initWithChart:chart linkDelegate:self];
		
		game.bombSkill = bombSkill;
		game.suffleSkill = suffleSkill;

		[game setState: GameStatePrepare];
		startHintIndex = 0;
		startHintArray = [NSArray arrayWithObjects:
							[NSString stringWithFormat:@"Level %d",[game.level no]],@"Ready",@"Go",nil];
		[startHintArray retain];
		
		self.isTouchEnabled = NO;
		[self initBallsSprite];
		[self initNumberLabel];
		[self initMenu];
	}
	
	return self;
}

-(void) initBallsSprite{
	for (int y=0; y<kRowCount; y++) {
		for (int x=0; x<kColumnCount; x++) {
			Tile *tile = [chart get: ccp(x,y)];
			int posX = (x-1)*kTileSize + kLeftPadding + kTileSize/2;
			int posY = (y-1)*kTileSize + kTopPadding + kTileSize/2;
			
			if (tile.kind < 0) {
				continue;
			}
			
			NSString *imageName = [NSString stringWithFormat: @"q%d.png", tile.kind];
			tile.sprite = [CCSprite spriteWithFile:imageName];
			tile.sprite.scaleX = kDefaultScaleX;
			tile.sprite.scaleY = kDefaultScaleY;
			tile.sprite.position = ccp(posX, posY);
            if ([self uiIPad2or3]) {
                tile.sprite.scale = 1;
            }
			[self addChild: tile.sprite z: 3];
		}
	}
}

-(BOOL) uiIPad2or3{
    NSString *dangqianshebei=[NSString stringWithFormat:@"%@",[[UIScreen mainScreen]preferredMode]];
    NSRange this=[dangqianshebei rangeOfString:@"2048"];
    if (this.location != NSNotFound) {
        return TRUE;
    }else {
        return FALSE;
    }
}

-(void) initNumberLabel{
	{
		CCLabelTTF *scoreValueLabel = 	ccLP(@"0", 28.0f, ccp(50,225));
		[self addChild: scoreValueLabel z:1 tag:kScoreLabelTag];	
	}

	{
		int time = [game.level timeLimit];
		NSString *timeValueString = [NSString stringWithFormat: @"%d", time];
		CCLabelTTF *timeValueLabel = 	ccLP(timeValueString, 28.0f, ccp(50,275));
		[self addChild: timeValueLabel z:1 tag:kTimeLabelTag];
	}
	
	{	
		
		CCLabelTTF *timeLabel = ccLP(@"time", 28.0f, ccp(50,300));
		[self addChild:timeLabel];
	}
	
	{
		CCLabelTTF *scoreLabel = ccLP(@"score", 28.0f, ccp(50,250));
		[self addChild:scoreLabel];
	}
	
}

-(void) initMenu{
	CCMenuItemFont *bombItem = [CCMenuItemFont itemFromString:@"Bomb" target:game.bombSkill selector: @selector(run:)];
	CCMenuItemFont *suffleItem = [CCMenuItemFont itemFromString:@"Suffle" target:game.suffleSkill selector: @selector(run:)];
	CCMenuItemFont *stopItem = [CCMenuItemFont itemFromString:@"Pause" target:self selector: @selector(goPause:)];
	
	game.bombSkill.assItem = bombItem;
	game.suffleSkill.assItem = suffleItem;
	
	CCMenu *menu = [CCMenu menuWithItems:bombItem, suffleItem, stopItem, nil];
	[menu alignItemsVerticallyWithPadding: -1];
	menu.position = ccp(-100,65);
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
	if (startHintIndex >= [startHintArray count]) {
		[self schedule:@selector(checkGameState) interval: kScheduleInterval];
		[startHintArray release];
		startHintArray = nil;
		[game setState:GameStatePlaying];
		self.isTouchEnabled = YES;
		CCNode *menu = [self getChildByTag:kMenuTag];
		[menu runAction:[CCMoveTo actionWithDuration:0.5F position:ccp(50,65)]];
	}else {
		NSString *hintText = [startHintArray objectAtIndex:startHintIndex];		
		
		CCLabelTTF *label = ccLP(hintText, 30.0f, ccp(240,160));
		label.opacity = 170;
		CCAction *action = [CCSequence actions:
							[CCSpawn actions:
							 [CCScaleTo actionWithDuration:0.8f scaleX:2.5f scaleY:2.5f],
							 [CCSequence actions: 
							  [CCFadeTo actionWithDuration: 0.6f opacity:255],
							  [CCFadeTo actionWithDuration: 0.2f opacity:128],
							  nil],
							 nil],
							[CCCallFuncN actionWithTarget:self  selector:@selector(startHintCallback:)],
							nil
							];
		[self addChild:label z:5 tag: kStartHint];
		[label runAction: action];		
		startHintIndex++;
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
    CCLOG(@"playlayer checkGameState:");
	if (game.state == GameStateWin) {
		[self unschedule:@selector(checkGameState)];
		CCLabelTTF *levelClear = ccLP(@"Level Clear", 28.0f, ccp(240, 160));
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
		
		CCLabelTTF *timerUp = ccLP(@"Time Out", 28.0f, ccp(240, 160));
		timerUp.opacity = 60;
		[self addChild: timerUp z: 5];
		[timerUp runAction: [CCSequence actions:
							 [CCFadeTo actionWithDuration:0.5f opacity:244],
							 [CCDelayTime actionWithDuration:1.0f],
							 [CCCallFunc actionWithTarget:self selector:@selector(goNextLevel)],
							 nil]];
		 
		return;
	}else {
		NSString *timeString = [NSString stringWithFormat:@"%d", [game usedTime]];
		CCLabelTTF *timeLabel = (CCLabelTTF *)[self getChildByTag:kTimeLabelTag];
		[timeLabel setString:timeString];
	}
}


//调用成绩窗口接口
//在游戏结束和下一关之间，添加了一个成绩窗口。
-(void) gameScoreWindow {
   
    //游戏成绩变量，值大小：1-10整形；
    int scoreNow = 8;
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
    menu.position = ccp(234, 72);
    PopUp *pop = [PopUp popUpWithTitle:@"-game over-" description:@"" sprite:menu scoreNowSt:scoreNowSt];
    [self addChild:pop z:1000];  

}


-(void) goNextLevel{
    CCLOG(@"playlayer goNextLevel:");
	if (GameStateLost == game.state) {
		[SceneManager goMenu];
	}else {
		[User saveScore: game.score + [User score]];
		[User saveWinedLevel: [game.level no]];
		[User saveUsedTime: game.usedTime];
		
		if([game.level no] == kMaxLevelNo){	
			[NameInputAlertViewDelegate showWinView];
		}else{
			[SceneManager goPlay];		
		}		
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
	CCLabelTTF *scoreAddLabel = ccLP(scoreAddString, 18.0f, ccp(55,160));
	scoreAddLabel.scaleX = 1.0f+kindCount/4;
	scoreAddLabel.scaleY = 1.0f+kindCount/4;
	[self addChild: scoreAddLabel z:1];
	CCAction *action = [CCSequence actions:
						[CCSpawn actions:
						 [CCMoveTo actionWithDuration: 1.0F position:ccp(55,225)],
						 [CCFadeOut actionWithDuration: 1.0F ],
						 nil],
						[CCCallFuncN actionWithTarget: self selector: @selector(scoreAddLabelActionDone:)],				
						nil];
	[scoreAddLabel runAction: action]; 
	
    //移动后的Sprite的位置
	if (kindCount==1) {
		CCSprite *previousComboSprite = (CCSprite *)[self getChildByTag: kComboTag];
		if (previousComboSprite) {
			[self removeChild: previousComboSprite cleanup: YES];
		}
		NSString *imageName = [NSString stringWithFormat:@"q%d.png", kind];
		CCSprite *comboSprite = [CCSprite spriteWithFile: imageName];
        
        if ([self uiIPad2or3]) {
            comboSprite.scale = 2;
        }
		
		comboSprite.scaleX = kDefaultScaleX*3.0;
		comboSprite.scaleY = kDefaultScaleY*3.0;
		comboSprite.tag = kComboTag;
		comboSprite.position = ccp(140,560);
		[self addChild: comboSprite z:1];
	}
	
	CCLabelTTF *comboNoLabel = (CCLabelTTF *)[self getChildByTag: kComboNOTag];
	if (!comboNoLabel) {
		comboNoLabel = ccLP(@"0", 24.0F, ccp(70,160));
		comboNoLabel.tag = kComboNOTag;
		[self addChild: comboNoLabel z:1];
	}
	[comboNoLabel setString: [NSString stringWithFormat:@"X %d", kindCount]];
	
	[chart packA: aTile B: bTile];	
}

//触屏事件
- (void)ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	UITouch* touch = [touches anyObject];
	CGPoint location = [touch locationInView: touch.view];
	location = [[CCDirector sharedDirector] convertToGL: location];
	
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
@end
