//
//  WRVerticalLabel.m
//  WRTextKitDemo
//
//  Created by 项辉 on 2020/1/2.
//  Copyright © 2020 项辉. All rights reserved.
//

#import "WRVerticalLabel.h"

@interface WRVerticalLabel ()

@property (nonatomic, strong) NSMutableAttributedString *layoutText;
@property (nonatomic, strong) WRTextLayout *textLayout;

@end

//MARK:-
@implementation WRVerticalLabel

@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize highlighted = _highlighted;

+ (CGFloat)widthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font {
    return [WRTextLayout widthWithText:text height:height font:font];
}

+ (CGFloat)widthWithAttributedText:(NSAttributedString *)text height:(CGFloat)height font:(UIFont *)font {
    return [WRTextLayout widthWithAttributedText:text height:height font:font];
}

//MARK:-  life
- (instancetype)init {
    if (self = [super init]) {
        [self init_defaultValue];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;

}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self init_defaultValue];
    }
    return self;
}

- (void)awakeFromNib {

    [super awakeFromNib];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.textLayout.containerSize = frame.size;

    [self setNeedsDisplay];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.textLayout.containerSize = self.frame.size;

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [self.textLayout drawInContext:UIGraphicsGetCurrentContext() size:self.bounds.size];
}

//MARK:-  private
- (void)init_defaultValue {
    _font = [UIFont systemFontOfSize:15];
    _textColor = [UIColor blackColor];
    self.verticalAlignment = WRTextVerticalAlignmentLeading;
    self.horizontalAlignment = WRTextHorizontalAlignmentCenter;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    self.highlightedTextColor = nil;
    self.numberOfLines = 0;
}

//MARK:-  get & set
- (void)setText:(NSString *)text {
    if (text == nil || _text == text || [_text isEqualToString:text]) {
        return;
    }
    _text = text.copy;
    
    self.layoutText = [[NSMutableAttributedString alloc] initWithString:_text];
    
    [self.layoutText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.layoutText.string.length)];
    [self.layoutText addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, self.layoutText.string.length)];

    self.textLayout.text = self.layoutText;
    [self setNeedsDisplay];

}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    if (_attributedText == attributedText || [_attributedText isEqualToAttributedString:attributedText]) {
        return;
    }
    _attributedText = attributedText;
    
    self.layoutText = [[NSMutableAttributedString alloc] initWithAttributedString:_attributedText];
    
    NSMutableArray *fontValuesArray = [NSMutableArray array];
    NSMutableArray *fontRangesArray = [NSMutableArray array];

    [self.layoutText enumerateAttribute:NSFontAttributeName inRange:NSMakeRange(0, _attributedText.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value == nil) {
            return;
        }
        [fontValuesArray addObject:value];
        [fontRangesArray addObject:[NSValue valueWithRange:range]];
    }];
    
    NSMutableArray *colorValuesArray = [NSMutableArray array];
    NSMutableArray *colorRangesArray = [NSMutableArray array];

    [self.layoutText enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, _attributedText.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value == nil) {
            return;
        }
        [colorValuesArray addObject:value];
        [colorRangesArray addObject:[NSValue valueWithRange:range]];
    }];

    
    [self.layoutText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, _attributedText.string.length)];
    [self.layoutText addAttribute:NSForegroundColorAttributeName value:self.textColor range:NSMakeRange(0, _attributedText.string.length)];
    for (NSInteger i = 0; i < fontRangesArray.count; i++) {
        [self.layoutText addAttribute:NSFontAttributeName value:fontValuesArray[i] range:((NSValue *)(fontRangesArray[i])).rangeValue];
    }
    for (NSInteger i = 0; i < colorRangesArray.count; i++) {
        [self.layoutText addAttribute:NSForegroundColorAttributeName value:colorValuesArray[i] range:((NSValue *)(colorRangesArray[i])).rangeValue];
    }
    
    self.textLayout.text = self.layoutText;
    [self setNeedsDisplay];
}

- (UIFont *)font {
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:15];
    }
    return _font;
}

- (void)setFont:(UIFont *)font {
    if (font == nil || font == _font) {
        return;
    }
    _font = font;
    [self.layoutText addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, self.layoutText.string.length)];
    self.textLayout.text = self.layoutText;
    [self setNeedsDisplay];
}

- (UIColor *)textColor {
    if (_textColor == nil) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    if (textColor == nil || _textColor == textColor) {
        return;
    }
    _textColor = textColor;
    
    [self.layoutText addAttribute:NSForegroundColorAttributeName value:_textColor range:NSMakeRange(0, self.layoutText.string.length)];
    self.textLayout.text = self.layoutText;
    [self setNeedsDisplay];
}

- (BOOL)isHighlighted {
    return _highlighted;
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    if (_highlightedTextColor == nil) {
        return;;
    }
    
    [self.layoutText addAttribute:NSForegroundColorAttributeName value:_highlighted ? _highlightedTextColor : _textColor range:NSMakeRange(0, self.layoutText.string.length)];
    self.textLayout.text = self.layoutText;
    [self setNeedsDisplay];
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    _highlightedTextColor = highlightedTextColor;
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    _numberOfLines = numberOfLines;
    self.textLayout.numberOfLines = numberOfLines;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    _lineBreakMode = lineBreakMode;
    self.textLayout.lineBreakMode = lineBreakMode;
}

- (void)setVerticalAlignment:(WRTextVerticalAlignment)verticalAlignment {
    _verticalAlignment = verticalAlignment;
    self.textLayout.verticalAlignment = verticalAlignment;
}

- (void)setHorizontalAlignment:(WRTextHorizontalAlignment)horizontalAlignment {
    _horizontalAlignment = horizontalAlignment;
    self.textLayout.horizontalAlignment = horizontalAlignment;
}

#pragma mark - lazy
- (WRTextLayout *)textLayout {
    if (!_textLayout) {
        _textLayout = [WRTextLayout new];
        _textLayout.containerSize = CGSizeZero;
    }
    return _textLayout;
}

@end
