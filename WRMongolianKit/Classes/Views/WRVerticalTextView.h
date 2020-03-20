//
//  WRVerticalTextView.h
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRVerticalTextView : UIScrollView <UITextInput>

@property(nonatomic, copy) NSString *text;
@property(copy) NSAttributedString *attributedText;

@property(nonatomic, strong) UIFont *font;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIColor *caretColor; // 光标颜色
@property(nonatomic, getter=isEditable) BOOL editable;
@property(nonatomic) NSTextAlignment textAlignment;



/**边距*/
/**
    default: UIEdgeInsetsMake(5, 5, 5, 5)
*/
@property (nonatomic, assign) UIEdgeInsets insets;

@end

NS_ASSUME_NONNULL_END
