#import "cocos2d.h"
#import "Tile.h"
#import "constants.h"
#import "Level.h"
enum {
	horitional = 1,
	vertical
};

@interface Chart : NSObject{
	Level *level;
	@private
	NSMutableArray * content;
	NSMutableArray * ballTiles;
	NSMutableArray * startExtension;
	NSMutableArray * endExtension;
    
    int scaleXY;    //判断屏幕分辨率
    float scaleSF;    //图片缩小比例参数
}
@property (retain, nonatomic) Level *level;
@property (readonly, nonatomic) NSMutableArray *ballTiles;

-(id) initWith: (Level *) alevel;
-(Tile *) get: (CGPoint) position;
-(BOOL) isConnectStart: (Tile *) start end: (Tile *) end;
-(void) dismissTile: (Tile *) tile;
-(void) afterDimiss: (id) node;
-(void) packA: (Tile *) a B: (Tile *) b;
-(void) moveA: (Tile *) a B: (Tile *) b;
@end;