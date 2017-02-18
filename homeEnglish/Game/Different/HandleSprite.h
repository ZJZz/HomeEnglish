//
//  HandleSprite.h
//  Untitled
//
//  Created by chen hua on 11/5/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
//#import "sign.h"
#import "HandleSyn.h"

@interface HandleSprite : CCSprite <CCTargetedTouchDelegate> 
{
	CCSprite *synSprite;
	@public BOOL blnTouched;
	@public BOOL blnCancel;
    int flags;//标志你是第几个 一共有6个 但是数组 只存3个所以需要一个标志 自己的次序

}

@property BOOL blnCancel, blnTouched;

@property int flags;

@property(nonatomic, readonly) CGRect rect;
+( id )paddleWithTexture:(CCTexture2D *)texture;
-( void ) setSynSprint:( CCSprite * ) s;
-( void ) drawChecked:( CCSprite * ) s;
-( void ) drawChecked2:( CCSprite * ) s; 
+( void ) setCount:( int ) c; 
@end
