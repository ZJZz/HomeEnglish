//
//  flashLayger.h
//  homeEnglish
//
//  Created by david zhao on 12-5-18.
//  Copyright 2012年 itech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import <MediaPlayer/MediaPlayer.h>

@interface flashLayger : CCLayer {
    MPMoviePlayerController *mpcontrol;    
}

// returns a CCScene that contains the flashLayger as the only child
+(CCScene *) scene;


@end


