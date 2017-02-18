//
//  wyGameBrain.h
//  homeEnglish
//
//  Created by zzn on 12-11-6.
//  Copyright (c) 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#define  CARDWIDTH 5
#define CARDHEIGHT 4
#define  CARDSUM  CARDWIDTH*CARDHEIGHT
typedef  struct 
{
    Boolean exist;
    Boolean visiable;
    int value;
} Card;
@interface wyGameBrain : NSObject
{
    Card maze[CARDHEIGHT][CARDWIDTH ];
    int touchI[2],touchJ[2];
    int tounchCount;
    int cardNum;

}
-(BOOL) touchI:(int)i J:(int) j;
-(void) changeVisiableI:(int) i J:(int) j;
-(id) initWithLevel:(int)level Sum:(int)sum;
-(BOOL) judgeTwoCards;
//+(NSMutableArray *) getRandArrayOfSum:(int) sum Need:(int) need;
-(Card) cardOfI:(int)i J:(int)j;
-(void) CardIndex:(int) index I:(int *)i J:(int *)j;
@property (nonatomic) int tounchCount;
@property(nonatomic)   int cardNum;
@end
