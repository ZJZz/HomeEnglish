//
//  MenuInstantiateAppDelegate.h
//  MenuInstantiate
//
//  Created by chen hua on 10/28/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"
//#import "MainMenu.h"
//#import "About.h"
#import "hGardenLayer.h"

@interface InterfaceManager : NSObject {
//    int scaleXY;

}

+( void ) go: ( CCLayer * ) layer;
+( CCScene * ) wrap: ( CCLayer * ) layer;

+( void ) goMainMenu;
+( void ) goAbout;
+( void ) goBack;
+( void ) goLevel: ( short ) level;
//+( void ) goDiffGame:(short) flag;
+( void ) goDiffGame:(NSString *) flag;
+(int) nowLevel;//标志第几个场景
+(int) nowGame;//标志现在第几关
+(int) countForNowGame;//标志这关有几个不同
+(NSString *) gameBackground;//标志这关有几个不同
//这关总点击数++
+(void) allCountUp;
//得到这关总点击数
+(int) allCount;
//新加的方法**************
+(void) killAllWorld;
@end
