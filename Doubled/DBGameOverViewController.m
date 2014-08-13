//
//  DBGameOverViewController.m
//  Doubled
//
//  Created by Matthew on 8/7/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameOverViewController.h"
#import "DBGameGlobals.h"

@interface DBGameOverViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewBackground;

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIView *viewScoreBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelScore;
@property (weak, nonatomic) IBOutlet UIView *viewHighScoreBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelHighScore;

@property (weak, nonatomic) IBOutlet UIButton *buttonLeaderboard;
@property (weak, nonatomic) IBOutlet UIButton *buttonNewGame;
@property (weak, nonatomic) IBOutlet UIButton *buttonMainMenu;

@property (weak, nonatomic) id target;
@property SEL actionNewGame;
@property SEL actionMainMenu;
@property SEL actionLeaderboard;

@property NSInteger score;
@property NSInteger highScore;

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
    
    self.viewBackground.backgroundColor = defaultBackgroundColor;
    self.viewBackground.layer.cornerRadius = 15;
    self.viewBackground.layer.shadowOpacity = 0.8;
    self.viewBackground.layer.shadowOffset = MenuButtonShadowOffset;
    
    self.viewScoreBackground.backgroundColor = defaultHUDColor;
    self.viewScoreBackground.layer.cornerRadius = MenuButtonCornerRadius;
    
    self.viewHighScoreBackground.backgroundColor = defaultHUDColor;
    self.viewHighScoreBackground.layer.cornerRadius = MenuButtonCornerRadius;
    
    self.buttonLeaderboard.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonLeaderboard.backgroundColor = defaultHUDColor;
    [self.buttonLeaderboard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.buttonNewGame.backgroundColor = defaultButtonColor;
    [self.buttonNewGame setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    
    self.buttonMainMenu.backgroundColor = defaultButtonColor;
    [self.buttonMainMenu setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    
    self.labelScore.textAlignment = NSTextAlignmentCenter;
    self.labelScore.adjustsFontSizeToFitWidth = true;
    
    self.labelHighScore.textAlignment = NSTextAlignmentCenter;
    self.labelHighScore.adjustsFontSizeToFitWidth = true;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.labelScore.text = [NSString stringWithFormat:@"%li", (long)self.score];
    self.labelHighScore.text = [NSString stringWithFormat:@"%li", (long)self.highScore];
    
    if (self.score == self.highScore)
    {
        self.labelTitle.text = @"New High Score!";
    }
    else
    {
        self.labelTitle.text = @"Game Over";
    }
}


#pragma mark - Setter Methods

- (void)setActionTarget:(id)target actionNewGame:(SEL)newGameAction actionMainMenu:(SEL)mainMenuAction actionLeaderboard:(SEL)leaderboardAction
{
    self.target = target;
    self.actionNewGame = newGameAction;
    self.actionMainMenu = mainMenuAction;
    self.actionLeaderboard = leaderboardAction;
}

- (void)setScore:(NSInteger)score andHighScore:(NSInteger)highScore
{
    self.score = score;
    self.highScore = highScore;
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
    if ([self.target respondsToSelector:self.actionNewGame])
    {
        [self.target performSelector:self.actionNewGame];
    }
}

- (IBAction)buttonMainMenu:(id)sender
{
    if ([self.target respondsToSelector:self.actionMainMenu])
    {
        [self.target performSelector:self.actionMainMenu];
    }
}

- (IBAction)buttonLeaderboard:(id)sender
{
    if ([self.target respondsToSelector:self.actionLeaderboard])
    {
        [self.target performSelector:self.actionLeaderboard];
    }
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
