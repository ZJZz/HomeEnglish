//
//  CCSprite+DisableTouch.m
//  Mole It
//
//  Created by Todd Perkins on 8/1/11.
//  Copyright 2011 Wedgekase Games, LLC. All rights reserved.
//

#import "CCSprite+DisableTouch.h"


@implementation CCSprite (DisableTouch)

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"CCSprite ccTouchBegan ________________");
    return YES;
}

-(void)disableTouch
{
    CCLOG(@"CCSprite disableTouch ________________");
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-1000 swallowsTouches:YES];
}

-(void)enableTouch
{
    CCLOG(@"CCSprite enableTouch ________________");
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

@end
