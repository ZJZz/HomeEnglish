#import "cocos2d.h"
@interface BaseLayer : CCLayer {
    
    int scaleXY;    //判断屏幕分辨率
    float scaleSF;    //图片缩小比例参数
    
    CCProgressTimer *planeHPTimer;

}

@end
