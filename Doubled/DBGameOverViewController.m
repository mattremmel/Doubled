//
//  DBGameOverViewController.m
//  Doubled
//
//  Created by Matthew on 8/7/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameOverViewController.h"
#import "DBGameGlobals.h"
#import <GameKit/GameKit.h>
#import "DBGameScene.h"

@interface DBGameOverViewController () <GKGameCenterControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *mViewBackground;

@property (weak, nonatomic) IBOutlet UILabel *mLabelTitle;
@property (weak, nonatomic) IBOutlet UIView *mViewScoreBackground;
@property (weak, nonatomic) IBOutlet UILabel *mLabelScore;
@property (weak, nonatomic) IBOutlet UIView *mViewHighScoreBackground;
@property (weak, nonatomic) IBOutlet UILabel *mLabelHighScore;

@property (weak, nonatomic) IBOutlet UIButton *mButtonLeaderboard;
@property (weak, nonatomic) IBOutlet UIButton *mButtonNewGame;
@property (weak, nonatomic) IBOutlet UIButton *mButtonMainMenu;

@property (weak, nonatomic) id mSELTarget;
@property SEL mActionNewGame;
@property SEL mActionMainMenu;
@property SEL mActionLeaderboard;

@property NSInteger mScore;
@property NSInteger mHighScore;

@end

@implementation DBGameOverViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self styleView];
}

- (void)styleView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:0.6];
    self.view.userInteractionEnabled = true;
    
    self.mViewBackground.backgroundColor = StandardBackgroundColor;
    self.mViewBackground.layer.cornerRadius = 15;
    self.mViewBackground.layer.shadowOpacity = 0.8;
    self.mViewBackground.layer.shadowOffset = MenuButtonShadowOffset;
    
    self.mViewScoreBackground.backgroundColor = StandardHUDColor;
    self.mViewScoreBackground.layer.cornerRadius = MenuButtonCornerRadius;
    
    self.mViewHighScoreBackground.backgroundColor = StandardHUDColor;
    self.mViewHighScoreBackground.layer.cornerRadius = MenuButtonCornerRadius;
    
    self.mButtonLeaderboard.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonLeaderboard.backgroundColor = StandardHUDColor;
    [self.mButtonLeaderboard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.mButtonNewGame.backgroundColor = StandardButtonColor;
    [self.mButtonNewGame setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    
    self.mButtonMainMenu.backgroundColor = StandardButtonColor;
    [self.mButtonMainMenu setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    
    self.mLabelScore.textAlignment = NSTextAlignmentCenter;
    self.mLabelScore.adjustsFontSizeToFitWidth = true;
    
    self.mLabelHighScore.textAlignment = NSTextAlignmentCenter;
    self.mLabelHighScore.adjustsFontSizeToFitWidth = true;
    
    [self.mButtonNewGame addTarget:self action:@selector(buttonNewGameNormalColor) forControlEvents:UIControlEventTouchUpInside];
    [self.mButtonNewGame addTarget:self action:@selector(buttonNewGameNormalColor) forControlEvents:UIControlEventTouchUpOutside];
    [self.mButtonNewGame addTarget:self action:@selector(buttonNewGameHighlightColor) forControlEvents:UIControlEventTouchDown];
    [self.mButtonMainMenu addTarget:self action:@selector(buttonMainMenuNormalColor) forControlEvents:UIControlEventTouchUpInside];
    [self.mButtonMainMenu addTarget:self action:@selector(buttonMainMenuNormalColor) forControlEvents:UIControlEventTouchUpOutside];
    [self.mButtonMainMenu addTarget:self action:@selector(buttonMainMenuHighlightColor) forControlEvents:UIControlEventTouchDown];
    [self.mButtonLeaderboard addTarget:self action:@selector(buttonLeaderboardNormalColor) forControlEvents:UIControlEventTouchUpInside];
    [self.mButtonLeaderboard addTarget:self action:@selector(buttonLeaderboardNormalColor) forControlEvents:UIControlEventTouchUpOutside];
    [self.mButtonLeaderboard addTarget:self action:@selector(buttonLeaderboardHighlightColor) forControlEvents:UIControlEventTouchDown];
}


#pragma mark - Button Highlights

- (void)buttonNewGameNormalColor {
    self.mButtonNewGame.backgroundColor = StandardButtonColor;
}

- (void)buttonNewGameHighlightColor {
    self.mButtonNewGame.backgroundColor = StandardButtonPressedColor;
}

- (void)buttonMainMenuNormalColor {
    self.mButtonMainMenu.backgroundColor = StandardButtonColor;
}

- (void)buttonMainMenuHighlightColor {
    self.mButtonMainMenu.backgroundColor = StandardButtonPressedColor;
}

- (void)buttonLeaderboardNormalColor {
    self.mButtonLeaderboard.backgroundColor = StandardHUDColor;
}

- (void)buttonLeaderboardHighlightColor {
    self.mButtonLeaderboard.backgroundColor = StandardHUDPressedColor;
}


#pragma mark - View Delegate

- (void)viewWillAppear:(BOOL)animated
{
    self.mLabelScore.text = [NSString stringWithFormat:@"%li", (long)self.mScore];
    self.mLabelHighScore.text = [NSString stringWithFormat:@"%li", (long)self.mHighScore];
    
    if (self.mScore == self.mHighScore)
    {
        self.mLabelTitle.text = @"New High Score!";
    }
    else
    {
        self.mLabelTitle.text = @"Game Over";
    }
}


#pragma mark - Setter Methods

- (void)setActionTarget:(id)target actionNewGame:(SEL)newGameAction actionMainMenu:(SEL)mainMenuAction actionLeaderboard:(SEL)leaderboardAction
{
    self.mSELTarget = target;
    self.mActionNewGame = newGameAction;
    self.mActionMainMenu = mainMenuAction;
    self.mActionLeaderboard = leaderboardAction;
}

- (void)setScore:(NSInteger)score andHighScore:(NSInteger)highScore
{
    self.mScore = score;
    self.mHighScore = highScore;
}


#pragma mark - View Methods

- (void)showInView:(UIView *)view animated:(BOOL)animated
{
    [view addSubview:self.view];
    if (animated)
    {
        [self showAnimate];
    }
}

- (void)showAnimate
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)hideAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
    }];
}

- (void)removeAnimate
{
    [UIView animateWithDuration:.25 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}


#pragma mark - Button Events

- (IBAction)buttonNewGame:(id)sender
{
    [self removeAnimate];
    if ([self.mSELTarget respondsToSelector:self.mActionNewGame])
    {
        [self.mSELTarget performSelector:self.mActionNewGame];
    }
}

- (IBAction)buttonMainMenu:(id)sender
{
    if ([self.mSELTarget respondsToSelector:self.mActionMainMenu])
    {
        [self.mSELTarget performSelector:self.mActionMainMenu];
    }
}

- (IBAction)buttonLeaderboard:(id)sender
{
    [self showLeaderboardAndAchievements];
}


#pragma mark - Game Center Callback

- (void)showLeaderboardAndAchievements
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
    gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
    [self presentViewController:gcViewController animated:YES completion:nil];
}

-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Touch Events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self hideAnimate];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showAnimate];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self showAnimate];
}

@end
