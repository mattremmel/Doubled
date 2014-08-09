//
//  DBGameOptionViewController.h
//  Doubled
//
//  Created by Matthew Remmel on 7/31/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBGameOptionViewController : UIViewController

- (void)setActionTarget:(id)target actionNewGame:(SEL)newGameAction actionContinueGame:(SEL)continueAction;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
- (void)removeFromView;

@end
