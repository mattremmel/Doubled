//
//  DBGameOverViewController.h
//  Doubled
//
//  Created by Matthew on 8/7/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBGameOverViewController : UIViewController

- (void)setActionTarget:(id)target actionNewGame:(SEL)newGameAction actionMainMenu:(SEL)mainMenuAction actionLeaderboard:(SEL)leaderboardAction;
- (void)setScore:(NSInteger)score andHighScore:(NSInteger)highScore;
- (void)showInView:(UIView *)view animated:(BOOL)animated;


@end
