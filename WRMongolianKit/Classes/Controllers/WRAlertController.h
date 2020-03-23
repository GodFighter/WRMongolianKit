//
//  WRAlertController.h
//  WRTextKitDemo
//
//  Created by 项辉 on 2020/1/8.
//  Copyright © 2020 项辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//MARK:-
@interface WRAlertAction : UIAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end

//MARK:-
@interface WRAlertController : UIViewController

@property (strong, nonatomic) UIFont *font;
@property (assign, nonatomic) BOOL titlePinToVisibleBounds; // default YES
@property (assign, nonatomic) CGFloat lineSpacing; // default 5.0

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

- (void)addAction:(WRAlertAction *)action;

@end

NS_ASSUME_NONNULL_END
