//
//  DBGameGlobals.h
//  Doubled
//
//  Created by Matthew Remmel on 6/16/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

// Google Admob Identifier
#define AdMobUnitID @"ca-app-pub-3971901954060500/5725838873"

// App Delegate Identifiers
#define AppWillResignActive @"appWillResignActive"
#define AppWillTerminate @"appWillTerminate"

// Game Notification Identifiers
#define ReturnToMenu @"ReturnToMenu"

// UI Defaults
#define defaultFont @"BanglaSangamMN-Bold"
#define defaultFontColor [SKColor colorWithRed: 0.3 green: 0.3 blue: 0.3 alpha: 1.0]
#define defaultNodeColor [SKColor colorWithRed: 0.663 green: 0.886 blue: 0.953 alpha: 1.0]
#define defaultNodeBackgroundColor [SKColor colorWithRed: 0.87 green: 0.87 blue: 0.87 alpha: 1.0]
#define defaultBackgroundColor [UIColor whiteColor]

// Tile Colors
#define tile2Color [SKColor colorWithRed: 0.663 green: 0.886 blue: 0.953 alpha: 1.0]
#define tile4Color [SKColor colorWithRed: 0.4509 green: 0.862 blue: 1.0 alpha: 1.0]
#define tile8Color [SKColor colorWithRed: 0.18 green: 0.604 blue: 0.996 alpha: 1.0]
#define tile16Color [SKColor colorWithRed: 0.18 green: 0.392 blue: 0.996 alpha: 1.0]
#define tile32Color [SKColor colorWithRed: 0.078 green: 0.318 blue: 0.573 alpha: 1.0]
#define tile64Color [SKColor colorWithRed: 0.69 green: 0.988 blue: 0.937 alpha: 1.0]
#define tile128Color [SKColor colorWithRed: 0.231 green: 0.858 blue: 0.800 alpha: 1.0]
#define tile256Color [SKColor colorWithRed: 0.149 green: 0.557 blue: 0.514 alpha: 1.0]
#define tile512Color [SKColor colorWithRed: 0.671 green: 0.616 blue: 0.996 alpha: 1.0]
#define tile1024Color [SKColor colorWithRed: 0.518 green: 0.439 blue: 0.961 alpha: 1.0]
#define tile2048Color [SKColor colorWithRed: 0.8 green: 0.4 blue: 0.6 alpha: 1.0]
#define tile4096Color [SKColor colorWithRed: 0.575 green: 0.245 blue: 0.58 alpha: 1.0]
#define tileDefaultColor [SKColor colorWithRed: 0.3 green: 0.3 blue: 0.3 alpha: 1.0]

// Button Identifiers
#define NewGameButtonName @"newGameButton"
#define ContinueButtonName @"continueButton"

// Product Identifiers
#define RemoveAdsIdentifier @"MRDoubled_RemoveAds"

// Device Properties
typedef enum {
    unknownType,
    iPhone4Type,
    iPhone5Type,
    iPadType
} MRDeviceType;

NSInteger deviceType;
NSInteger tileWidth;
NSInteger tileHeight;
NSInteger columnCount;
NSInteger rowCount;
NSInteger touchTolerance;

// Game Modes
typedef enum {
    GameTypeNewGame,
    GameTypeContinueGame
} GameModes;

// Game Center properties
BOOL gameCenterAuthenticated;
#define highScoreCasualIdentifier @"HighScoreCasual"
#define highScoreTimeAttackIdentifier @"HighScoreTimeAttack"

// Menu Properties
#define MenuItemsCount 3
#define InitialMenuItemIndex 0
#define MenuButtonWidth 180
#define MenuButtonHeight 60
#define MenuButtonCornerRadius 4
#define MenuButtonShadowOpacity 0.3
#define MenuButtonShadowOffset CGSizeMake(0.0, 0.0)

// Settings
BOOL isFirstLaunch;
BOOL continuousSwipeEnabled;
BOOL gameCenterEnabled;

#define isFirstLaunchKey @"isFirstLaunch"
#define continuousSwipeEnabledKey @"continuousSwipeEnabled"
#define gameCenterEnabledKey @"gameCenterEnabled"
