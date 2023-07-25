//
//  WRVerticalLabel.h
//  WRTextKitDemo
//
//  Created by 项辉 on 2020/1/2.
//  Copyright © 2020 项辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WRTextLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRVerticalLabel : UIView

@property (nullable, nonatomic,copy) NSString *text; // default is nil
@property (nullable, nonatomic,copy) NSAttributedString *attributedText;  // default is nil

@property (nonatomic,strong) UIFont *font; // default is nil
@property(nonatomic, strong) UIColor *textColor; // default is black

@property (nullable, nonatomic,strong) UIColor *highlightedTextColor; // default is nil
@property (nonatomic,getter=isHighlighted) BOOL highlighted;          // default is NO

@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) NSLineBreakMode lineBreakMode;   // default is NSLineBreakByTruncatingTail

@property (nonatomic) WRTextVerticalAlignment verticalAlignment;
@property (nonatomic) WRTextHorizontalAlignment horizontalAlignment;

+ (CGFloat)widthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;
+ (CGFloat)widthWithAttributedText:(NSAttributedString *)text height:(CGFloat)height font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
