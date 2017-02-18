//
//  SceneTo.h
//  homeEnglish
//
//  Created by david zhao on 12-11-20.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//单词大小
#define BLANKWIDTH     202
#define BLANKHEIGHT    262

@interface SceneTo : NSObject {    
    NSString *master_url;
//    int SceneNumber;
    
    
}

+(void) toSceneScene:(int)j;
+(void) toSceneGame:(int)j;
+(void) toUserNumberF:(int)j;
+(void) toAPPusername:(NSString *)name;

+(BOOL) uiIpadBack;
+(void) uiIPad2or3;

+(int) SceneNumberF;
+(int) userNumberF;
+(NSString *) SceneNameF;
+(NSString *) fromAPPusername;


+(NSString *) wordSpace:(NSString *)wordName;

//判断blank的右下角边界是否超出屏幕
//返回blank的中心点坐标
+(CGPoint) wordPositonX:(CGPoint)position;

-(void) plusUsedTime;

//save
+(BOOL) saveGameData:(NSMutableArray *)data  saveFileName:(NSString *)fileName;
+(id) loadGameData:(NSString *)fileName;


@end
