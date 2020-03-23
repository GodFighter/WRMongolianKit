//
//  WRAlertController.m
//  WRTextKitDemo
//
//  Created by 项辉 on 2020/1/8.
//  Copyright © 2020 项辉. All rights reserved.
//

#import "WRAlertController.h"
#import <WRVerticalLabel.h>
#import <WRVerticalButton.h>

//MARK:-
@interface WRAlertAction ()

@property (copy, nonatomic) void (^handler)(UIAlertAction *action);

@end

@implementation WRAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler {
    WRAlertAction *action = [super actionWithTitle:title style:style handler:handler];
    action.handler = handler;
    return action;
}

- (void)execute {
    if (self.handler) {
        self.handler(self);
    }
}

@end

static CGFloat wr_alertController_item_size = 50;
static CGFloat wr_alertController_margin = 10;
static CGFloat wr_alertController_height = 300;

//MARK:-
@interface WRAlertController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout >

@property (copy, nonatomic) NSString *alertTitle;
@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) UIAlertControllerStyle preferredStyle;

@property (weak, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSLayoutConstraint *collectionView_leading;

@property (strong, nonatomic) NSMutableArray<WRAlertAction *> *actions;
@property (strong, nonatomic) WRAlertAction *footerAction;

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *messageFont;
@property (strong, nonatomic) UIFont *actionFont;

@end

@implementation WRAlertController

@synthesize font = _font;

//MARK:-  life
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    
    if (self.preferredStyle == UIAlertControllerStyleActionSheet && self.actions.lastObject.style == UIAlertActionStyleCancel) {
        self.footerAction = self.actions.lastObject;
        [self.actions removeLastObject];
    }

    [self initCollectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.collectionView_leading.constant = -self.collectionView.bounds.size.width;
            [self.view layoutIfNeeded];
        } completion:nil];
    } else {
        self.collectionView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
        self.collectionView.alpha = 0;

        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.collectionView.transform = CGAffineTransformIdentity;
            self.collectionView.alpha = 1.0;
        } completion:nil];
    }
}

//MARK:-  public
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(nullable NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle {
    WRAlertController *controller = [WRAlertController new];
    controller.actions = [NSMutableArray arrayWithCapacity:0];
    controller.alertTitle = title;
    controller.message = message;
    controller.preferredStyle = preferredStyle;
    controller.font = [UIFont fontWithName:@"Arial-ItalicMT" size:20];
    controller.titlePinToVisibleBounds = YES;
    controller.lineSpacing = 5.0;
    
    controller.modalPresentationStyle = UIModalPresentationCustom;
    
    return controller;
}

- (void)addAction:(WRAlertAction *)action {
    [self.actions addObject:action];
}

//MARK:-  private
- (void)setFont:(UIFont *)font {
    _font = font;
    
    self.titleFont = _font;
    self.messageFont = [UIFont fontWithName:_font.fontName size:_font.pointSize - 2];
    self.actionFont = _font;
}
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(wr_alertController_item_size, wr_alertController_height);
    layout.headerReferenceSize = [self headerSize] > 0 ? CGSizeMake(ceil([self headerSize]), wr_alertController_height) : CGSizeZero;
    layout.footerReferenceSize = [self footerSize] > 0 ? CGSizeMake(ceil([self footerSize]), wr_alertController_height) : CGSizeZero;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    if (@available(iOS 9.0, *)) {
        layout.sectionHeadersPinToVisibleBounds = self.titlePinToVisibleBounds;
    } else {
        // Fallback on earlier versions
    }
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:UICollectionReusableView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
        self.collectionView_leading = [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:10];
        
        [self.view addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
            self.collectionView_leading
        ]];
        
    } else {
        [self.view addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0],
            [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]
        ]];
    }
    
    CGFloat width = [self headerSize] + [self footerSize] + self.actions.count * wr_alertController_item_size;
    
    [self.collectionView addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:wr_alertController_height],
        [NSLayoutConstraint constraintWithItem:self.collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:MIN(width, UIScreen.mainScreen.bounds.size.width)]
    ]];

    [self.view layoutIfNeeded];
    [self.collectionView layoutIfNeeded];
}

- (CGFloat)titleWidth {
    if (self.alertTitle != nil && self.alertTitle.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = self.lineSpacing;

        return ceil([self.alertTitle boundingRectWithSize:CGSizeMake(wr_alertController_height - wr_alertController_margin * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont, NSParagraphStyleAttributeName : paragraphStyle} context:nil].size.height) + 30;
    }
    return 0;
}

- (CGFloat)messageWidth {
    if (self.message != nil && self.message.length > 0) {
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = self.lineSpacing;
        
        return ceil([self.message boundingRectWithSize:CGSizeMake(wr_alertController_height - wr_alertController_margin * 2, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.messageFont, NSParagraphStyleAttributeName : paragraphStyle} context:nil].size.height) + 30;
    }
    return 0;
}

- (CGFloat)headerSize {
    if (self.alertTitle != nil && self.alertTitle.length > 0) {
        CGFloat titleSize = [self titleWidth];
        if (self.message != nil && self.message.length > 0) {
            CGFloat messageSize = [self messageWidth];
            return MAX(titleSize + messageSize, wr_alertController_item_size);
        }
        return MAX(titleSize, wr_alertController_item_size);

    }
    return 0;
}

- (CGFloat)footerSize {
    if (self.footerAction != nil) {
        return wr_alertController_item_size + wr_alertController_margin * 3;
    }
    
    return 0;
}

- (UIColor *)colorWithActionStyle:(UIAlertActionStyle)style {
    switch (style) {
        case UIAlertActionStyleDefault:
            return [UIColor blueColor];
        case UIAlertActionStyleCancel:
            return [UIColor redColor];
        case UIAlertActionStyleDestructive:
            return [UIColor colorWithWhite:0.5 alpha:1];
        default:
            return [UIColor blackColor];
    }
}

- (void)clipCorner:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(CGSize)cornerRadius {
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:cornerRadius];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

//MARK:-  UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setHighlighted:NO];
    [cell setSelected:NO];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.actions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    WRAlertAction *action = self.actions[indexPath.item];
    
    WRVerticalButton *button = [cell viewWithTag:1024];
    if (button == nil) {
        button = [[WRVerticalButton alloc] initWithFrame:cell.bounds];
        [cell addSubview:button];
        button.tag = 1024;
        button.font = self.actionFont;
        button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(action_action:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (indexPath.item == self.actions.count - 1) {
        [self clipCorner:button corners: (UIRectCornerTopRight| UIRectCornerBottomRight) cornerRadius:CGSizeMake(10, 10)];
    }
    
    UIColor *normalColor = [self colorWithActionStyle:(self.footerAction != nil || (indexPath.item != self.actions.count - 1 && action.style == UIAlertActionStyleCancel)) ? UIAlertActionStyleDefault : action.style];
    [button setTitleColor:normalColor forState:UIControlStateNormal];
    [button setTitleColor:[normalColor colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];

    [button setTitle:action.title forState:UIControlStateNormal];
    
    UIView *lineView = [cell viewWithTag:2048];
    if (lineView == nil) {
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5, cell.bounds.size.height)];
        [cell addSubview:lineView];
        lineView.tag = 2048;
        lineView.backgroundColor = [UIColor colorWithRed:205.0 / 255.0 green:205.0 / 255.0 blue:205.0 / 255.0 alpha:1.0];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = kind == UICollectionElementKindSectionHeader ? @"header" : @"footer";
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (kind == UICollectionElementKindSectionHeader) {
        view.backgroundColor = [UIColor whiteColor];
        [self clipCorner:view corners:self.actions.count > 0 ? (UIRectCornerTopLeft | UIRectCornerBottomLeft) : (UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadius:CGSizeMake(10, 10)];

        WRVerticalLabel *titleLabel = [view viewWithTag:1024];
        if (titleLabel == nil) {
            titleLabel = [[WRVerticalLabel alloc] initWithFrame:CGRectMake(0, 0, [self titleWidth], view.bounds.size.height)];
            [view addSubview:titleLabel];
            titleLabel.tag = 1024;
            titleLabel.font = self.titleFont;
            if (self.message == nil || self.message.length == 0) {
                titleLabel.frame = view.bounds;
                titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            } else {
                titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            }
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.highlightedTextColor = [titleLabel.textColor colorWithAlphaComponent:0.5];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.verticalAlignment = WRTextVerticalAlignmentCenter;
            titleLabel.horizontalAlignment = WRTextHorizontalAlignmentCenter;
        }

        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineSpacing = self.lineSpacing;
        
        titleLabel.attributedText = [[NSAttributedString alloc] initWithString:self.alertTitle attributes:@{NSFontAttributeName : self.messageFont, NSParagraphStyleAttributeName : paragraphStyle}];
        
        if (self.message.length > 0) {
            WRVerticalLabel *messageLabel = [view viewWithTag:2048];
            if (messageLabel == nil) {
                messageLabel = [[WRVerticalLabel alloc] initWithFrame:CGRectMake(titleLabel.frame.size.width, 0, [self messageWidth], view.bounds.size.height)];
                [view addSubview:messageLabel];
                messageLabel.tag = 2048;
                messageLabel.font = self.messageFont;
                messageLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                messageLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1];
                messageLabel.highlightedTextColor = [messageLabel.textColor colorWithAlphaComponent:0.5];
                messageLabel.backgroundColor = [UIColor clearColor];
                messageLabel.verticalAlignment = WRTextVerticalAlignmentCenter;
                messageLabel.horizontalAlignment = WRTextHorizontalAlignmentCenter;
            }

            messageLabel.attributedText = [[NSAttributedString alloc] initWithString:self.message attributes:@{NSFontAttributeName : self.messageFont, NSParagraphStyleAttributeName : paragraphStyle}];
        }
    } else {
        WRVerticalButton *button = [view viewWithTag:1024];
        if (button == nil) {
            button = [[WRVerticalButton alloc] initWithFrame:CGRectMake(10, 0, view.bounds.size.width - 30, view.bounds.size.height)];
            [view addSubview:button];
            button.tag = 1024;
            button.font = self.titleFont;
            button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [button setTitleColor:[[UIColor redColor] colorWithAlphaComponent:0.3] forState:UIControlStateHighlighted];
            button.backgroundColor = [UIColor whiteColor];
            [button addTarget:self action:@selector(action_action:) forControlEvents:UIControlEventTouchUpInside];
            [self clipCorner:button corners:(UIRectCornerTopLeft | UIRectCornerBottomLeft | UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadius:CGSizeMake(10, 10)];
        }
        [button setTitle:self.footerAction.title forState:UIControlStateNormal];
    }
    
    return view;
}

//MARK:-  action
- (void)action_action:(WRVerticalButton *)sender {
    if ([sender.superview.superview isKindOfClass:UICollectionViewCell.class]) {
        UICollectionViewCell *cell = (UICollectionViewCell *)sender.superview.superview;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        WRAlertAction *action = self.actions[indexPath.item];
        [action execute];
    } else if ([sender.superview.superview isKindOfClass:UICollectionReusableView.class]) {
        [self.footerAction execute];
    }
    [self action_dismiss];
}

- (void)action_dismiss {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (self.preferredStyle == UIAlertControllerStyleActionSheet) {
            self.collectionView_leading.constant = 0;
        } else {
            self.collectionView.alpha = 0;
        }
        self.view.alpha = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (finished) {
            [self dismissViewControllerAnimated:false completion:nil];
        }
    }];
}

@end
