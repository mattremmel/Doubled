//
//  DBSettingsViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/25/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBSettingsViewController.h"
#import "DBSettingsManager.h"
#import "DBGameGlobals.h"
#import "DBCasualGameData.h"
#import "DBTimeAttackGameData.h"
#import <GameKit/GameKit.h>

@interface DBSettingsViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *switchContinuousSwipe;
@property (weak, nonatomic) IBOutlet UISwitch *switchGameCenterEnabled;
@property (weak, nonatomic) IBOutlet UISwitch *switchiCloudEnabled;
@property (weak, nonatomic) IBOutlet UIButton *buttonResetGameData;
@property (weak, nonatomic) IBOutlet UISlider *sliderTouchTolerance;

@end

@implementation DBSettingsViewController


- (void)viewDidLoad
{
    NSLog(@"CONT: Settings controller did load");
    [super viewDidLoad];
    [self setCurrentSettingsState];
    [self styleView];
}

- (void)styleView
{
    self.view.backgroundColor = defaultBackgroundColor;
    self.buttonResetGameData.layer.cornerRadius = MenuButtonCornerRadius;
    [self.buttonResetGameData setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    self.buttonResetGameData.backgroundColor = defaultButtonColor;
}


#pragma mark - Button Events

- (void)setCurrentSettingsState
{
    self.switchContinuousSwipe.on = ContinuousSwipeEnabled;
    self.switchGameCenterEnabled.on = GameCenterEnabled;
    self.switchiCloudEnabled.on = iCloudEnabled;
    self.sliderTouchTolerance.value = TouchTolerance;
}

- (IBAction)swipeContSwipeChanged:(id)sender
{
    if (self.switchContinuousSwipe.on)
    {
        ContinuousSwipeEnabled = true;
    }
    else
    {
        ContinuousSwipeEnabled = false;
    }
    
    [DBSettingsManager saveSettings];
}
- (IBAction)switchGCEnabledChanged:(id)sender
{
    if (self.switchGameCenterEnabled.on)
    {
        GameCenterEnabled = true;
        
        // Authenticating local player
        NSLog(@"GAME: Authenticating local player");
        GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil) {
                [self presentViewController:viewController animated:true completion:nil];
            }
            else{
                if ([GKLocalPlayer localPlayer].authenticated) {
                    gameCenterAuthenticated = true;
                }
                else{
                    
                    gameCenterAuthenticated = false;
                }
            }
            
            if (GameCenterEnabled)
            {
                if (error != nil)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Game Center Error" message:@"An error occured signing into Game Center. If you would like to use Game Center, please sign in using the Game Center app, or disable Game Center in the settings of this app." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                    [alert show];
                }
            }
        };
    }
    else
    {
        GameCenterEnabled = false;
    }
    
    [DBSettingsManager saveSettings];
}

- (IBAction)switchiCloudEnabledChanged:(id)sender
{
    if (self.switchiCloudEnabled.on)
    {
        iCloudEnabled = true;
    }
    else
    {
        iCloudEnabled = false;
    }
    
    [DBSettingsManager saveSettings];
}


- (IBAction)sliderEditingDidEnd:(id)sender
{
    TouchTolerance = (NSInteger)self.sliderTouchTolerance.value;
    [DBSettingsManager saveSettings];
}

- (IBAction)buttonResetGameData:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reset Game Data?" message:@"Are you sure you would like to reset all game data on this device? This will not effect in-app purchases." delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    [alert show];
}


#pragma mark - UIAlert Callback

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:
(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [[DBCasualGameData sharedInstance] resetAllGameData];
        [[DBTimeAttackGameData sharedInstance] resetAllGameData];
        [DBSettingsManager resetSettings];
        [self setCurrentSettingsState];
    }
}

#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Settings controller did deallocate");
}

@end
