//
//  WRVerticalContentView.m
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import "WRVerticalContentView.h"

#import "WRTextLayout.h"
#import "WRTextLine.h"

@interface WRVerticalContentView()
{
    CTFramesetterRef _framesetter; // Cached Core Text framesetter.
    CTFrameRef _ctFrame; // Cached Core Text frame.
}

@property (nonatomic, strong) WRTextLayout *textLayout;

@end


@implementation WRVerticalContentView

//MARK: Life
- (void)dealloc
{
    [self reset];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.textLayout drawInContext:UIGraphicsGetCurrentContext() size:self.bounds.size];
}

//MARK: Set & Get
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (_ctFrame != NULL) {
        [self updateCTFrame];
    }
    self.textLayout.containerSize = frame.size;

    [self setNeedsDisplay];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    if(_ctFrame) {
        [self updateCTFrame];
    }
    self.textLayout.containerSize = bounds.size;
}

- (void)setContentText:(NSMutableAttributedString *)contentText
{
    if (contentText == nil || contentText == _contentText) { return; }
    
    _contentText = contentText;
    self.textLayout.text = _contentText;

    [self textChanged];

    [self setNeedsDisplay];
}

- (void)setMarkedTextRange:(NSRange)markedTextRange
{
    _markedTextRange = markedTextRange;
    [self selectionChanged];
}

- (void)setSelectedTextRange:(NSRange)selectedTextRange
{
    _selectedTextRange = selectedTextRange;
    [self selectionChanged];
}

//MARK: Private
- (void)reset
{
    if (_framesetter != NULL) {
        CFRelease(_framesetter);
        _framesetter = NULL;
    }

    if (_ctFrame != NULL) {
        CFRelease(_ctFrame);
        _ctFrame = NULL;
    }
}

- (void)textChanged
{
    [self reset];
    
    if (_framesetter != NULL) {
        CFRelease(_framesetter);
    }
    _framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.contentText);

    [self updateCTFrame];

}

- (void)updateCTFrame
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    if (_ctFrame != NULL) {
        CFRelease(_ctFrame);
    }
    
    NSDictionary* frameAttrs = nil;
    frameAttrs = @{(NSString *)kCTFrameProgressionAttributeName:@(kCTFrameProgressionLeftToRight)};

    _ctFrame =  CTFramesetterCreateFrame(_framesetter, CFRangeMake(0, 0), [path CGPath], (CFTypeRef)frameAttrs);
}

- (void)selectionChanged
{
    if (!self.editing)
    {
        self.caretView.alpha = 0; return;
    }

    if (self.selectedTextRange.length == 0)
    {
        self.caretView.frame = [self caretRectForIndex:(int)self.selectedTextRange.location];
    }
}

- (CGRect)caretRectForIndex:(int)index
{
    // 无文本
    if (self.contentText.length == 0)
    {
        CGPoint origin = CGPointMake(CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - self.font.leading);
        return CGRectMake(origin.x, fabs(self.font.descender), self.font.ascender + fabs(self.font.descender), 2);
    }
    // 有文本
    // 便利所有的CTLine，寻找当前index所在位置
    CFArrayRef lines = CTFrameGetLines(_ctFrame);
    CFIndex linesCount = CFArrayGetCount(lines);

    // 文本末尾
    if (index == self.contentText.length && [self.contentText.string characterAtIndex:(index - 1)] == '\n')
    {
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, linesCount -1);
        CFRange range = CTLineGetStringRange(line);
        CGFloat xPos = CTLineGetOffsetForStringIndex(line, range.location + range.length, NULL);
        CGPoint origin;
        CGFloat ascent, descent;
        CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
        CTFrameGetLineOrigins(_ctFrame, CFRangeMake(linesCount - 1, 0), &origin);
        // Place point after last line, including any font leading spacing if applicable.
        origin.y -= self.font.leading;

        return CGRectMake(origin.x - fabs(descent), xPos, ascent + descent, 2);
    }
    
    // 光标在文本的任意位置
    for (CFIndex linesIndex = 0; linesIndex < linesCount; linesIndex++) {
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, linesIndex);
        CFRange range = CTLineGetStringRange(line);
        NSInteger localIndex = index - range.location;
        if (localIndex >= 0 && localIndex <= range.length) {
            // index is in the range for this line.
            CGFloat xPos = CTLineGetOffsetForStringIndex(line, index, NULL);
            CGPoint origin;
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CTFrameGetLineOrigins(_ctFrame, CFRangeMake(linesIndex, 0), &origin);

            // Make a small "caret" rect at the index position.
            return CGRectMake(origin.x - descent, xPos, ascent + descent, 2);
        }
    }


    return CGRectNull;
}

//MARK: Public
- (NSInteger)closestIndexToPoint:(CGPoint)point;
{
    CFArrayRef lines = CTFrameGetLines(_ctFrame);
    CFIndex linesCount = CFArrayGetCount(lines);
    CGPoint origins[linesCount];
    
    point.y = self.bounds.size.height - point.y;

    CTFrameGetLineOrigins(_ctFrame, CFRangeMake(0, linesCount), origins);

    for (CFIndex linesIndex = 0; linesIndex < linesCount; linesIndex++) {
        if (point.x > origins[linesIndex].x) {
            // This line origin is closest to the y-coordinate of our point; now look for the closest string index in this line.
            CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, linesIndex);
            CFIndex xiang = CTLineGetStringIndexForPosition(line, point);
            return xiang;
        }
    }

    return  self.contentText.length;

}
//MARK: Lazy
- (WRTextLayout *)textLayout
{
    if (!_textLayout)
    {
        _textLayout = [WRTextLayout new];
        _textLayout.containerSize = self.bounds.size;
    }
    return _textLayout;
}

- (WRTextCaretView *)caretView {
    if (_caretView == nil) {
        WRTextCaretView *caretView = [[WRTextCaretView alloc] init];
        [self addSubview:caretView];
        _caretView = caretView;

    }
    return _caretView;
}


@end
