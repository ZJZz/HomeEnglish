//
//  CCMenuPopup.m
//  Mole It
//
//  Created by Todd Perkins on 8/1/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "CCMenuPopup.h"
//#import "CCMenu.h"
#import "PopUp.h"

@implementation CCMenuPopup

-(void)registerWithTouchDispatcher
{
    CCLOG(@"CCMenuPopup registerWithTouchDispatcher ________________");
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-1001 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"CCMenuPopup ccTouchBegan ________________");
    
    if (![super itemForTouch:touch]) {
        CCLOG(@"CCMenuPopup ccTouchBegan ________________01");
        return NO;
    }
    NSArray *ancestors = [NSArray arrayWithObjects:self.parent,self.parent.parent,self.parent.parent.parent, nil];
    for (CCNode *n in ancestors) {
        CCLOG(@"CCMenuPopup ccTouchBegan ________________011");
        if ([n isKindOfClass:[PopUp class]]) {
            CCLOG(@"CCMenuPopup ccTouchBegan ________________012");
            [(PopUp *)n closePopUp];
        }
    }
    CCLOG(@"CCMenuPopup ccTouchBegan ________________02");
    
    return [super ccTouchBegan:touch withEvent:event];
}

@end
