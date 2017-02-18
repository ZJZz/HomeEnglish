//
//  Level1-Bathroom.h
//  homeEnglish
//
//  Created by zhangshuzhen on 12-11-12.
//  Copyright 2012年 itech. All rights reserved.
//


#import "cocos2d.h"
#import "HandleSyn.h"
#import "HandleSprite.h"

@interface LevelGame : HandleSyn {
    
    NSString    *fromSceneName;
    
    NSMutableArray  *datas;//仅仅存放 1 2 3 4 5 6
    NSMutableArray  *useData;//存放随机出来的123456数据
    NSMutableArray  *data_x;//图片的X坐标
    NSMutableArray  *data_y;//图片的Y坐标
    NSMutableArray  *data_x2;//图片的X坐标
    NSMutableArray  *data_y2;//图片的Y坐标
    NSArray         *rightOrError_x;
    NSArray         *rightOrError_y;
    
    NSMutableArray  *arrayWordIndexTemp;
    CGRect          backgroudRect;
    int             firstPx,firstPy;
    int             backgroudRectHigh;
    
    int             tempRectx,  tempRecty;
    float           countRectMultiple;


    
}

@end
