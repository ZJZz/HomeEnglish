//
//  wyMatchGameLayer.h
//  wyMatchGame
//
//  Created by wenyuan on 12-11-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "wyGameBrain.h"
@interface wyMatchGameLayer : CCLayer {
    wyGameBrain *wy;
    CCSprite * cards[CARDHEIGHT][CARDWIDTH ];
    CCSprite * blank[CARDHEIGHT][CARDWIDTH ];
    
    NSArray * imArray;
    NSArray * sounds;
    NSMutableArray * focusCardI;
    NSMutableArray *focusCardJ;
    NSMutableArray * beforeFocusCardI;
    NSMutableArray * beforeFocusCardJ;
    CCSprite * showWord;
    CCLabelTTF * showWordLabel;
    CCTexture2D  * newTexture;
    int showIndex;
    NSString * ground;
    int Level;
    int touchNum;
    
    int scaleXY;
}

+(CCScene *) sceneWithGround:(NSString *) g Level:(int) l;

@end


