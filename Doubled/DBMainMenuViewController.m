//
//  DBMainMenuViewController.m
//  Doubled
//
//  Created by Matthew Remmel on 7/25/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import "DBMainMenuViewController.h"
#import <Gamekit/GameKit.h>
#import "DBGameGlobals.h"
#import "DBGameViewController.h"
#import "DBGameOptionViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "DBTutorialPageViewController.h"

@interface DBMainMenuViewController () <MFMailComposeViewControllerDelegate>

@property DBGameOptionViewController *mGameOptionController;
@property DBGameViewController *mGameViewController;

@property (weak, nonatomic) IBOutlet UIButton *mButtonCasual;
@property (weak, nonatomic) IBOutlet UIButton *mButtonTimeAttack;
@property (weak, nonatomic) IBOutlet UIButton *mButtonTutorial;
@property (weak, nonatomic) IBOutlet UIButton *mButtonRate;
@property (weak, nonatomic) IBOutlet UIButton *mButtonSendFeedback;

@property GameModes mWillOverwriteGameMode;

@end

@implementation DBMainMenuViewController


#pragma mark - View Delegate

- (void)viewDidLoad
{
    NSLog(@"CONT: Main menu controller did load");
    [super viewDidLoad];
    self.mGameOptionController = [[DBGameOptionViewController alloc] initWithNibName:@"DBGameOptionView" bundle:nil];
    self.mGameViewController = [[DBGameViewController alloc] init];
    [self styleView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.mGameOptionController removeFromView];
}


#pragma mark - Style View

- (void)styleView
{
    self.view.backgroundColor = StandardBackgroundColor;
    self.mButtonCasual.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonTimeAttack.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonTutorial.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonRate.layer.cornerRadius = MenuButtonCornerRadius;
    self.mButtonSendFeedback.layer.cornerRadius = MenuButtonCornerRadius;
    
    self.mButtonCasual.backgroundColor = StandardButtonColor;
    self.mButtonTimeAttack.backgroundColor = StandardButtonColor;
    self.mButtonTutorial.backgroundColor = StandardButtonColor;
    self.mButtonRate.backgroundColor = StandardButtonColor;
    self.mButtonSendFeedback.backgroundColor = StandardButtonColor;
    
    [self.mButtonCasual setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [self.mButtonTimeAttack setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [self.mButtonTutorial setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [self.mButtonRate setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
    [self.mButtonSendFeedback setTitleColor:StandardButtonTextColor forState:UIControlStateNormal];
}


#pragma mark - Starting Game

- (void)checkForGameInProgress
{
    assert(self.mWillOverwriteGameMode == GameModeTimeAttack || self.mWillOverwriteGameMode == GameModeCasual);
    
    if (self.mWillOverwriteGameMode == GameModeCasual)
    {
        if ([self.mGameViewController casualGameInProgress]) {
            [self showStartGameOverwriteAlert];
        }
        else {
            [self startCasualNewGame];
        }
    }
    else if (self.mWillOverwriteGameMode == GameModeTimeAttack)
    {
        if ([self.mGameViewController timeAttackGameInProgress]) {
            [self showStartGameOverwriteAlert];
        }
        else {
            [self startTimeAttackNewGame];
        }
    }
}

- (void)startCasualNewGame
{
    NSLog(@"CONT: Presenting game view controller and starting casual new game");
    [self presentViewController:self.mGameViewController animated:true completion:nil];
    [self.mGameViewController startCasualNewGame];
    self.mWillOverwriteGameMode = -1;
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting game view controller and starting casual continue game");
    [self presentViewController:self.mGameViewController animated:true completion:nil];
    [self.mGameViewController startCasualContinueGame];
    self.mWillOverwriteGameMode = -1;
}

- (void)startTimeAttackNewGame
{
    NSLog(@"CONT: Presenting game view controller and starting time attack new game");
    [self presentViewController:self.mGameViewController animated:true completion:nil];
    [self.mGameViewController startTimeAttackNewGame];
    self.mWillOverwriteGameMode = -1;
}

- (void)startTimeAttackContinueGame
{
    NSLog(@"CONT: Presenting game view controller and starting time attack new game");
    [self presentViewController:self.mGameViewController animated:true completion:nil];
    [self.mGameViewController startTimeAttackContinueGame];
    self.mWillOverwriteGameMode = -1;
}


#pragma mark - Overwrite Confirmation

- (void)showStartGameOverwriteAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Overwrite Game?" message:@"Are you sure you would like to start a new game? Doing so will overwrite your current game in progress." delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:@"Cancel", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    assert(self.mWillOverwriteGameMode == GameModeTimeAttack || self.mWillOverwriteGameMode == GameModeCasual);
    
    if (buttonIndex == 0)
    {
        if (self.mWillOverwriteGameMode == GameModeCasual) {
            [self startCasualNewGame];
        }
        else if (self.mWillOverwriteGameMode == GameModeTimeAttack) {
            [self startTimeAttackNewGame];
        }
    }
}


#pragma mark - Button Events

- (IBAction)buttonCasual:(id)sender
{
    self.mWillOverwriteGameMode = GameModeCasual;
    [self.mGameOptionController setActionTarget:self actionNewGame:@selector(checkForGameInProgress) actionContinueGame:@selector(startCasualContinueGame)];
    [self.mGameOptionController showInView:self.view animated:true];
}

- (IBAction)buttonTimeAttack:(id)sender
{
    self.mWillOverwriteGameMode = GameModeTimeAttack;
    [self.mGameOptionController setActionTarget:self actionNewGame:@selector(checkForGameInProgress) actionContinueGame:@selector(startTimeAttackContinueGame)];
    [self.mGameOptionController showInView:self.view animated:true];
}

- (IBAction)buttonTutorial:(id)sender
{
    DBTutorialPageViewController *tutorialController = [[DBTutorialPageViewController alloc] init];
    [self presentViewController:tutorialController animated:true completion:nil];
}

- (IBAction)buttonRate:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=888958280&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
}

- (IBAction)buttonSendFeedback:(id)sender
{
    [self presentMailViewController];
    self.view.backgroundColor = StandardBackgroundColor;
}


#pragma mark - Send Feedback Delegate

- (void)presentMailViewController {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:@[@"doubled.app@gmail.com"]];
        [mailController setSubject:@"Doubled - Feedback / Bug Report"];
        [mailController setMessageBody:[NSString stringWithFormat:@"General Feedback:<br/><br/><br/><br/>Bug Report / How to Reproduce:<br/><br/><br/><br/><hr/>%@<hr/>", [self getDeviceSpecs]] isHTML:true];
        [self presentViewController:mailController animated:YES completion:nil];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"No Mail Account Configured" message:@"You must configure a mail account before you can send email" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (NSString *)getDeviceSpecs
{
    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *model = [currentDevice model];
    NSString *systemVersion = [currentDevice systemVersion];
    NSArray *languageArray = [NSLocale preferredLanguages];
    NSString *language = [languageArray objectAtIndex:0];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *country = [locale localeIdentifier];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    NSString *deviceSpecs = [NSString stringWithFormat:@"Device Information:<br/><br/>Device Model: %@<br/>System Version: %@<br/>Language: %@<br/>Country: %@<br/>App Version: v%@", model, systemVersion, language, country, appVersion];
    
    return deviceSpecs;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Main Menu controller did deallocate");
}
@end
