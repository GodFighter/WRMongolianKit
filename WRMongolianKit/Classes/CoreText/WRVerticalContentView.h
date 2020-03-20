//
//  WRVerticalContentView.h
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import <UIKit/UIKit.h>
#import "WRTextCaretView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRVerticalContentView : UIView

@property (weak, nonatomic) WRTextCaretView *caretView;

@property (nonatomic, copy) NSMutableAttributedString *contentText; // The text content (without attributes).
@property (nonatomic, getter=isEditing) BOOL editing; // Is view in "editing" mode or not (affects drawn results).
@property (nonatomic) NSRange markedTextRange; // Marked text range (for input method marked text).
@property (nonatomic) NSRange selectedTextRange; // Selected text range.

@property(nonatomic, strong) UIFont *font;

- (NSInteger)closestIndexToPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
