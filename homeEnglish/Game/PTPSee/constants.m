#import "cocos2d.h"

static NSString *DEFAULT_FONT = @"Marker Felt";

CCLabelTTF * ccL(NSString * value, float fontSize){
	return [CCLabelTTF labelWithString:value fontName:DEFAULT_FONT fontSize:fontSize];
}

CCLabelTTF * ccLP(NSString * value, float fontSize, CGPoint pos){
	CCLabelTTF * result = [CCLabelTTF labelWithString:value fontName:DEFAULT_FONT fontSize:fontSize];
	result.position = pos;
	return result;
}
