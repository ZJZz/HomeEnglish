#import "BaseLayer.h"


@implementation BaseLayer
-(id) init{
	self = [super init];
	if(nil == self){
		return nil;
	}
	
	self.isTouchEnabled = YES;
    
    CGSize size = [[CCDirector sharedDirector] winSize];
	
	CCSprite *bg = [CCSprite spriteWithFile: @"backgroud.png"];
//	bg.position = ccp(240,160);
    bg.position = ccp(size.width/2,size.height/2);
    if ([self uiIPad2or3]) {
        bg.scale = 2;
    }
	[self addChild: bg z:0];
	
	
	return self;
}
-(BOOL) uiIPad2or3{
    NSString *dangqianshebei=[NSString stringWithFormat:@"%@",[[UIScreen mainScreen]preferredMode]];
    NSRange this=[dangqianshebei rangeOfString:@"2048"];
    if (this.location != NSNotFound) {
        return TRUE;
    }else {
        return FALSE;
    }
}
@end
