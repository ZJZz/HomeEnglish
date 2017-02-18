//
//  touch.h
//  Untitled
//
//  Created by chen hua on 11/5/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
#import "HandleSprite.h"

@interface HandleSyn : CCLayer <CCTargetedTouchDelegate> {
	CCSprite *synSprite;// 游戏分两边 这个是另一个
    NSArray *word1,*word2;//word1 存放6个单词的数组 word2 本来用来确定坐标的现在弃用了
    int r1,r2,r3;//存放随机数
    CGSize winSize;//大小
    int rightOrErrorCount;//统计现在按对了几个
    
    NSString *wn1,*wn2,*wn3,*wn4,*wn5,*wn6;//三张随机的图片
    CCSprite *rightOrError1;//中间的叉叉1
    CCSprite *rightOrError2;//中间的叉叉2
    CCSprite *rightOrError3;//中间的叉叉3
    CCSprite *rightOrError4;//中间的叉叉3
    CCSprite *rightOrError5;//中间的叉叉3
    CCSprite *rightOrError6;//中间的叉叉3
    
    UITextField  *text2 ;
//    UILabel *wordLable1;
//    UILabel *wordLable2;
//    UILabel *wordLable3;
//    UILabel *wordLable4;
//    UILabel *wordLable5;
//    UILabel *wordLable6;
    
    CCLabelTTF *wordLable1;
    CCLabelTTF *wordLable2;
    CCLabelTTF *wordLable3;
    CCLabelTTF *wordLable4;
    CCLabelTTF *wordLable5;
    CCLabelTTF *wordLable6;
    
    int scaleXY;
}

- (void) setSynSprint:( CCSprite * ) s;
- (void) onGameMenu: (id)sender;
- (void) onGameHelp: (id)sender;
- (void) rightOrErrorCountdo:(int)tag;//点中之后 设置当前sprite不可见并且发出声音
- (void) setrightOrErrorCount:(int)count;//设置当前已点击个数
- (void) removerightOrError:(int)flag;//去除中间的圆圈;
- (void)wordsLable_deall;//去除UILable
@end
