//
//  MRGameViewController.h
//  Doubled
//
//  Created by Matthew Remmel on 6/13/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "DBGameGlobals.h"

@interface MRGameViewController : UIViewController

@property GameModes gameMode;
- (void)showHighScoreNormalLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard;

@end
