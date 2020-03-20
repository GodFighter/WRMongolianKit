//
//  WRTextRange.m
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import "WRTextRange.h"

@implementation WRTextRange

+ (instancetype)indexedRangeWithRange:(NSRange)range
{
    if (range.location == NSNotFound) {
        return nil;
    }

    WRTextRange *indexedRange = [[self alloc] init];
    indexedRange.range = range;
    return indexedRange;
}


// UITextRange read-only property - returns start index of range.
- (UITextPosition *)start
{
    return [WRTextPosition positionWithIndex:self.range.location];
}


// UITextRange read-only property - returns end index of range.
- (UITextPosition *)end
{
    return [WRTextPosition positionWithIndex:(self.range.location + self.range.length)];
}


// UITextRange read-only property - returns YES if range is zero length.
-(BOOL)isEmpty
{
    return (self.range.length == 0);
}

@end
