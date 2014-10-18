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
@property (weak, nonatomic) IBOutlet UISwitch *mSwitchContinuousSwipe;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitchGameCenterEnabled;
@property (weak, nonatomic) IBOutlet UISwitch *mSwitchiCloudEnabled;
@property (weak, nonatomic) IBOutlet UIButton *mButtonResetGameData;
@property (weak, nonatomic) IBOutlet UISlider *mSliderTouchTolerance;

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
    self.view.backgroundColor = StandardBackgroundColor;
    self.mButtonResetGameData.layer.cornerRadius = MenuButtonCornerRadius;
    [self.mButtonResetGameData setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    self.mButtonResetGameData.backgroundColor = StandardButtonColor;
    
    [self.mButtonResetGameData addTarget:self action:@selector(buttonResetGameDataNormalColor) forControlEvents:UIControlEventTouchUpInside];
    [self.mButtonResetGameData addTarget:self action:@selector(buttonResetGameDataNormalColor) forControlEvents:UIControlEventTouchUpOutside];
    [self.mButtonResetGameData addTarget:self action:@selector(buttonResetGameDataHighlightColor) forControlEvents:UIControlEventTouchDown];
}


#pragma mark - Button Highlights

- (void)buttonResetGameDataNormalColor {
    self.mButtonResetGameData.backgroundColor = StandardButtonColor;
}

- (void)buttonResetGameDataHighlightColor {
    self.mButtonResetGameData.backgroundColor = StandardButtonPressedColor;
}


#pragma mark - Button Events

- (void)setCurrentSettingsState
{
    self.mSwitchContinuousSwipe.on = Global_ContinuousSwipeEnabled;
    self.mSwitchGameCenterEnabled.on = Global_GameCenterEnabled;
    self.mSwitchiCloudEnabled.on = Global_iCloudEnabled;
    self.mSliderTouchTolerance.value = Global_TouchTolerance;
}

- (IBAction)swipeContSwipeChanged:(id)sender
{
    if (self.mSwitchContinuousSwipe.on)
    {
        Global_ContinuousSwipeEnabled = true;
    }
    else
    {
        Global_ContinuousSwipeEnabled = false;
    }
    
    [DBSettingsManager saveSettings];
}
- (IBAction)switchGCEnabledChanged:(id)sender
{
    if (self.mSwitchGameCenterEnabled.on)
    {
        Global_GameCenterEnabled = true;
        
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
            
            if (Global_GameCenterEnabled)
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
        Global_GameCenterEnabled = false;
    }
    
    [DBSettingsManager saveSettings];
}

- (IBAction)switchiCloudEnabledChanged:(id)sender
{
    if (self.mSwitchiCloudEnabled.on)
    {
        Global_iCloudEnabled = true;
    }
    else
    {
        Global_iCloudEnabled = false;
    }
    
    [DBSettingsManager saveSettings];
}


- (IBAction)sliderEditingDidEnd:(id)sender
{
    Global_TouchTolerance = (NSInteger)self.mSliderTouchTolerance.value;
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