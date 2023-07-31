//
//  WRTextLayout.m
//  WRTextKitDemo
//
//  Created by 项辉 on 2019/12/11.
//  Copyright © 2019 项辉. All rights reserved.
//

#import "WRTextLine.h"
#import "WRTextLayout.h"

@interface WRTextLayout()

@property (nonatomic, strong) NSMutableArray *textLines;
@property (nonatomic, strong) NSMutableArray *displayLines;

@property (nonatomic, readwrite) CTFramesetterRef ctFrameSetter;
@property (nonatomic, readwrite) CTFrameRef ctFrame;

@property (nonatomic, strong) NSMutableAttributedString *displayText;

@end

@implementation WRTextLayout

+ (CGFloat)widthWithText:(NSString *)text height:(CGFloat)height font:(UIFont *)font {

    UIFont *systemFont = [UIFont systemFontOfSize:15];
    if (font != nil) {
        systemFont = font;
    }
    
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName : systemFont}];
    NSArray *lines = [WRTextLayout lineWithAttributedString:string size:CGSizeMake(CGFLOAT_MAX, height)];
    
    return [self calculationTextBoundingRect:lines].width;
}

+ (CGFloat)widthWithAttributedText:(NSAttributedString *)text height:(CGFloat)height font:(UIFont *)font {
    NSArray *lines = [WRTextLayout lineWithAttributedString:text size:CGSizeMake(CGFLOAT_MAX, height)];
    
    return [self calculationTextBoundingRect:lines].width;
}

- (instancetype)init {
    if (self = [super init]) {
        self.containerSize = CGSizeZero;
        self.vertical = YES;
        self.displayLines = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)setContainerSize:(CGSize)containerSize {
    _containerSize = containerSize;
    [self reloadData];
}

- (void)setText:(NSMutableAttributedString *)text {
    _text = text;
    [self reloadData];
}

- (void)reloadData {
    if (_text == nil || CGSizeEqualToSize(_containerSize, CGSizeZero)) {
        return;
    }
    NSMutableAttributedString *displayText = [[NSMutableAttributedString alloc] initWithAttributedString:_text];
    [displayText enumerateAttribute:NSParagraphStyleAttributeName inRange:NSMakeRange(0, _text.string.length) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        if (value == nil) {
            return;
        }
        [displayText removeAttribute:value range:range];
    }];

    self.displayText = [[NSMutableAttributedString alloc] initWithAttributedString:displayText];
    
    self.textLines = [WRTextLayout lineWithAttributedString:_text size:CGSizeMake(CGFLOAT_MAX, self.containerSize.height)];
    
    self.displayLines = [WRTextLayout lineWithAttributedString:self.displayText size:self.containerSize];
    
    if (self.displayLines.count > 0) {
        if (self.displayLines.count < self.textLines.count && self.numberOfLines == 0) {
            WRTextLine *lastLine = self.displayLines.lastObject;
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:[_text attributedSubstringFromRange:NSMakeRange(0, lastLine.range.location + lastLine.range.length + 1)]];

            NSMutableParagraphStyle *paragraphStyle =  [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = self.lineBreakMode;
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:lastLine.range];
            
            self.displayText = string;

            self.displayLines = [WRTextLayout lineWithAttributedString:self.displayText size:self.containerSize];
        } else if (self.textLines.count > self.numberOfLines && self.numberOfLines != 0) {
            WRTextLine *lastLine = self.displayLines[MAX(0, (self.displayLines.count > self.numberOfLines - 1) ? self.numberOfLines - 1 : self.displayLines.count - 1)];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithAttributedString:[_text attributedSubstringFromRange:NSMakeRange(0, lastLine.range.location + lastLine.range.length + 1)]];

            NSMutableParagraphStyle *paragraphStyle =  [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineBreakMode = self.lineBreakMode;
            [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:lastLine.range];
            
            self.displayText = string;

            self.displayLines = [WRTextLayout lineWithAttributedString:self.displayText size:self.containerSize];
        }
    }
    _textBoundingSize = [WRTextLayout calculationTextBoundingRect:self.displayLines];

}

#pragma mark - Calculation
+ (NSMutableArray<WRTextLine *>*)lineWithAttributedString:(NSAttributedString *)string size:(CGSize)size {
    if (string == nil || string.length == 0 || CGSizeEqualToSize(size, CGSizeZero)) {
        return nil;
    }
    
    CGRect cgPathBox = CGRectMake(0, 0, size.width, size.height);
    CGRect pathRect = CGRectApplyAffineTransform(cgPathBox, CGAffineTransformMakeScale(1, -1));
    CGPathRef cgPath = CGPathCreateWithRect(pathRect, NULL);

    NSDictionary* frameAttrs = nil;
    frameAttrs = @{(NSString *)kCTFrameProgressionAttributeName:@(kCTFrameProgressionLeftToRight)};
    CTFramesetterRef ctSetter= CTFramesetterCreateWithAttributedString((CFTypeRef)string);
    CTFrameRef ctFrame = CTFramesetterCreateFrame(ctSetter, CFRangeMake(0, 0), cgPath, (CFTypeRef)frameAttrs);
    CFArrayRef ctLines = CTFrameGetLines(ctFrame);
    NSUInteger lineCount = CFArrayGetCount(ctLines);

    NSMutableArray *lines = [NSMutableArray arrayWithCapacity:lineCount];
    CGPoint lineOrigins[lineCount];
    CTFrameGetLineOrigins(ctFrame, CFRangeMake(0, lineCount), lineOrigins);

    for (NSUInteger i = 0; i < lineCount;  i ++) {
        CTLineRef ctLine = CFArrayGetValueAtIndex(ctLines, i);
        CFArrayRef ctRuns = CTLineGetGlyphRuns(ctLine);
        
        if (!ctRuns || CFArrayGetCount(ctRuns) == 0)
            continue;
        ///the coordinate of CoreText
        CGPoint lineOrigin = lineOrigins[i];
        ///the coordinate of UIKit
        CGPoint position;
        position.x = cgPathBox.origin.x + lineOrigin.x;
        position.y = cgPathBox.size.height + cgPathBox.origin.y - lineOrigin.y;
        
        
        WRTextLine* foLine = [[WRTextLine alloc] initWithCTLine:ctLine position:position vertical:YES];
        [lines addObject:foLine];
        
    }
    return lines;
}

+ (CGSize)calculationTextBoundingRect:(NSArray <WRTextLine *>*)lines {
    CGSize textBoundingSize = CGSizeZero;
    CGRect textBoundingRect = CGRectZero;

    for (NSInteger i = 0; i < lines.count; i++) {
        WRTextLine *line = lines[i];
        if (i == 0) {
            textBoundingRect = line.bounds;
        } else {
            textBoundingRect = CGRectUnion(textBoundingRect, line.bounds);
        }
    }
    { // calculate bounding size
        CGRect rect = textBoundingRect;
        
        rect = CGRectStandardize(rect);
        CGSize size = rect.size;
//        if (self.vertical) {
//           size.width += rect.origin.x;
//        } else {
//            size.width += rect.origin.x;
//        }
        size.width += rect.origin.x;

        size.height += rect.origin.y;
        if (size.width < 0) size.width = 0;
        if (size.height < 0) size.height = 0;
        size.width = ceil(size.width + 1);
        size.height = ceil(size.height);
        textBoundingSize = size;
    }

//    _textBoundingRect = textBoundingRect;
//    _textBoundingSize = textBoundingSize;
    
    return textBoundingSize;

}

#pragma mark - draw
- (void)drawInContext:(CGContextRef)context size:(CGSize)size{
    
    CGContextSaveGState(context);
    
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1, -1);
    
    NSArray *lines = self.displayLines;
    
    for (NSUInteger l = 0, lMax = lines.count; l < lMax; l++) {
        WRTextLine *line = lines[l];
        NSArray *lineRunRanges = line.verticalTextRange;
        CGFloat posX = line.position.x;
        
        CGFloat posY = size.height - line.position.y;
        CFArrayRef runs = CTLineGetGlyphRuns(line.ctLine);
        for (NSUInteger r = 0, rMax = CFArrayGetCount(runs); r < rMax; r++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, r);
            CGContextSetTextMatrix(context, CGAffineTransformIdentity);
            CGContextSetTextPosition(context, posX, posY);
            //            YYTextDrawRun(line, run, context, size, isVertical, lineRunRanges[r], verticalOffset);
            [self drawLine:line run:run context:context size:size range:[lineRunRanges objectAtIndex:r]];
        }
    }
    
    CGContextRestoreGState(context);
    
}

- (void)drawLine:(WRTextLine*)line run:(CTRunRef)run context:(CGContextRef)context size:(CGSize)size range:(NSArray *)runRanges {
    CGContextSaveGState(context);
    {
        CTLineRef ctLine = line.ctLine;
        CFArrayRef runArray = CTLineGetGlyphRuns(ctLine);
        CFIndex runCount = CFArrayGetCount(runArray);

        for (CFIndex j = 0; j < runCount; ++j) {
            CTRunRef run = CFArrayGetValueAtIndex(runArray, j);
                   
            CGFloat horizontalOffset = self.vertical ? (size.width - self.textBoundingSize.width) / 2.0 : 0;
            switch (self.horizontalAlignment) {
                case WRTextHorizontalAlignmentLeading:
                    horizontalOffset = 0;
                    break;
                    
                case WRTextHorizontalAlignmentCenter:
                    horizontalOffset = (size.width - self.textBoundingSize.width) / 2.0;
                    break;

                default:
                    horizontalOffset = size.width - self.textBoundingSize.width;
                    break;
            }

            
            CGFloat verticalOffset = line.position.y;
            switch (self.verticalAlignment) {
                case WRTextVerticalAlignmentCenter:
                    verticalOffset = line.position.y - (size.height - line.bounds.size.height) / 2.0;
                    break;
                    
                case WRTextVerticalAlignmentTrailing:
                    verticalOffset = line.position.y  - size.height + line.bounds.size.height;
                    break;

                default:
                    break;
            }

            
            CGContextSetTextPosition(context, line.position.x, verticalOffset);
//            if (i > self.container.displayLineCount) {
//                return;
//            }
//                CFDictionaryRef dicRef = CTRunGetAttributes(run);
//                UIFont *font = CFDictionaryGetValue(dicRef, NSFontAttributeName);

//            CATransform3D transform3d = CATransform3DMakeAffineTransform(CGAffineTransformIdentity);
//            transform3d = CATransform3DRotate(transform3d,M_PI , 1, 0, 0);
//            CGAffineTransform transform = CATransform3DGetAffineTransform(transform3d);
            CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2 * 3);
            
            CGContextSetTextMatrix(context, transform);
            CGContextSetTextPosition(context, line.position.x + horizontalOffset, self.containerSize.height + verticalOffset);
            CTRunDraw(run, context, CFRangeMake(0, 0));

        }

    }
    CGContextRestoreGState(context);
}

@end
