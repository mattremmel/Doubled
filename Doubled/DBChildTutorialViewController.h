//
//  DBChildTutorialViewController.h
//  Doubled
//
//  Created by Matthew Remmel on 7/21/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DBChildTutorialViewController : UIViewController

@property NSInteger index;

- (void)setActionTarget:(id)target actionDismissTutorial:(SEL)dismissTutorialAction;

@end
