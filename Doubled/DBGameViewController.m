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

@property DBCasualGameScene *mCasualGameScene;
@property DBTimeAttackGameScene *mTimeAttackGameScene;
@property SKView *mSKView;

@property (nonatomic, retain)MPAdView *mMPAdView;
@property BOOL mMPAdViewIsVisible;
@property DBRemoveAdsBanner *mRemoveAdsBanner;
@property BOOL mRemoveAdsBannerIsVisible;

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
    [self.view bringSubviewToFront:self.mRemoveAdsBanner];
    [self.view bringSubviewToFront:self.mMPAdView];
    [self loadMPAd];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Configuration

- (void)configureBannerView
{
    if (Global_DeviceType == iPadType) {
        self.mMPAdView = [[MPAdView alloc] initWithAdUnitId:@"0d340afee3c24c23a7195878584d2482" size:MOPUB_LEADERBOARD_SIZE];
    }
    else {
        self.mMPAdView = [[MPAdView alloc] initWithAdUnitId:@"6f2ed59709654058a062bfb489a65eca" size:MOPUB_BANNER_SIZE];
    }
    
    self.mMPAdView.delegate = self;
    CGRect frame = self.mMPAdView.frame;
    CGSize size = [self.mMPAdView adContentViewSize];
    frame.origin.y = [[UIScreen mainScreen] applicationFrame].size.height - size.height;
    self.mMPAdView.frame = frame;
    
    [self configureRemoveAdsBanner];
}

- (void)configureRemoveAdsBanner
{
    NSLog(@"BAN:  Configuring remove ads banner");
    
    self.mRemoveAdsBanner = [[DBRemoveAdsBanner alloc] init];
    [self.mRemoveAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height, self.mRemoveAdsBanner.frame.size.width, self.mRemoveAdsBanner.frame.size.height)]; // Start off screen
    [self.mRemoveAdsBanner setBackgroundColor: [UIColor blackColor]];
    [self.mRemoveAdsBanner setUserInteractionEnabled: true];
    [self.view addSubview: self.mRemoveAdsBanner];
}

- (void)configureCasualGameScene
{
    self.mCasualGameScene = [[DBCasualGameScene alloc] initWithSize:self.view.frame.size];
    self.mCasualGameScene.mGameController = self;
}

- (void)configureTimeAttackGameScene
{
    self.mTimeAttackGameScene = [[DBTimeAttackGameScene alloc] initWithSize:self.view.frame.size];
    self.mTimeAttackGameScene.mGameController = self;
}


#pragma mark - Start Game

- (void)startCasualNewGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.mCasualGameScene setupNewGame];
    [self presentViewWithScene:self.mCasualGameScene];
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting continue casual game scene");
    [self.mCasualGameScene setupContinueGame];
    [self presentViewWithScene:self.mCasualGameScene];
}

- (void)startTimeAttackNewGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.mTimeAttackGameScene setupNewGame];
    [self presentViewWithScene:self.mTimeAttackGameScene];
}

- (void)startTimeAttackContinueGame
{
    NSLog(@"CONT: Presenting new casual game scene");
    [self.mTimeAttackGameScene setupContinueGame];
    [self presentViewWithScene:self.mTimeAttackGameScene];
}

- (void)presentViewWithScene:(DBGameScene *)scene
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    self.mSKView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    [self.view addSubview:self.mSKView];
    [self.mSKView presentScene:scene];
    [scene addInterface];
}

- (BOOL)casualGameInProgress
{
    return (self.mCasualGameScene.mGameData.mScore > 300) ? true : false;
}

- (BOOL)timeAttackGameInProgress
{
    return (self.mTimeAttackGameScene.mGameData.mScore > 300) ? true : false;
}


#pragma - Load Ads

- (void)loadMPAd
{
    [self.mMPAdView loadAd];
}


#pragma mark - Remove Ads Purchase

- (void)removeAdsPurchased
{
    NSLog(@"Remove ads purchased");
    
    [self.mMPAdView removeFromSuperview];
    self.mMPAdView = nil;
    
    [self.mRemoveAdsBanner removeFromSuperview];
    self.mRemoveAdsBanner = nil;
}

#pragma mark - MoPub Ad Callback Methods

- (void)adViewDidLoadAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view did load ad");
    
    if (self.mRemoveAdsBannerIsVisible)
        [self animateRemoveAdsBannerOff];
    
    [self.view addSubview:self.mMPAdView];
    
    if (!self.mMPAdViewIsVisible)
        [self animateAdsBannerOn];
}

- (void)adViewDidFailToLoadAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view did fail to load ad");
    
    if (self.mMPAdViewIsVisible) {
        [self animateAdsBannerOff];
    }
    
    [self.mMPAdView removeFromSuperview];
    
    if (!self.mRemoveAdsBannerIsVisible) {
        [self animateRemoveAdsBannerOn];
    }
}

- (void)willPresentModalViewForAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view will present modal view for ad");
    DBGameScene *gameScene = (DBGameScene *)self.mSKView.scene;
    [gameScene.mGameData saveGameData];
    [gameScene pauseGame];
}

- (void)didDismissModalViewForAd:(MPAdView *)view
{
    NSLog(@"MPAD: Ad view did dismiss modal view for ad");
    DBGameScene *gameScene = (DBGameScene *)self.mSKView.scene;
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
        [self.mMPAdView setFrame: CGRectMake(0, self.view.frame.size.height - self.mMPAdView.frame.size.height, self.mMPAdView.frame.size.width, self.mMPAdView.frame.size.height)];
    }completion:^(BOOL finished){
        self.mMPAdViewIsVisible = true;
    }];
}

- (void)animateAdsBannerOff
{
    NSLog(@"Animating ad banner off");
    [UIView animateWithDuration: 0.5 animations:^{
        [self.mMPAdView setFrame: CGRectMake(0, self.view.frame.size.height, self.mMPAdView.frame.size.width, self.mMPAdView.frame.size.height)];
    }completion:^(BOOL finished){
        self.mMPAdViewIsVisible = false;
    }];
}

- (void)animateRemoveAdsBannerOn
{
    NSLog(@"Animating remove ads banner on");
    [UIView animateWithDuration: 0.5 animations:^{
        [self.mRemoveAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height - self.mRemoveAdsBanner.frame.size.height, self.mRemoveAdsBanner.frame.size.width, self.mRemoveAdsBanner.frame.size.height)];
    }completion:^(BOOL finished){
        self.mRemoveAdsBannerIsVisible = true;
    }];
}

- (void)animateRemoveAdsBannerOff
{
    NSLog(@"Animating removing ads banner off");
    [UIView animateWithDuration: 0.5 animations:^{
        [self.mRemoveAdsBanner setFrame: CGRectMake(0, self.view.frame.size.height, self.mRemoveAdsBanner.frame.size.width, self.mRemoveAdsBanner.frame.size.height)];
    }completion:^(BOOL finished){
        self.mRemoveAdsBannerIsVisible = false;
    }];
}


#pragma mark - Controller Delegate Methods

- (void)dismissGameController
{
    [self.mSKView removeFromSuperview];
    self.mSKView = nil;
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
