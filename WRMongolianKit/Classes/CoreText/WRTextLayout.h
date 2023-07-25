//
//  WRTextLayout.h
//  WRTextKitDemo
//
//  Created by 项辉 on 2019/12/11.
//  Copyright © 2019 项辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "WRAlignment.h"

NS_ASSUME_NONNULL_BEGIN

//MARK:-enum
typedef NS_ENUM(NSInteger,WRTextVerticalAlignment) {
    WRTextVerticalAlignmentLeading,
    WRTextVerticalAlignmentCenter,
    WRTextVerticalAlignmentTrailing
};

typedef NS_ENUM(NSInteger,WRTextHorizontalAlignment) {
    WRTextHorizontalAlignmentLeading,
    WRTextHorizontalAlignmentCenter,
    WRTextHorizontalAlignmentTrailing
};

//MARK:-
@interface WRTextLayout : NSObject

@property (nonatomic, assign) BOOL vertical;

@property (nonatomic, strong) NSMutableAttributedString *text;

@property (nonatomic, assign) CGSize containerSize;

@property (nonatomic, assign, readonly) CGRect textBoundingRect;
@property (nonatomic, assign, readonly) CGSize textBoundingSize;

@property (nonatomic) NSInteger numberOfLines;
@property (nonatomic) NSLineBreakMode lineBreakMode;   // default is NSLineBreakByTruncatingTail

@property (nonatomic) WRTextVerticalAlignment verticalAlignment;
@property (nonatomic) WRTextHorizontalAlignment horizontalAlignment;

- (void)drawInContext:(CGContextRef)context size:(CGSize)size;

+ (CGFloat)widthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font;
+ (CGFloat)widthWithAttributedText:(NSAttributedString *)text height:(CGFloat)height font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
