//
//  DBMenuPageController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/24/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBMenuPageController.h"
#import <GameKit/GameKit.h>
#import "DBGameGlobals.h"
#import "DBMainMenuViewController.h"
#import "DBStatisticsViewController.h"
#import "DBSettingsViewController.h"
#import "DBAdvertisingViewController.h"
#import "DBTutorialPageViewController.h"
#import "DBSettingsManager.h"

@interface DBMenuPageController () <UIPageViewControllerDataSource>

@property DBMainMenuViewController *mMainMenuViewController;

@end

@implementation DBMenuPageController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"CONT: Menu page controller Did Load");
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:self.view.frame];
    self.view.backgroundColor = StandardBackgroundColor;
    
    self.mMainMenuViewController = [[DBMainMenuViewController alloc] initWithNibName:@"DBMainMenuView" bundle:nil];
    
    DBChildMenuViewController *initialViewController = [self viewControllerAtIndex: InitialMenuItemIndex];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:false completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
    
    // Find the page control subview
    NSArray *subviews = self.pageViewController.view.subviews;
    UIPageControl *pageControl;
    for (int i = 0; i < [subviews count]; ++i)
    {
        if ([[subviews objectAtIndex:i] isKindOfClass:[UIPageControl class]])
        {
            pageControl = (UIPageControl *)[subviews objectAtIndex:i];
        }
    }
    
    pageControl.backgroundColor = StandardBackgroundColor;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    // Game Center
    [self authenticateLocalPlayer];
}

- (void)viewDidLayoutSubviews
{
    [self handleFirstLaunchAfterUpdate];
}

#pragma mark - First Launch / Update Handler

// Gets called everytime the app launches so it can check if this is first launch, or the first
// launch after an update in order to show tutorial or whats new screen.
- (void)handleFirstLaunchAfterUpdate
{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    
    bool hasHadFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:HasHadFirstLaunchKey];
    if (!hasHadFirstLaunch)
    {
        // Set the last launch version to this current launch since there wasn't one before and no need to show whats new.
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:LastVersionLaunchedKey];
        
        // Tutorial
        DBTutorialPageViewController *tutorialController = [[DBTutorialPageViewController alloc] init];
        [self.pageViewController presentViewController:tutorialController animated:true completion:nil];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:HasHadFirstLaunchKey];
        
        // Don't want to show the whats new so ending here
        return;
    }
    
    NSString *lastVersionLaunched = [[NSUserDefaults standardUserDefaults] stringForKey:LastVersionLaunchedKey];
    if (![lastVersionLaunched isEqualToString:appVersion])
    {
        // TODO: Show whats new controller or something fancy
        [[NSUserDefaults standardUserDefaults] setObject:appVersion forKey:LastVersionLaunchedKey];
    }
}

#pragma mark - Game Center

-(void)authenticateLocalPlayer
{
    if (Global_GameCenterEnabled)
    {
        NSLog(@"GAME: Authenticating local player");
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil) {
                [self presentViewController:viewController animated:true completion:nil];
            }
            else{
                if ([GKLocalPlayer localPlayer].authenticated) {
                    NSLog(@"GAME: Local player authenticated");
                    gameCenterAuthenticated = true;
                }
                else{
                    NSLog(@"GAME: Local player NOT authenticated");
                    NSLog(error.description);
                    gameCenterAuthenticated = false;
                }
            }
            
            if (Global_GameCenterEnabled)
            {
                if (error != nil)
                {
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Game Center Error" message:@"An error occured signing into Game Center. If you would like to use Game Center, please sign in using the Game Center app, or disable Game Center in the settings of this app." preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
                    [alert addAction:defaultAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        };
    }
}


#pragma mark - Page View Controller

- (DBChildMenuViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index < 0 || index >= MenuItemsCount)
    {
        return nil;
    }
    
    DBChildMenuViewController *child;
    
    switch (index) {
        case 0:
            child = self.mMainMenuViewController;
            child.index = 0;
            break;
            
        case 1:
            child = [[DBStatisticsViewController alloc] initWithNibName:@"DBStatisticsView" bundle:nil];
            child.index = 1;
            break;
            
        case 2:
            child = [[DBSettingsViewController alloc] initWithNibName:@"DBSettingsView" bundle:nil];
            child.index = 2;
            break;
            
        case 3:
            child = [[DBAdvertisingViewController alloc] initWithNibName:@"DBAdvertisingView" bundle:nil];
            child.index = 3;
            break;
            
        default:
            child = nil;
            break;
    }
    
    return child;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    DBChildMenuViewController *child = (DBChildMenuViewController *)viewController;
    return [self viewControllerAtIndex:child.index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    DBChildMenuViewController *child = (DBChildMenuViewController *)viewController;
    return [self viewControllerAtIndex:child.index + 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return MenuItemsCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return InitialMenuItemIndex;
}


#pragma mark - Controller Delegate

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
    return UIInterfaceOrientationMaskPortrait;
}


#pragma mark - Touch Delegates

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Menu page controller did deallocate");
}


@end
