//
//  PopUp.h
//  Mole It
//
//  Created by Todd Perkins on 7/29/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "cocos2d.h"

@interface PopUp : CCSprite {
    CCSprite *window,*bg,*scoreFaceSprite,*scoreBodySprite;
    CCNode *container;
    int scaleXY;
}

+(id)popUpWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite scoreNowSt:(NSString *)scoreNowSt;
- (id)initWithTitle: (NSString *)titleText description:(NSString *)description sprite:(CCNode *)sprite scoreNowSt:(NSString*)scoreNowSt;

-(void)closePopUp;

//-(void)allDone:(id)sender;
@end
