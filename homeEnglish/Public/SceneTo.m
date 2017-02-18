//
//  SceneTo.m
//  homeEnglish
//
//  Created by david zhao on 12-11-20.
//  Copyright 2012年 itech. All rights reserved.
//

#import "SceneTo.h"

#import "homeLayer.h"

#import "hGardenLayer.h"
#import "hGarageLayer.h"
#import "hLivingroomLayer.h"
#import "hKitchenLayer.h"
#import "hLibraryLayer.h"
#import "hBathroomLayer.h"
#import "hBedroomLayer.h"
#import "Summary.h"
#import "LevelB1.h"


#import "wyMatchGameLayer.h"
#import "MagicSpellLayer.h"
#import "SceneManager.h"
#import "hVideoLayer.h"

#import "InterfaceManager.h"
#import "hKaraokeLayer.h"


@implementation SceneTo

static bool         uiIpad3;
static int          SceneNumber;
static NSString     *SceneName;
static int          userNumber;
static NSString     *userNameCurrent;


-(id) init{
	self = [super init];	
    CCLOG(@"SceneTo init:");
	return self;
}


//To use space in the replacement string underline.
+(NSString *) wordSpace:(NSString *)wordName{
    
    
    //将字符串中" " 全部替换成 *
    NSString * str = [wordName stringByReplacingOccurrencesOfString :@"_" withString:@" "];
    return str;
    
//    NSMutableString *mstr;    
//    NSRange substr;
//    
//    mstr=[NSMutableString stringWithString:wordName]; //初始化可变字符串
//    
//    substr=[mstr rangeOfString:@"_"];
//    
//    
//    
//    //查找替换某些字符串
//    if (substr.location!=NSNotFound) {
//        [mstr replaceCharactersInRange:substr withString:@" "];
//        return(NSString *)mstr; 
//    }else {
//        return wordName;
//    }
//    return wordName;
    
//    //查找替换某些字符串
//    if (substr.location!=NSNotFound) {
//        while (substr.location!=NSNotFound) {
//            [mstr replaceCharactersInRange:substr withString:@" "];
//        }
//        return(NSString *)mstr; 
//    }else {
//        return wordName;
//    }
//    return wordName;
}

//判断blank的右下角边界是否超出屏幕
//返回blank的中心点坐标
+(CGPoint) wordPositonX:(CGPoint)position{
    
    
    CGSize s = [[CCDirector sharedDirector] winSize];   

    
    if ((position.x + BLANKWIDTH) > s.width){        
        position.x = s.width - BLANKWIDTH/2;
    }else {
        position.x = position.x + BLANKWIDTH/2;
    }
    
    if( (position.y + BLANKHEIGHT) > s.height ){
        position.y = s.height - BLANKHEIGHT/2;
    }else {
        position.y = position.y +BLANKHEIGHT/2;
    }    
    return position;    
}
-(void) plusUsedTime{



}

//返回ipad类型
+(BOOL) uiIpadBack{
    return uiIpad3;
}
+(void) uiIPad2or3{
    NSString *dangqianshebei=[NSString stringWithFormat:@"%@",[[UIScreen mainScreen]preferredMode]];
    NSRange this=[dangqianshebei rangeOfString:@"2048"];
    if (this.location != NSNotFound) {
        uiIpad3 = TRUE;       
    }else {
        uiIpad3 = FALSE;       
    }
}

//
+(void) toAPPusername:(NSString *)name{
    userNameCurrent = name;
}
+(NSString *) fromAPPusername{
    return userNameCurrent;
}


//场景跳转
+(NSString *) SceneNameF{
    CCLOG(@"SceneNameF:%@",SceneName);
//    SceneName = @"Bathroom";
    return SceneName;
}
+ (void) toSceneScene:(int)j{
    CCLOG(@"toSceneScene:%d",j);
    
    NSArray *sceneNameArray = [[NSArray alloc] initWithObjects:
                               @"Livingroom",
                               @"Kitchen",
                               @"Garage",
                               @"Garden",
                               @"Library",
                               @"Bathroom",
                               @"Bedroom",
                               nil];
    

    
    if (j>=0 && j<7) {
        SceneNumber = j;
        SceneName = [sceneNameArray objectAtIndex:j];
    }
    [sceneNameArray release];
    
    
    CCScene* scene;
    
    switch (j) {
        case 0:
            scene = [hLivingroomLayer scene];
            break;
        case 1:
            scene = [hKitchenLayer scene];
            break;
        case 2:
            scene = [hGarageLayer scene];
            break;
        case 3:
            scene = [hGardenLayer scene];
            break;
        case 4:
            scene = [hLibraryLayer scene];
            break;
        case 5:
            scene = [hBathroomLayer scene];
            break;
        case 6:
            scene = [hBedroomLayer scene];
            break;
        case 7:
            scene = [LevelB1 scene];
            break;
        case 8:
            //          导航
            scene = [Summary scene];
            break;            
        default:
            scene = [homeLayer scene];
            break;
    }
    if (scene != NULL ) {
        [[CCDirector sharedDirector] replaceScene:scene];
        //CTransition
        CCTransitionFade* transitionScene = [CCTransitionFade transitionWithDuration:1 scene:scene withColor:ccBLACK];
        [[CCDirector sharedDirector] replaceScene:transitionScene];
    }
    
}

//返回当前用户序号
+(int) userNumberF{
    CCLOG(@"userNumber:%d",userNumber);
    return userNumber;
}

//设置当前用户序号
+(void) toUserNumberF:(int)iNumber{
    CCLOG(@"iNumber:%d",iNumber);
    userNumber = iNumber;
}



//返回场景序号
+(int) SceneNumberF{
    CCLOG(@"SceneNumberF:%d",SceneNumber);
    return SceneNumber;
}
//场景跳转
+ (void) toSceneGame:(int)j{
    CCLOG(@"toScene j:%d",j);
    
    SceneNumber = j;
    

    switch (j) {
        case 0:
            //怪兽大盗            
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MagicSpellLayer sceneWithGround:SceneName] withColor:ccBLACK]];
            break;
        case 1:
            //连连看
            [User clear];
            CCLOG(@"[User winedLevel]:%d",[User winedLevel]);
            [MusicHandler preload];
//            [MusicHandler notifyButtonClick];     
            [SceneManager goPlay];
            break;

        case 5:
            //记忆力
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[wyMatchGameLayer sceneWithGround:SceneName Level:3] withColor:ccBLACK]];            	
            break;
        case 6:
            //找不同            
            [ InterfaceManager goDiffGame:SceneName];
            break;
        case 7:
            //video
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[hVideoLayer scene] withColor:ccBLACK]];
            break;
        case 8:
            //karaok
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[hKaraokeLayer scene] withColor:ccBLACK]];
            break;
            
        default:
            break;
    }

}

//保存游戏数据
//参数介绍：
//   (NSMutableArray *)data ：保存的数据
//   (NSString *)fileName ：存储的文件名
+(BOOL) saveGameData:(NSMutableArray *)data  saveFileName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");
        return NO;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    return ([data writeToFile:appFile atomically:YES]);
}
//读取游戏数据
//参数介绍：
//   (NSString *)fileName ：需要读取数据的文件名
+(id) loadGameData:(NSString *)fileName 
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    NSMutableArray *myData = [[[NSMutableArray alloc] initWithContentsOfFile:appFile] autorelease];
    return myData;
}

@end
