//
//  DBGameInterfaceViewController.m
//  Doubled
//
//  Created by Matthew on 8/9/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBGameInterfaceViewController.h"
#import "DBGameGlobals.h"

@interface DBGameInterfaceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *buttonMenu;

@end

@implementation DBGameInterfaceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self styleView];
}

- (void)styleView
{
    self.view.backgroundColor = [UIColor clearColor];
}

@end
