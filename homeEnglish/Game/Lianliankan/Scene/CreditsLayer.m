#import "CreditsLayer.h"


@implementation CreditsLayer
-(id) init{
	self = [super init];
	if (!self) {
		return nil;
	}
	
    CGSize size = [[CCDirector sharedDirector] winSize];
    
	CCSprite *bg = [CCSprite spriteWithFile: @"backgroud.png"];
	bg.position = ccp(size.width/2,size.height/2);
    if ([self uiIPad2or3]) {
        bg.scale = 2;
    }
	[self addChild: bg z: 0];
	
	
	CCMenuItemFont *back = [CCMenuItemFont itemFromString:@"back" target:self selector: @selector(back:)];
	CCMenu *menu = [CCMenu menuWithItems: back, nil];
	menu.position = ccp(240, 70);
	[self addChild: menu];
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

-(void) back: (id) sender{
	[SceneManager goMenu];
}

@end
