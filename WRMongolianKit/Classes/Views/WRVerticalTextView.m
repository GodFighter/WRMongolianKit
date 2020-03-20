//
//  WRVerticalTextView.m
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import "WRVerticalTextView.h"

#import "WRTextPosition.h"
#import "WRTextRange.h"

#import "WRVerticalContentView.h"

//MARK:-  
@interface WRVerticalTextView() <UIGestureRecognizerDelegate>

@property (weak, nonatomic) WRVerticalContentView *contentView;

@property (copy, nonatomic) NSMutableString *innerText;

@end

//MARK:-  implementation
@implementation WRVerticalTextView


//MARK:-  life
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _initDefaults];
        [self _initContentViews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super initWithCoder:coder])
    {
        [self _initDefaults];
        [self _initContentViews];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder { return YES; }

- (BOOL)becomeFirstResponder {
    self.contentView.markedTextRange = NSMakeRange(NSNotFound, 0);
    self.contentView.selectedTextRange = NSMakeRange(_innerText.length, 0);
    
    self.contentView.editing = YES;
    
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    self.contentView.editing = NO;

    return [super resignFirstResponder];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.contentView.backgroundColor = backgroundColor;
}

//MARK:-  Private
- (void)_initDefaults
{
    _innerText =  [NSMutableString stringWithString:@""];
    _font = [UIFont systemFontOfSize:18];
    _textColor = [UIColor blackColor];
    _editable = YES;
    _textAlignment = NSTextAlignmentLeft;
    _insets = UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)_initContentViews
{
    WRVerticalContentView *contentView = [[WRVerticalContentView alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, self.insets)];
    contentView.backgroundColor = self.backgroundColor == nil ? [UIColor whiteColor] : self.backgroundColor;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    contentView.font = _font;
    [self addSubview:contentView];
    self.contentView = contentView;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    tapGestureRecognizer.delegate = self;
}

- (void)_setContentText
{
    if (_innerText.length <= 0 || self.font == nil || self.textColor == nil) { return; }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 5;

    NSDictionary *attributes = @{
        NSFontAttributeName : self.font,
        NSForegroundColorAttributeName : self.textColor,
        NSParagraphStyleAttributeName : paragraphStyle
    };
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_innerText attributes:attributes];
    self.contentView.contentText = attributedString;
}

//MARK:-  Get & Set
- (void)setFont:(UIFont *)font
{
    if (font == nil || _font == font) { return; }
    _font = font;
    self.contentView.font = _font;
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor == nil || _textColor == textColor) { return; }
    _textColor = textColor;
}

- (void)setCaretColor:(UIColor *)caretColor {
    if (caretColor == nil || _caretColor == caretColor) { return; }
    _caretColor = caretColor;
    
    self.contentView.caretView.backgroundColor = caretColor;
}

//MARK:- UITextInput Get & Set
@synthesize inputDelegate = _inputDelegate;

//MARK: Document
- (UITextPosition *)beginningOfDocument
{
    return [WRTextPosition positionWithIndex:0];
}

- (UITextPosition *)endOfDocument
{
    return [WRTextPosition positionWithIndex:_innerText.length];
}

//MARK: Marked
@synthesize markedTextStyle = _markedTextStyle;
@synthesize selectedTextRange = _selectedTextRange;
- (UITextRange *)markedTextRange
{
    NSRange markedTextRange = self.contentView.markedTextRange;
    if (markedTextRange.length == 0)
    {
        return nil;
    }
    
    return [WRTextRange indexedRangeWithRange:markedTextRange];
}

//MARK:- UIKeyInput Get & Set
@synthesize tokenizer = _tokenizer;

- (BOOL)hasText
{
    return _innerText.length > 0;
}

- (void)deleteBackward
{

}

- (void)insertText:(nonnull NSString *)text
{
    
}

//MARK:- UITextInput func
//MARK: 替换 & 返回
// 必备方法，系统获取给定范围的字符串
- (NSString *)textInRange:(WRTextRange *)range
{
    return ([_innerText substringWithRange:range.range]);
}

// 必备方法，用给定字符串替换指定范围字符串
- (void)replaceRange:(WRTextRange *)range withText:(NSString *)text
{
    NSRange selectedNSRange = self.contentView.selectedTextRange;
    // 确定选择范围是否与指定范围相交
    if ((range.range.location + range.range.length) <= selectedNSRange.location) {
        // 不相交
        selectedNSRange.location -= (range.range.length - text.length);
    } else {
        // 相交，待处理
        //TODO: 待处理选中替换的范围问题

    }

    // Now replace characters in text storage
    [_innerText replaceCharactersInRange:range.range withString:text];

    // Update underlying APLSimpleCoreTextView
//    self.textView.contentText = self.text;
    self.contentView.selectedTextRange = selectedNSRange;
}

//MARK:  标记 & 选中
- (void)setSelectedTextRange:(WRTextRange *)range
{
    self.contentView.selectedTextRange = range.range;
}

- (UITextRange *)selectedTextRange
{
    return [WRTextRange indexedRangeWithRange:self.contentView.selectedTextRange];
}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{
    NSRange selectedNSRange = self.contentView.selectedTextRange;
    NSRange markedTextRange = self.contentView.markedTextRange;

    if (markedTextRange.location != NSNotFound)
    {
        if (!markedText) { markedText = @""; }
        // 替换字符串指定范围的字符，更新标识范围
        [_innerText replaceCharactersInRange:markedTextRange withString:markedText];
        markedTextRange.length = markedText.length;
    }
    else if (selectedNSRange.length > 0)
    {
        // 当前无标识范围，但是有选中范围，那么更新选中范围字符串，并更新标识范围
        [_innerText replaceCharactersInRange:selectedNSRange withString:markedText];
        markedTextRange.location = selectedNSRange.location;
        markedTextRange.length = markedText.length;
    }
    else
    {
        // 当前无更新范围和选中范围，直接将字符串插入队尾，并更新标识范围
        [_innerText insertString:markedText atIndex:selectedNSRange.location];
        markedTextRange.location = selectedNSRange.location;
        markedTextRange.length = markedText.length;
    }

    // 更新选中范围
    selectedNSRange = NSMakeRange(selectedRange.location + markedTextRange.location, selectedRange.length);

    [self _setContentText];

    self.contentView.markedTextRange = markedTextRange;
    self.contentView.selectedTextRange = selectedNSRange;
}

// 必备方法, 取消标识
- (void)unmarkText
{
    NSRange markedTextRange = self.contentView.markedTextRange;

    if (markedTextRange.location == NSNotFound) {
        return;
    }

    markedTextRange.location = NSNotFound;
    self.contentView.markedTextRange = markedTextRange;
}

//MARK: 范围 & 位置 计算
// 必备方法，生成来去范围
- (WRTextRange *)textRangeFromPosition:(WRTextPosition *)fromPosition toPosition:(WRTextPosition *)toPosition
{
    NSRange range = NSMakeRange(MIN(fromPosition.index, toPosition.index), ABS(toPosition.index - fromPosition.index));
    return [WRTextRange indexedRangeWithRange:range];
}

// 必备方法，计算当前文本相对变化文本的偏移量
- (WRTextPosition *)positionFromPosition:(WRTextPosition *)position offset:(NSInteger)offset
{
    NSInteger end = position.index + offset;
    // 变化文本位置是否在当前文本范围内
    if (end > _innerText.length || end < 0) {
        return nil;
    }
    return [WRTextPosition positionWithIndex:end];
}

// 必备方法，计算变化文本在指定方向上的偏移量
- (WRTextPosition *)positionFromPosition:(WRTextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
    NSInteger newPosition = position.index;

    switch ((NSInteger)direction) {
        case UITextLayoutDirectionRight:
            newPosition += offset;
            break;
        case UITextLayoutDirectionLeft:
            newPosition -= offset;
            break;
        UITextLayoutDirectionUp:
        UITextLayoutDirectionDown:
            //TODO: 竖向的支持
            break;
    }

    if (newPosition < 0)
        newPosition = 0;

    if (newPosition > _innerText.length)
        newPosition = _innerText.length;

    return [WRTextPosition positionWithIndex:newPosition];
}

//MARK: 文本位置比较
// 必备方法，比较文本位置
- (NSComparisonResult)comparePosition:(WRTextPosition *)position toPosition:(WRTextPosition *)other
{
    if (position.index < other.index) {
        return NSOrderedAscending;
    }
    if (position.index > other.index) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

// 必备方法，文本间的可见字符数
- (NSInteger)offsetFromPosition:(WRTextPosition *)from toPosition:(WRTextPosition *)toPosition
{
    return (toPosition.index - from.index);
}

//MARK: 版面的文本方向 & 位置相关
// 必备方法，返回在文本范围内在给定布局方向上最远的文本位置。
- (WRTextPosition *)positionWithinRange:(WRTextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
    NSInteger position;
    /*
     For this sample, we just return the extent of the given range if the given direction is "forward" in a left-to-right context (UITextLayoutDirectionRight or UITextLayoutDirectionDown), otherwise we return just the range position.
     */
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            position = range.range.location;
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:
            position = range.range.location + range.range.length;
            break;
    }

    // Return text position using our UITextPosition implementation.
    // Note that position is not currently checked against document range.
    return [WRTextPosition positionWithIndex:position];
}

// 必备方法，返回从给定文本位置到其在特定布局方向上的最远范围的文本范围。
- (WRTextRange *)characterRangeByExtendingPosition:(WRTextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    NSRange result;
    switch (direction) {
        case UITextLayoutDirectionUp:
        case UITextLayoutDirectionLeft:
            result = NSMakeRange(position.index - 1, 1);
            break;
        case UITextLayoutDirectionRight:
        case UITextLayoutDirectionDown:
            result = NSMakeRange(position.index, 1);
            break;
    }

    // Return range using our UITextRange implementation.
    // Note that range is not currently checked against document range.
    return [WRTextRange indexedRangeWithRange:result];
}

// 必备方法，返回文字在指定文字方向上的位置的基本书写方向
- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return UITextWritingDirectionLeftToRight;
}

// 必备方法，为文档中给定范围的文本设置基本书写方向。
- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(WRTextRange *)range
{
}

//MARK: 几何方法
//必备方法，获取范围的CGRect
- (CGRect)firstRectForRange:(WRTextRange *)range
{
    //TODO: 获取范围的CGRect
    return CGRectZero;
}

//必备方法，输入光标的位置
- (CGRect)caretRectForPosition:(WRTextPosition *)position
{
    //TODO: 输入光标的位置
    return CGRectZero;

}

//MARK: 命中测试
//必备方法，返回文档中最接近指定点的位置
- (WRTextPosition *)closestPositionToPoint:(CGPoint)point
{
    return nil;
}

//必备方法，返回文档中在给定范围内最接近指定点的位置
- (WRTextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(WRTextRange *)range
{
    return nil;
}

//必备方法，返回文档中给定点的字符或字符范围。
- (WRTextRange *)characterRangeAtPoint:(CGPoint)point
{
    return nil;
}

//必备方法，返回UITextSelectionRects数组
- (NSArray *)selectionRectsForRange:(UITextRange *)range
{
    //TODO: 返回UITextSelectionRects数组
    return nil;
}

//MARK: 文本样式信息
//必备方法，返回文本样式信息
- (NSDictionary *)textStylingAtPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
    return @{ NSFontAttributeName : [UIFont systemFontOfSize:20] };
}

//MARK:- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gesture shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self);
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if ([self isFirstResponder]) {

        [self.inputDelegate selectionWillChange:self];

        // Find and update insertion point in underlying APLSimpleCoreTextView.
        NSInteger index = [self.contentView closestIndexToPoint:[tap locationInView:self.contentView]];
        self.contentView.markedTextRange = NSMakeRange(NSNotFound, 0);
        self.contentView.selectedTextRange = NSMakeRange(index, 0);

        // Let inputDelegate know selection has changed.
        [self.inputDelegate selectionDidChange:self];
    }
    else {
        // Inform controller that we're about to enter editing mode.
//        [self.editableCoreTextViewDelegate editableCoreTextViewWillEdit:self];
        // Flag that underlying APLSimpleCoreTextView is now in edit mode.
        self.contentView.editing = YES;
        // Become first responder state (which shows software keyboard, if applicable).
        [self becomeFirstResponder];
    }
}

@end
