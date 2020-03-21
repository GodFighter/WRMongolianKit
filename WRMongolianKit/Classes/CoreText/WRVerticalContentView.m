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
}

@property (nonatomic, strong) WRTextLayout *textLayout;

@end


@implementation WRVerticalContentView

//MARK:- Life
- (void)dealloc
{

}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
//        self.layer.geometryFlipped = YES;  // For ease of interaction with the CoreText coordinate system.
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.userInteractionEnabled = NO;
//        self.layer.geometryFlipped = YES;  // For ease of interaction with the CoreText coordinate system.
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
//    [self drawRangeAsSelection:_selectedTextRange];
//CTFrameDraw(_ctFrame, UIGraphicsGetCurrentContext());

    [self.textLayout drawInContext:UIGraphicsGetCurrentContext() size:self.bounds.size];
}

NSRange RangeIntersection(NSRange first, NSRange second)
{
    NSRange result = NSMakeRange(NSNotFound, 0);

    // Ensure first range does not start after second range.
    if (first.location > second.location) {
        NSRange tmp = first;
        first = second;
        second = tmp;
    }

    // Find the overlap intersection range between first and second.
    if (second.location < first.location + first.length) {
        result.location = second.location;
        NSUInteger end = MIN(first.location + first.length, second.location + second.length);
        result.length = end - result.location;
    }

    return result;
}

//- (void)drawRangeAsSelection:(NSRange)selectionRange
//{
//    // If not in editing mode, do not draw selection rectangles.
//    if (!self.editing) {
//        return;
//    }
//
//    // If the selection range is empty, do not draw.
//    if (selectionRange.length == 0 || selectionRange.location == NSNotFound) {
//        return;
//    }
//
//    // Set the fill color to the selection color.
//    [[UIColor redColor] setFill];
//
//    /*
//     Iterate over the lines in our CTFrame, looking for lines that intersect with the given selection range, and draw a selection rect for each intersection.
//     */
//    CFArrayRef lines = CTFrameGetLines(_ctFrame);
//    CFIndex linesCount = CFArrayGetCount(lines);
//
//    for (CFIndex linesIndex = 0; linesIndex < linesCount; linesIndex++) {
//
//        CTLineRef line = (CTLineRef) CFArrayGetValueAtIndex(lines, linesIndex);
//        CFRange lineRange = CTLineGetStringRange(line);
//        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
//        NSRange intersection = RangeIntersection(range, selectionRange);
//        if (intersection.location != NSNotFound && intersection.length > 0) {
//            // The text range for this line intersects our selection range.
//            CGFloat xStart = CTLineGetOffsetForStringIndex(line, intersection.location, NULL);
//            CGFloat xEnd = CTLineGetOffsetForStringIndex(line, intersection.location + intersection.length, NULL);
//            CGPoint origin;
//            // Get coordinate and bounds information for the intersection text range.
//            CTFrameGetLineOrigins(_ctFrame, CFRangeMake(linesIndex, 0), &origin);
//            CGFloat ascent, descent;
//            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
//            // Create a rect for the intersection and draw it with selection color.
//            CGRect selectionRect = CGRectMake(xStart, origin.y - descent, xEnd - xStart, ascent + descent);
//            UIRectFill(selectionRect);
//        }
//    }
//}

//MARK:- Set & Get
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.textLayout.containerSize = frame.size;

    [self setNeedsDisplay];
}

-(void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.textLayout.containerSize = bounds.size;

    [self setNeedsDisplay];
}

- (void)setContentText:(NSMutableAttributedString *)contentText
{
    if (contentText == nil || contentText == _contentText) { return; }
    
    _contentText = contentText;
    self.textLayout.text = _contentText;

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

//MARK:- Private
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
    
     CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.contentText);
     UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
     
     NSDictionary* frameAttrs = nil;
     frameAttrs = @{(NSString *)kCTFrameProgressionAttributeName:@(kCTFrameProgressionLeftToRight)};

    CTFrameRef ctFrame =  CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), [path CGPath], (CFTypeRef)frameAttrs);

    // 有文本
    // 便利所有的CTLine，寻找当前index所在位置
    CFArrayRef lines = CTFrameGetLines(ctFrame);
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
        CTFrameGetLineOrigins(ctFrame, CFRangeMake(linesCount - 1, 0), &origin);
        // Place point after last line, including any font leading spacing if applicable.
        origin.y -= self.font.leading;

        CFRelease(framesetter);
        framesetter = NULL;
        CFRelease(ctFrame);
        ctFrame = NULL;

        return CGRectMake(origin.x - fabs(descent), xPos, ascent + descent, 2);
    }
    
    // 光标在文本的任意位置
    for (CFIndex linesIndex = 0; linesIndex < linesCount; linesIndex++) {
        CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, linesIndex);
        CFRange range = CTLineGetStringRange(line);
        NSInteger localIndex = index - range.location;
        if (localIndex >= 0 && localIndex <= range.length) {
            // index is in the range for this line.
            CGPoint origin;
            CGFloat ascent, descent;
            CTLineGetTypographicBounds(line, &ascent, &descent, NULL);
            CGFloat offset = CTLineGetOffsetForStringIndex(line, index, NULL);
            CTFrameGetLineOrigins(ctFrame, CFRangeMake(linesIndex, 0), &origin);

            CFRelease(framesetter);
            framesetter = NULL;
            CFRelease(ctFrame);
            ctFrame = NULL;

            // Make a small "caret" rect at the index position.
            return CGRectMake(origin.x - descent, offset, ascent + descent, 2);
        }
    }
    
    CFRelease(framesetter);
    framesetter = NULL;
    CFRelease(ctFrame);
    ctFrame = NULL;

    return CGRectNull;
}

//MARK:- Public
- (NSInteger)closestIndexToPoint:(CGPoint)point;
{
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.contentText);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width)];
    
    CTFrameRef ctFrame=  CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), [path CGPath], NULL);

    CFArrayRef lines = CTFrameGetLines(ctFrame);
    CFIndex linesCount = CFArrayGetCount(lines);
    CGPoint origins[linesCount];
    
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, linesCount), origins);
        
    CGPoint newPoint = CGPointMake(point.y, point.x);
    newPoint = CGPointMake(newPoint.x, self.bounds.size.width - newPoint.y);

    for (CFIndex linesIndex = 0; linesIndex < linesCount; linesIndex++) {
        
        if (newPoint.y > origins[linesIndex].y) {
            // This line origin is closest to the y-coordinate of our point; now look for the closest string index in this line.
            CTLineRef line = (CTLineRef)CFArrayGetValueAtIndex(lines, linesIndex);
            CFIndex index = CTLineGetStringIndexForPosition(line, newPoint);

            CFRelease(framesetter);
            framesetter = NULL;
            CFRelease(ctFrame);
            ctFrame = NULL;

            return index;
        }
    }

    CFRelease(framesetter);
    framesetter = NULL;
    CFRelease(ctFrame);
    ctFrame = NULL;

    return  self.contentText.length;

}
//MARK:- Lazy
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
