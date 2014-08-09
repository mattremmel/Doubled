//
//  MRSpriteButton.m
//  Doubled
//
//  Created by Matthew Remmel on 6/17/14.
//  Copyright (c) 2014 Matthew Remmel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRSpriteButton.h"
#import <objc/message.h>

@interface MRSpriteButton()

@end

@implementation MRSpriteButton

#pragma mark - Initialization

- (id)initWithColor:(UIColor *)color size:(CGSize)size
{
    return [self initWithTexture:nil color:color size:size];
}

- (id)initWithTexture:(SKTexture *)texture
{
    return [self initWithTextureNormal:texture selected:nil disabled:nil];
}

- (id)initWithTexture:(SKTexture *)texture color:(UIColor *)color size:(CGSize)size
{
    self = [super initWithTexture:texture color:color size:size];
    if (self)
    {
        [self setNormalTexture: texture];
        [self setSelectedTexture: nil];
        [self setDisabledTexture: nil];
        
        [self initDefaults];
    }
    
    return self;
}

- (id)initWithTextureNormal:(SKTexture *)normalTexture selected:(SKTexture *)selectedTexture
{
    return [self initWithTextureNormal:normalTexture selected:selectedTexture disabled:nil];
}

- (id)initWithTextureNormal:(SKTexture *)normalTexture selected:(SKTexture *)selectedTexture disabled:(SKTexture *)disabledTexture
{
    self = [super initWithTexture:normalTexture color:[UIColor whiteColor] size:normalTexture.size];
    if (self)
    {
        [self setNormalTexture: normalTexture];
        [self setSelectedTexture: selectedTexture];
        [self setDisabledTexture: disabledTexture];
        
        [self initDefaults];
    }
    
    return self;
}

- (id)initWithImageNamedNormal:(NSString *)normalImage selected:(NSString *)selectedImage
{
    return [self initWithImageNamedNormal:normalImage selected:selectedImage disabled:nil];
}

- (id)initWithImageNamedNormal:(NSString *)normalImage selected:(NSString *)selectedImage disabled:(NSString *)disabledImage
{
    SKTexture *normalTexture = nil;
    if (normalImage) { normalTexture = [SKTexture textureWithImageNamed:normalImage]; }
    
    SKTexture *selectedTexture = nil;
    if (selectedImage){ selectedTexture = [SKTexture textureWithImageNamed:selectedImage]; }
    
    SKTexture *disabledTexture = nil;
    if (disabledImage) { disabledTexture = [SKTexture textureWithImageNamed:disabledImage]; }
    
    return [self initWithTextureNormal:normalTexture selected:selectedTexture disabled:disabledTexture];
}

- (void)initDefaults
{
    [self setIsEnabled: true];
    [self setIsSelected: false];
    
    self.title = [SKLabelNode labelNodeWithFontNamed: @"Arial"];
    [self.title setVerticalAlignmentMode: SKLabelVerticalAlignmentModeCenter];
    [self.title setHorizontalAlignmentMode: SKLabelHorizontalAlignmentModeCenter];
    self.title.zPosition = 1;
    [self addChild: self.title];
    
    [self setUserInteractionEnabled: true];
}


#pragma mark - Target-Action Pairs

- (void)setTouchUpInsideTarget:(id)target action:(SEL)action
{
    self.targetTouchUpInside = target;
    self.actionTouchUpInside = action;
}

- (void)setTouchDownInsideTarget:(id)target action:(SEL)action
{
    self.targetTouchDownInside = target;
    self.actionTouchDownInside = action;
}


#pragma mark - Setters

- (void)setIsEnabled:(BOOL)isEnabled
{
    self.isEnabled = isEnabled;
    if (self.isEnabled == false && [self disabledTexture])
    {
        [self setTexture: self.disabledTexture];
    }
    else
    {
        [self setTexture: self.normalTexture];
    }
}

- (void)setIsSelected:(BOOL)isSelected
{
    self.isSelected = isSelected;
    if ([self isEnabled] && [self selectedTexture])
    {
        [self setTexture: self.selectedTexture];
    }
    else
    {
        [self setTexture: self.normalTexture];
    }
}


#pragma mark - Touch Delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isEnabled])
    {
        if ([self.targetTouchDownInside respondsToSelector: self.actionTouchDownInside])
        {
            [self setIsSelected: true];
            objc_msgSend(self.targetTouchDownInside, self.actionTouchDownInside);
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self isEnabled])
    {
        UITouch *touch = [touches anyObject];
        CGPoint touchPoint = [touch locationInNode: self.parent]; // TODO: This might need to be just self, if it moves outside the button will this even be called?
        
        if (CGRectContainsPoint(self.frame, touchPoint))
        {
            [self setIsSelected: true];
        }
        else
        {
            [self setIsSelected: false];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInNode: self.parent]; // TODO: This might need to be just self, if it moves outside the button will this even be called?
    
    if ([self isEnabled] && CGRectContainsPoint(self.frame, touchPoint))
    {
        [self setIsSelected: false];
        objc_msgSend(self.targetTouchUpInside, self.actionTouchUpInside);
    }
    else
    {
        [self setIsSelected: false];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setIsSelected: false];
}

@end