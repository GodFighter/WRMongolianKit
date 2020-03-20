//
//  WRTextPosition.h
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WRTextPosition : UITextPosition

@property (nonatomic) NSUInteger index;
@property (nonatomic) id <UITextInputDelegate> inputDelegate;

+ (instancetype)positionWithIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
