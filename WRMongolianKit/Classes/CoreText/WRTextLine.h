//
//  WRTextLine.h
//  WRTextKitDemo
//
//  Created by 项辉 on 2019/12/11.
//  Copyright © 2019 项辉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

//MARK:- enum
typedef NS_ENUM(NSUInteger, WRTextRunGlyphDrawMode) {
    /// No rotate.
    WRTextRunGlyphDrawModeHorizontal = 0,
    
    /// Rotate vertical for single glyph.
    WRTextRunGlyphDrawModeVerticalRotate = 1,
    
    /// Rotate vertical for single glyph, and move the glyph to a better position,
    /// such as fullwidth punctuation.
    WRTextRunGlyphDrawModeVerticalRotateMove = 2,
};

//MARK:-
@interface WRTextRunGlyphRange : NSObject

@property (nonatomic) NSRange glyphRangeInRun;
@property (nonatomic) WRTextRunGlyphDrawMode drawMode;

+ (instancetype)rangeWithRange:(NSRange)range drawMode:(WRTextRunGlyphDrawMode)mode;

@end

//MARK:-
@interface WRTextLine : NSObject

@property (nonatomic, readonly) CTLineRef ctLine;

@property (nonatomic, readonly) NSRange range;

@property (nonatomic, readwrite) CGPoint position;

@property (nonatomic, readonly) BOOL vertical;

@property (nonatomic, readonly) CGRect bounds;

@property (nonatomic, readonly) CGFloat ascent;

@property (nonatomic, readonly) CGFloat descent;

@property (nonatomic, readonly) CGFloat leading;

@property (nonatomic, readonly) CGFloat trailingWhitespaceWidth;

@property (nonatomic, readonly) CGFloat lineHeight;

@property (nonatomic, readonly) CGFloat lineWidth;

@property (nonatomic, getter=isLastDisplayLine) BOOL lastDisplayLine;


- (instancetype)initWithCTLine:(CTLineRef)ctLine position:(CGPoint)position vertical:(BOOL)vertical;

@property (nonatomic, strong) NSMutableArray *verticalTextRange;

@end

NS_ASSUME_NONNULL_END
