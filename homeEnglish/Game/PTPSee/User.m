#import "User.h"
#import "constants.h"

@implementation User

#pragma mark clear 
+(void) clear{
	[User saveScore:0];
	[User saveWinedLevel:1];
    
	[User saveUsedTime:0];
}

#pragma mark get
+(NSString *) name{
	return [[NSUserDefaults standardUserDefaults] stringForKey:kName];
}

+(int) score{
	int score = [[NSUserDefaults standardUserDefaults] integerForKey: kScore];	
	if (score < 0) {
		return 0;
	}
	return score;
}

+(int) usedTime{
	return [[NSUserDefaults standardUserDefaults] integerForKey: kUsedTime];
}

+(int) winedLevel{
	int winedLevel = [[NSUserDefaults standardUserDefaults] integerForKey: kWindedLevel];	
	if (winedLevel <= 0) {
		return 0;
	}
    NSLog(@"winedLevel:  %d",winedLevel);
	return winedLevel;
}

+(int) nextLevel{
	int winedLevel = [User winedLevel];
	return winedLevel % kMaxLevelNo + 1;
}
#pragma mark set

+(void) saveName: (NSString *) name{
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:kName];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


+(void) saveScore: (int) score{
	[[NSUserDefaults standardUserDefaults] setInteger:score forKey:kScore];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
+(void) saveWinedLevel: (int) winedLevel{
//	if ([User winedLevel] >= winedLevel) {
//		return;
//	}
    if (winedLevel >= kMaxLevelNo) {
        winedLevel = 9;
    }
    NSLog(@"user saveWinedLevel:%d",winedLevel);
	[[NSUserDefaults standardUserDefaults] setInteger: winedLevel forKey:kWindedLevel];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+(void) saveUsedTime: (int) usedTime{
	[[NSUserDefaults standardUserDefaults] setInteger:usedTime forKey:kUsedTime];
	[[NSUserDefaults standardUserDefaults] synchronize];	
}
@end
