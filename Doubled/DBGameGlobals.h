//
//  DBGameGlobals.h
//  Doubled
//
//  Created by Matthew Remmel on 6/16/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//


// Security
#define CasualGameDataChecksumKey @"CasualGameDataChecksumKey"
#define TimeAttackGameDataChecksumKey @"TimeAttackGameDataChecksumKey"

// First Launch / Update Keys
#define HasHadFirstLaunchKey @"hasHadFirstLaunch"
#define LastVersionLaunchedKey @"lastVersionLaunched"

// App Delegate Identifiers
#define AppWillResignActive @"appWillResignActive"
#define AppDidEnterBackground @"appWillEnterBackground"
#define AppWillEnterForeground @"appWillEnterForeground"
#define AppDidBecomeActive @"appDidBecomeActive"
#define AppWillTerminate @"appWillTerminate"

// Game Notification Identifiers
#define ReturnToMenu @"ReturnToMenu"

// UI Defaults
#define StandardFont @"BanglaSangamMN-Bold"
#define StandardFontColor [UIColor colorWithRed: 0.3 green: 0.3 blue: 0.3 alpha: 1.0]
#define StandardNodeColor [UIColor colorWithRed: 0.663 green: 0.886 blue: 0.953 alpha: 1.0]
#define StandardNodeBackgroundColor [UIColor colorWithRed: 0.87 green: 0.87 blue: 0.87 alpha: 1.0]
#define StandardBackgroundColor [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0]
#define StandardButtonColor [UIColor colorWithRed:0.35 green:0.56 blue:0.77 alpha:1.0]
#define StandardButtonTextColor [UIColor whiteColor]
#define StandardHUDColor [UIColor colorWithRed: 0.8 green: 0.88 blue: 0.92 alpha: 1.0]


// Tile Colors
#define Tile2Color [UIColor colorWithRed: 0.663 green: 0.886 blue: 0.953 alpha: 1.0]
#define Tile4Color [UIColor colorWithRed: 0.4509 green: 0.862 blue: 1.0 alpha: 1.0]
#define Tile8Color [UIColor colorWithRed: 0.18 green: 0.604 blue: 0.996 alpha: 1.0]
#define Tile16Color [UIColor colorWithRed: 0.18 green: 0.392 blue: 0.996 alpha: 1.0]
#define Tile32Color [UIColor colorWithRed: 0.078 green: 0.318 blue: 0.573 alpha: 1.0]
#define Tile64Color [UIColor colorWithRed: 0.69 green: 0.988 blue: 0.937 alpha: 1.0]
#define Tile128Color [UIColor colorWithRed: 0.231 green: 0.858 blue: 0.800 alpha: 1.0]
#define Tile256Color [UIColor colorWithRed: 0.149 green: 0.557 blue: 0.514 alpha: 1.0]
#define Tile512Color [UIColor colorWithRed: 0.671 green: 0.616 blue: 0.996 alpha: 1.0]
#define Tile1024Color [UIColor colorWithRed: 0.518 green: 0.439 blue: 0.961 alpha: 1.0]
#define Tile2048Color [UIColor colorWithRed: 0.8 green: 0.4 blue: 0.6 alpha: 1.0]
#define Tile4096Color [UIColor colorWithRed: 0.575 green: 0.245 blue: 0.58 alpha: 1.0]
#define TileDefaultColor [UIColor colorWithRed: 0.3 green: 0.3 blue: 0.3 alpha: 1.0]

// Button Identifiers
#define NewGameButtonName @"newGameButton"
#define ContinueButtonName @"continueButton"

// Product Identifiers
#define RemoveAdsIdentifier @"MRDoubled_RemoveAds"

// Device Properties
typedef enum {
    UnknownType,
    iPhone4Type,
    iPhone5Type,
    iPadType
} MRDeviceType;

NSInteger Global_DeviceType;
NSInteger Global_TileWidth;
NSInteger Global_TileHeight;
NSInteger Global_FontSize;
NSInteger Global_TileSizeShrink;
NSInteger Global_ColumnCount;
NSInteger Global_RowCount;

// Game Modes
typedef enum {
    GameModeCasual,
    GameModeTimeAttack
} GameModes;


// Game Center properties
BOOL gameCenterAuthenticated;
#define HighScoreCasualIdentifier @"HighScoreCasual"
#define HighScoreTimeAttackIdentifier @"HighScoreTimeAttack"

// Menu Properties
#define MenuItemsCount 4
#define InitialMenuItemIndex 0
#define MenuButtonWidth 180
#define MenuButtonHeight 60
#define MenuButtonCornerRadius 4
#define MenuButtonShadowOpacity 0.3
#define MenuButtonShadowOffset CGSizeMake(0.0, 0.0)

// Tutorial Properties
#define TutorialViewsCount 4
#define InitialTutorialViewIndex 0

// Settings
BOOL Global_ContinuousSwipeEnabled;
BOOL Global_GameCenterEnabled;
BOOL Global_iCloudEnabled;
NSInteger Global_TouchTolerance;

#define ContinuousSwipeEnabledKey @"continuousSwipeEnabled"
#define GameCenterEnabledKey @"gameCenterEnabled"
#define iCloudEnabledKey @"iCloudEnabledKey"
#define TouchToleranceKey @"touchTolerance"

// Time Attack Game Mode
#define TimeAttackStartingTime 10.0
#define TimeAttackMergeAddTime 0.55

