//
//  wyGameBrain.m
//  homeEnglish
//
//  Created by zzn on 12-11-6.
//  Copyright (c) 2012年 itech. All rights reserved.
//

#import "wyGameBrain.h"

@implementation wyGameBrain
@synthesize tounchCount;
@synthesize cardNum;
-(id) initWithLevel:(int)level Sum:(int) sum
{
    if (self=[super init])
    {
        NSMutableArray * arr = [[NSMutableArray alloc] init];
        NSMutableArray * value = [[NSMutableArray alloc] init];
        if (sum<level) level=sum;
        if (level*2>CARDHEIGHT*CARDWIDTH) level=CARDHEIGHT*CARDWIDTH/2;
        cardNum=level*2;
        [self getRandArrayOfSum:CARDSUM Need:level*2 ArrayM:arr];
        [self getRandArrayOfSum:sum Need:level ArrayM:value];
        
        for (int i=0;i<CARDHEIGHT;++i)
        {
            for (int j=0;j<CARDWIDTH;++j)
            {
                maze[i][j].exist=NO;
                maze[i][j].visiable=NO;
                maze[i][j].value=-1;
            }
        }
        NSLog(@"value count=%d level=%d",[arr count],level);
        for (int i=0;i<level;++i)
        {
            int index0=[[arr objectAtIndex:i*2]intValue],index1=[[arr objectAtIndex:i*2+1]intValue];
            maze[index0/CARDWIDTH][index0%CARDWIDTH].exist=YES;
            maze[index0/CARDWIDTH][index0%CARDWIDTH].value=[[value objectAtIndex:i]intValue];
            maze[index1/CARDWIDTH][index1%CARDWIDTH].exist=YES;
            maze[index1/CARDWIDTH][index1%CARDWIDTH].value=[[value objectAtIndex:i]intValue];
        }
        [value release];
        [arr release];
    
    }
    return  self;
}
-(BOOL) judgeTwoCards
{
    if (maze[touchI[0]][touchJ[0]].value==maze[touchI[1]][touchJ[1]].value)
        return YES;
    else return NO;
}
-(BOOL) touchI:(int)i J:(int)j
{
  //  NSLog(@"touch i=%d j=%d",i,j);
    if (maze[i][j].exist==YES && maze[i][j].visiable==NO)
    {
        return YES;
    }
    return NO;
}
-(void) changeVisiableI:(int) i J:(int) j
{
    if (maze[i][j].visiable==YES) maze[i][j].visiable=NO;
    else
    {
        maze[i][j].visiable=YES;
        touchI[tounchCount]=i,touchJ[tounchCount]=j;
        tounchCount++;
    }
}
-(void) getRandArrayOfSum:(int) sum Need:(int) need ArrayM:(NSMutableArray *) arrayM
{
    int rand;
    NSMutableArray *arr=[[NSMutableArray alloc]init ];
//    NSMutableArray * result=[[NSMutableArray alloc]init ] ;
    for (int i=0;i<sum;++i)
        [arr addObject:[NSNumber numberWithInt:i]];
    for (int i=0;i<need;++i)
    {
        //int s=[arr count];
        
        rand=arc4random()%[arr count];
        [arrayM addObject:[arr objectAtIndex:rand]];
        [arr removeObjectAtIndex:rand];
    }
     
  
//    arrayM =result;
    [arr release];
//    [result release];
//    return result;
}
-(void) CardIndex:(int)index I:(int *)i J:(int *)j
{
    *i=touchI[index];
    *j=touchJ[index];
}
-(Card) cardOfI:(int)i J:(int)j
{
    return maze[i][j];
}
@end
