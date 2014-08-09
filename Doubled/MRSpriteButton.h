//
//  MRSpriteButton.h
//  Doubled
//
//  Created by Matthew Remmel on 6/17/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MRSpriteButton : SKSpriteNode

@property SEL actionTouchUpInside;
@property SEL actionTouchDownInside;
@property id targetTouchUpInside;
@property id targetTouchDownInside;

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isSelected;
@property SKLabelNode *title;
@property SKTexture *normalTexture;
@property SKTexture *selectedTexture;
@property SKTexture *disabledTexture;

- (id)initWithTextureNormal:(SKTexture *)normalTexture selected:(SKTexture *)selectedTexture;
- (id)initWithTextureNormal:(SKTexture *)normalTexture selected:(SKTexture *)selectedTexture disabled:(SKTexture *)disabledTexture;

- (id)initWithImageNamedNormal:(NSString *)normalImage selected:(NSString *)selectedImage;
- (id)initWithImageNamedNormal:(NSString *)normalImage selected:(NSString *)selectedImage disabled:(NSString *)disabledImage;

- (void)setTouchUpInsideTarget:(id)target action:(SEL)action;
- (void)setTouchDownInsideTarget:(id)target action:(SEL)action;

@end