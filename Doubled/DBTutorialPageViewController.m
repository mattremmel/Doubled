//
//  MRTutorialPageViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/21/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBTutorialPageViewController.h"
#import "DBChildTutorialViewController.h"
#import "DBGameGlobals.h"

@interface DBTutorialPageViewController ()

@end

@implementation DBTutorialPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    self.view.backgroundColor = defaultBackgroundColor;
    
    DBChildTutorialViewController *initialViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    // Find the page control subview
    NSArray *subviews = self.pageController.view.subviews;
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
    
}


#pragma mark - View Controller Getter

- (DBChildTutorialViewController *)viewControllerAtIndex:(NSInteger)index
{
    if (index < 0 || index >= TutorialViewsCount)
    {
        return nil;
    }
    
    DBChildTutorialViewController *child;
    
    switch (index)
    {
        case 0:
            child = [[DBChildTutorialViewController alloc] initWithNibName:@"DBTutorialGeneralView" bundle:nil];
            child.index = 0;
            break;
            
        case 1:
            child = [[DBChildTutorialViewController alloc] initWithNibName:@"DBTutorialTimeAttackView" bundle:nil];
            child.index = 1;
            break;
            
        case 2:
            child = [[DBChildTutorialViewController alloc] initWithNibName:@"DBTutorialSettingsView" bundle:nil];
            child.index = 2;
            break;
            
        case 3:
            child = [[DBChildTutorialViewController alloc] initWithNibName:@"DBTutorialPageFinal" bundle:nil];
            [child setActionTarget:self actionDismissTutorial:@selector(dismissTutorial)];
            child.index = 3;
            break;
            
        default:
            child = nil;
            break;
    }
    
    return child;
}


#pragma mark - Dimiss Tutorial

- (void)dismissTutorial
{
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - Page Controller Callback

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    DBChildTutorialViewController *child = (DBChildTutorialViewController *)viewController;
    return [self viewControllerAtIndex:child.index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    DBChildTutorialViewController *child = (DBChildTutorialViewController *)viewController;
    return [self viewControllerAtIndex:child.index + 1];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return TutorialViewsCount;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return InitialTutorialViewIndex;
}

@end
