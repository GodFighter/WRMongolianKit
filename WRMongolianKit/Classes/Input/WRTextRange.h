//
//  WRTextRange.h
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import <UIKit/UIKit.h>
#import "WRTextPosition.h"

NS_ASSUME_NONNULL_BEGIN

@interface WRTextRange : UITextRange

@property (nonatomic) NSRange range;
+ (instancetype)indexedRangeWithRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
