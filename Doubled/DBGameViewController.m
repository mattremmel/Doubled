//
//  DBGameViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 8/1/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "DBGameScene.h"
#import "DBCasualGameScene.h"
#import "DBTimeAttackGameScene.h"
#import "DBRemoveAdsBanner.h"
#import "DoubledIAPHelper.h"
#import "DBGameGlobals.h"
#import "MPAdView.h"


@interface DBGameViewController () <MPAdViewDelegate>

@property DBCasualGameScene *casualGameScene;
@property DBTimeAttackGameScene *timeAttackGameScene;
@property SKView *skView;

@property (nonatomic, retain)MPAdView *mpAdView;
@property BOOL mpAdViewIsVisible;
@property DBRemoveAdsBanner *removeAdsBanner;
@property BOOL removeAdsBannerIsVisible;

@end

@implementation DBGameViewController


#pragma mark - Initilization

- (id)init
{
    NSLog(@"CONT: Game controller initilized");
    self = [super init];
    if (self)
    {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self configureCasualGameScene];
        [self configureTimeAttackGameScene];
    }
    
    return self;
}


#pragma mark - View Delegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Purchase Observer
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(removeAdsPurchased) name:IAPHelperProductPurchasedNotification object:nil];
    
    [self configureBannerView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:self.removeAdsBanner];
    [self.view bringSubviewToFront:self.mpAdView];
    [self loadMPAd];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Configuration

- (void)configureBannerView
{
    if (deviceType == iPadType) {
        self.mpAdView = [[MPAdView alloc] initWithAdUnitId:@"0d340afee3c24c23a7195878584d2482" size:MOPUB_LEADERBOARD_SIZE];
    }
    else {
        self.mpAdView = [[MPAdView alloc] initWithAdUnitId:@"6f2ed59709654058a062bfb489a65eca" size:MOPUB_BANNER_SIZE];
    }
    
    self.mpAdView.delegate = self;
    CGRect frame = self.mpAdView.frame;
    CGSize size = [self.mpAdView adContentViewSize];
    frame.origin.y = [[UIScreen mainScreen] applicationFrame].size.height - size.height;
    self.mpAdView.frame = frame;
    
    [self configureRemoveAdsBanner];
}

- (void)configureRemoveAdsBanner
{
    NSLog(@"BAN:  Configuring remove ads banner");
    
    self.removeAdsBanner = [[DBRemoveAdsBanner alloc] init];
    [self.removeAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height, self.removeAdsBanner.frame.size.width, self.removeAdsBanner.frame.size.height)]; // Start off screen
    [self.removeAdsBanner setBackgroundColor: [UIColor blackColor]];
    [self.removeAdsBanner setUserInteractionEnabled: true];
    [self.view addSubview: self.removeAdsBanner];
}

- (void)configureCasualGameScene
{
    self.casualGameScene = [[DBCasualGameScene alloc] initWithSize:self.view.frame.size];
    self.casualGameScene.gameController = self;
}

- (void)configureTimeAttackGameScene
{
    self.timeAttackGameScene = [[DBTimeAttackGameScene alloc] initWithSize:self.view.frame.size];
    self.timeAttackGameScene.gameController = self;
}


#pragma mark - Start Game

- (void)startCasualNewGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.casualGameScene setupNewGame];
    [self presentViewWithScene:self.casualGameScene];
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting continue casual game scene");
    [self.casualGameScene setupContinueGame];
    [self presentViewWithScene:self.casualGameScene];
}

- (void)startTimeAttackNewGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.timeAttackGameScene setupNewGame];
    [self presentViewWithScene:self.timeAttackGameScene];
}

- (void)startTimeAttackContinueGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.timeAttackGameScene setupContinueGame];
    [self presentViewWithScene:self.timeAttackGameScene];
}

- (void)presentViewWithScene:(DBGameScene *)scene
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:self.skView];
    [self.skView presentScene:scene];
    [scene addInterface];
}

- (BOOL)casualGameInProgress
{
    return (self.casualGameScene.gameData.score > 300) ? true : false;
}

- (BOOL)timeAttackGameInProgress
{
    return (self.timeAttackGameScene.gameData.score > 300) ? true : false;
}


#pragma - Load Ads

- (void)loadMPAd
{
    [self.mpAdView loadAd];
}


#pragma mark - Remove Ads Purchase

- (void)removeAdsPurchased
{
    NSLog(@"Remove ads purchased");
    
    [self.mpAdView removeFromSuperview];
    self.mpAdView = nil;
    
    [self.removeAdsBanner removeFromSuperview];
    self.removeAdsBanner = nil;
}

#pragma mark - MoPub Ad Callback Methods

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view did load ad");
    
    if (self.removeAdsBannerIsVisible)
        [self animateRemoveAdsBannerOff];
    
    [self.view addSubview:self.mpAdView];
    
    if (!self.mpAdViewIsVisible)
        [self animateAdsBannerOn];
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view did fail to load ad");
    
    if (self.mpAdViewIsVisible) {
        [self animateAdsBannerOff];
    }
    
    [self.mpAdView removeFromSuperview];
    
    if (!self.removeAdsBannerIsVisible) {
        [self animateRemoveAdsBannerOn];
    }
}

- (void)willPresentModalViewForAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view will present modal view for ad");
    DBGameScene *gameScene = (DBGameScene *)self.skView.scene;
    [gameScene.gameData saveGameData];
    [gameScene pauseGame];
}

- (void)didDismissModalViewForAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view did dismiss modal view for ad");
    DBGameScene *gameScene = (DBGameScene *)self.skView.scene;
    [gameScene setupContinueGame];
}

- (UIViewController *)viewControllerForPresentingModalView
{
    return self;
}


#pragma mark - Ad Animation

- (void)animateAdsBannerOn
{
    NSLog(@"Animating ad banner on");
    [UIView animateWithDuration: 0.5 animations:^{
        [self.mpAdView setFrame: CGRectMake(0, self.view.frame.size.height - self.mpAdView.frame.size.height, self.mpAdView.frame.size.width, self.mpAdView.frame.size.height)];
    }completion:^(BOOL finished){
        self.mpAdViewIsVisible = true;
    }];
}

- (void)animateAdsBannerOff
{
    NSLog(@"Animating ad banner off");
    [UIView animateWithDuration: 0.5 animations:^{
        [self.mpAdView setFrame: CGRectMake(0, self.view.frame.size.height, self.mpAdView.frame.size.width, self.mpAdView.frame.size.height)];
    }completion:^(BOOL finished){
        self.mpAdViewIsVisible = false;
    }];
}

- (void)animateRemoveAdsBannerOn
{
    NSLog(@"Animating remove ads banner on");
    [UIView animateWithDuration: 0.5 animations:^{
        [self.removeAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height - self.removeAdsBanner.frame.size.height, self.removeAdsBanner.frame.size.width, self.removeAdsBanner.frame.size.height)];
    }completion:^(BOOL finished){
        self.removeAdsBannerIsVisible = true;
    }];
}

- (void)animateRemoveAdsBannerOff
{
    NSLog(@"Animating removing ads banner off");
    [UIView animateWithDuration: 0.5 animations:^{
        [self.removeAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height, self.removeAdsBanner.frame.size.width, self.removeAdsBanner.frame.size.height)];
    }completion:^(BOOL finished){
        self.removeAdsBannerIsVisible = false;
    }];
}


#pragma mark - Controller Delegate Methods

- (void)dismissGameController
{
    [self.skView removeFromSuperview];
    self.skView = nil;
    [self dismissViewControllerAnimated:true completion:nil];
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}

- (BOOL)shouldAutorotate
{
    return false;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortraitUpsideDown;
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Game controller did deallocate");
}

@end
