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
#import "DBSettingsViewController.h"
#import "DBAdvertisingViewController.h"

@interface DBMenuPageController () <UIPageViewControllerDataSource>

@property DBMainMenuViewController *mainMenuViewController;

@end

@implementation DBMenuPageController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"CONT: Menu page controller Did Load");
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    [[self.pageViewController view] setFrame:self.view.frame];
    self.view.backgroundColor = defaultBackgroundColor;
    
        self.mainMenuViewController = [[DBMainMenuViewController alloc] initWithNibName:@"DBMainMenuView" bundle:nil];
    
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
    
    pageControl.backgroundColor = defaultBackgroundColor;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    
    // Game Center
    [self authenticateLocalPlayer];
}

#pragma mark - Game Center

-(void)authenticateLocalPlayer
{
    if (gameCenterEnabled)
    {
        NSLog(@"GAME: Authenticating local player");
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil) {
                [self presentViewController:viewController animated:true completion:nil];
            }
            else{
                NSLog(@"GAME: Game center error: %@", error.description);
                if ([GKLocalPlayer localPlayer].authenticated) {
                    gameCenterAuthenticated = true;
                }
                else{
                    gameCenterAuthenticated = false;
                }
            }
            
            if (gameCenterEnabled)
            {
                if (error != nil)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Error" message:@"An error occured signing into Game Center. If you would like to use Game Center, please sign in using the Game Center app, or disable Game Center in the settings of this app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }
        };
    }
}


#pragma mark - Page View Controller

- (DBChildMenuViewController *)viewControllerAtIndex:(NSInteger)index
{
    NSLog(@"CONT: Getting view controller at index: %i", index);
    if (index < 0 || index >= MenuItemsCount)
    {
        return nil;
    }
    
    DBChildMenuViewController *child;
    
    if (deviceType == iPhone4Type || deviceType == iPhone5Type || deviceType == unknownType)
    {
        switch (index) {
            case 0:
                child = self.mainMenuViewController;
                child.index = 0;
                break;
                
            case 1:
                child = [[DBSettingsViewController alloc] initWithNibName:@"DBSettingsView" bundle:nil];
                child.index = 1;
                break;
                
            case 2:
                child = [[DBAdvertisingViewController alloc] initWithNibName:@"DBAdvertisingView" bundle:nil];
                child.index = 2;
                break;
                
            default:
                child = nil;
                break;
        }
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
    return UIInterfaceOrientationMaskPortraitUpsideDown;
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
