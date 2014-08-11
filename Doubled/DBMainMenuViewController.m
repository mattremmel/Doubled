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

@interface DBMainMenuViewController () <MFMailComposeViewControllerDelegate>

@property DBGameOptionViewController *gameOptionController;
@property DBGameViewController *gameViewController;

@property (weak, nonatomic) IBOutlet UIButton *buttonCasual;
@property (weak, nonatomic) IBOutlet UIButton *buttonTimeAttack;
@property (weak, nonatomic) IBOutlet UIButton *buttonTutorial;
@property (weak, nonatomic) IBOutlet UIButton *buttonRate;
@property (weak, nonatomic) IBOutlet UIButton *buttonSendFeedback;

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
    
    [self.buttonCasual setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonTimeAttack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonTutorial setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonRate setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonSendFeedback setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


#pragma mark - Starting Game

- (void)startCasualNewGame
{
    NSLog(@"CONT: Presenting game view controller and starting casual new game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startCasualNewGame];
}

- (void)startCasualContinueGame
{
    NSLog(@"CONT: Presenting game view controller and starting casual continue game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startCasualContinueGame];
}

- (void)startTimeAttackNewGame
{
    NSLog(@"CONT: Presenting game view controller and starting time attack new game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startTimeAttackNewGame];
}

- (void)startTimeAttackContinueGame
{
    NSLog(@"CONT: Presenting game view controller and starting time attack new game");
    [self presentViewController:self.gameViewController animated:true completion:nil];
    [self.gameViewController startTimeAttackContinueGame];
}


#pragma mark - Button Events

- (IBAction)buttonCasual:(id)sender
{
    [self.gameOptionController setActionTarget:self actionNewGame:@selector(startCasualNewGame) actionContinueGame:@selector(startCasualContinueGame)];
    [self.gameOptionController showInView:self.view animated:true];
}

- (IBAction)buttonTimeAttack:(id)sender
{
    [self.gameOptionController setActionTarget:self actionNewGame:@selector(startTimeAttackNewGame) actionContinueGame:@selector(startTimeAttackContinueGame)];
    [self.gameOptionController showInView:self.view animated:true];
}

- (IBAction)buttonTutorial:(id)sender
{
}

- (IBAction)buttonRate:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"items-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=888958280&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
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
        [mailController setToRecipients:@[@"matt.remmel@gmail.com"]];
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
    // Handle any errors here & check for controller's result as well
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Dealloc

- (void)dealloc
{
    NSLog(@"CONT: Main Menu controller did deallocate");
}
@end
