//
//  MRChildTutorialViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/21/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "MRChildTutorialViewController.h"

@interface MRTutorialPageViewController ()

@end

@implementation MRTutorialPageViewController

- (id)initWithIndex:(NSInteger)index
{
    self = [super init];
    if (self)
    {
        self.index = index;
        // Load image based on index
    }

    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
