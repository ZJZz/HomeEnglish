//
//  MagicSpellLayer.h
//  homeEnglish
//
//  Created by Tony Zhao on 12-10-29.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "time.h"
#import "PopUp.h"
#import "MagicSpellManagerLevel.h"

@interface MagicSpellLayer : CCLayer
{
    int fruitPositionX[4];//气球上水果的横坐标
    int fruitPositionY[4];//气球上水果的纵坐标
    int snakeWillEat[4];//蛇吃水果吃顺序的数组
    int spiderWillEat[4];//蜘蛛吃水果顺序的数组
    int snakeHave[10];//蛇拥有的水果
    int spiderHave[10];//蜘蛛有的水果
    int randomFruit[4];//存放产生随机水果
    int randomFruitCount;//本关的水果数
    int clownorder[4];//小丑要水果的顺序
    int choseTime;//第几次选
    int numEat;//全局第几次吃水果
    int snakeHaveOrder;//蛇第几次吃水果
    int spiderHaveOrder;//蜘蛛第几次水果
    int askTime;//小丑询问次数
    int choseRight;
    int count;//选对的次数
    int snakeRight;//在蛇选对了
    int spiderRight;//在蜘蛛选对了
    int fruitSound;//水果声音的名字
    int clownAskFruitSound;//小丑要水果的名字
    int level;//关数
    int score;//分数
    int sceneX;//此时在哪个场景
    int scaleXY;
    
    bool terminate;
    
    NSString * fromSceneName;
}

//+(CCScene *) scene;
+(CCScene *) sceneWithGround:(NSString *) fromScene ;


@end
