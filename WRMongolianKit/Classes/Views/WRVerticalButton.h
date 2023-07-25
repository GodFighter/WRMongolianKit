//
//  WRVerticalButton.h
//  WRTextKitDemo
//
//  Created by xianghui-iMac on 2020/1/2.
//  Copyright © 2020 项辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRVerticalLabel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRVerticalButton : UIControl

@property (strong, nonatomic) IBInspectable UIFont *font;
@property (nonatomic) IBInspectable NSInteger numberOfLines;
@property (weak, nonatomic, readonly) WRVerticalLabel *titleLabel;
/// default yes
@property (nonatomic) BOOL isImageTop;

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;
- (void)setAttributedTitle:(nullable NSAttributedString *)title forState:(UIControlState)state;

- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state;
- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state;
- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state;

- (nullable NSString *)titleForState:(UIControlState)state;
- (nullable NSAttributedString *)attributedTitleForState:(UIControlState)state;

- (nullable UIColor *)titleColorForState:(UIControlState)state;
- (nullable UIImage *)imageForState:(UIControlState)state;
- (nullable UIImage *)backgroundImageForState:(UIControlState)state;

- (BOOL)isEqual:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
