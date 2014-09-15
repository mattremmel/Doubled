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

@property DBGameOptionViewController *gameOptionController;
@property DBGameViewController *gameViewController;

@property (weak, nonatomic) IBOutlet UIButton *buttonCasual;
@property (weak, nonatomic) IBOutlet UIButton *buttonTimeAttack;
@property (weak, nonatomic) IBOutlet UIButton *buttonTutorial;
@property (weak, nonatomic) IBOutlet UIButton *buttonRate;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendFeedback;

@property GameModes overwriteGameMode;

@end

@implementation DBMainMenuViewController


#pragma mark - View Delegate

- (void)viewDidLoad
{
    NSLog(@"CONT: Main menu controller did load");
    [super viewDidLoad];
    self.gameOptionController = [[DBGameOptionViewController alloc] initWithNibName:@"DBGameOptionView" bundle:nil];
    self.gameViewController = [[DBGameViewController alloc] init];
    [self styleView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.gameOptionController removeFromView];
}


#pragma mark - Style View

- (void)styleView
{
    self.view.backgroundColor = defaultBackgroundColor;
    self.buttonCasual.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonTimeAttack.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonTutorial.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonRate.layer.cornerRadius = MenuButtonCornerRadius;
    self.buttonSendFeedback.layer.cornerRadius = MenuButtonCornerRadius;
    
    self.buttonCasual.backgroundColor = defaultButtonColor;
    self.buttonTimeAttack.backgroundColor = defaultButtonColor;
    self.buttonTutorial.backgroundColor = defaultButtonColor;
    self.buttonRate.backgroundColor = defaultButtonColor;
    self.buttonSendFeedback.backgroundColor = defaultButtonColor;
    
    [self.buttonCasual setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    [self.buttonTimeAttack setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    [self.buttonTutorial setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    [self.buttonRate setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
    [self.buttonSendFeedback setTitleColor:defaultButtonTextColor forState:UIControlStateNormal];
}


#pragma mark - Starting Game

- (void)checkForGameInProgress
{
    assert(self.overwriteGameMode == GameModeTimeAttack || self.overwriteGameMode == GameModeCasual);
    
    if (self.overwriteGameMode == GameModeCasual)
    {
        if ([self.gameViewController casualGameInProgress]) {
            [self showStartGameOverwriteAlert];
        }
        else {
            [self startCasualNewGame];
        }
    }
    else if (self.overwriteGameMode == GameModeTimeAttack)
    {
        if ([self.gameViewController timeAttackGameInProgress]) {
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
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startCasualNewGame];
    self.overwriteGameMode = -1;
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting game view controller and starting casual continue game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startCasualContinueGame];
    self.overwriteGameMode = -1;
}

- (void)startTimeAttackNewGame
{
    NSLog(@"CONT: Presenting game view controller and starting time attack new game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startTimeAttackNewGame];
    self.overwriteGameMode = -1;
}

- (void)startTimeAttackContinueGame
{
    NSLog(@"CONT: Presenting game view controller and starting time attack new game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startTimeAttackContinueGame];
    self.overwriteGameMode = -1;
}


#pragma mark - Overwrite Confirmation

- (void)showStartGameOverwriteAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Overwrite Game?" message:@"Are you sure you would like to start a new game? Doing so will overwrite your current game in progress." delegate:self cancelButtonTitle:@"New Game" otherButtonTitles:@"Cancel", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    assert(self.overwriteGameMode == GameModeTimeAttack || self.overwriteGameMode == GameModeCasual);
    
    if (buttonIndex == 0)
    {
        if (self.overwriteGameMode == GameModeCasual) {
            [self startCasualNewGame];
        }
        else if (self.overwriteGameMode == GameModeTimeAttack) {
            [self startTimeAttackNewGame];
        }
    }
}


#pragma mark - Button Events

- (IBAction)buttonCasual:(id)sender
{
    self.overwriteGameMode = GameModeCasual;
    [self.gameOptionController setActionTarget:self actionNewGame:@selector(checkForGameInProgress) actionContinueGame:@selector(startCasualContinueGame)];
    [self.gameOptionController showInView:self.view animated:true];
}

- (IBAction)buttonTimeAttack:(id)sender
{
    self.overwriteGameMode = GameModeTimeAttack;
    [self.gameOptionController setActionTarget:self actionNewGame:@selector(checkForGameInProgress) actionContinueGame:@selector(startTimeAttackContinueGame)];
    [self.gameOptionController showInView:self.view animated:true];
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
    self.view.backgroundColor = defaultBackgroundColor;
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
