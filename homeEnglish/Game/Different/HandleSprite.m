//
//  HandleSprite.m
//  Untitled
//
//  Created by chen hua on 11/5/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "HandleSprite.h"
//#import "TimeBar.h"
#import "InterfaceManager.h"
static int nCount = 0;

@implementation HandleSprite

@synthesize blnCancel, blnTouched ,flags;

-( CGRect )rect
{
	CGSize s = [self.texture contentSize];
	return CGRectMake( -s.width / 2, -s.height / 2, s.width, s.height );
}

//-(void) setfatherLayer:(HandleSyn *)father{
//    fatherLayer =father;
//}
+( id )paddleWithTexture:(CCTexture2D *)aTexture
{
	return [[[self alloc] initWithTexture:aTexture] autorelease];
}

-( void ) setSynSprint:( CCSprite * ) s
{
	synSprite = s;
}
 
+( void ) setCount:(int)c
{
	nCount = c;
}

-( void ) drawChecked2:(CCSprite *) ccs
{
    ccs.visible =NO;
}

- (void)onEnter
{

	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{

	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{

#pragma mark --------- 如果当前触摸点与自己所在位置吻合 则对应是点上了 返回true----------
	return CGRectContainsPoint(self.rect, [self convertTouchToNodeSpaceAR:touch]);
}

-( void ) drawChecked:(CCSprite *) ccs
{ 
    CCSprite *checked =[ccs retain];
    checked.visible =NO; 
    [[[self parent] parent] rightOrErrorCountdo:ccs.tag];
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if(blnTouched == YES){
        [InterfaceManager allCountUp];
    }else
    if(blnTouched == NO){
        nCount++;
        CCLOG(@"x现在已点击%i",nCount);
        CCLOG(@"xx");
        blnTouched =YES;
        
        CCArray *arr = [synSprite children];//得到找茬背景图所用数组
        
        [[[self parent] parent] removerightOrError:self.tag];//播放音乐 以及画出下面的图片
        CCLOG(@"self.tag-- %d",self.tag);
        [[[self parent] parent] setrightOrErrorCount:nCount];//设置当前已经点中几个正确的了
        
        [self drawChecked:self];//设置自己这个不同图片不可见
        //同步另一张图的对应不同设置不可见
        [[ arr objectAtIndex:self.flags-1 ] drawChecked2:[ arr objectAtIndex:flags-1]];//在右边那张背景图花圈
        [[ arr objectAtIndex:self.flags-1 ] setBlnTouched:YES];
        
        //如果到3个弹出答案界面
        if(nCount == [InterfaceManager countForNowGame]){
        [InterfaceManager gameOver:[[self parent]parent]];
            nCount=0;
        } 
    }
    
}
-( void ) dealloc
{
    nCount =0;
	[ super dealloc ];
}

@end
