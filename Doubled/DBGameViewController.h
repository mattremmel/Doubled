//
//  DBGameViewController.h
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBGameViewController : UIViewController

- (void)configureCasualGameScene;
- (void)configureTimeAttackGameScene;

- (void)startCasualNewGame;
- (void)startCasualContinueGame;
- (void)startTimeAttackNewGame;
- (void)startTimeAttackContinueGame;

- (void)dismissGameController;

@end
