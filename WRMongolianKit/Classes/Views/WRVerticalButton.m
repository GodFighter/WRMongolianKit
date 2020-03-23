//
//  WRVerticalButton.m
//  WRTextKitDemo
//
//  Created by 项辉 on 2019/12/31.
//  Copyright © 2019 项辉. All rights reserved.
//

#import "WRVerticalButton.h"

//MARK: -
@interface WRButton : UIButton

@property (weak, nonatomic) WRVerticalButton *verticalButton;

@end

//MARK: -
@interface WRVerticalButton ()

@property (weak, nonatomic, readwrite) WRVerticalLabel *titleLabel;
@property (weak, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) UIImageView *backgroundImageView;

@property (weak, nonatomic) WRButton *coverButton;

@property (strong, nonatomic) NSMutableDictionary *imagesDictionary;

@end

//MARK:-
IB_DESIGNABLE
@implementation WRVerticalButton


//MARK:-  life
- (instancetype)init {
    if (self = [super init]) {
        [self init_UI];
        [self init_defaultValue];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self init_UI];
        [self init_defaultValue];
    }
    return  self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self init_UI];
        [self init_defaultValue];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIImage *image = self.imagesDictionary[@(UIControlStateNormal)];
    NSString *title = [self.coverButton titleForState:UIControlStateNormal];
    
    if (title.length > 0 && image == nil) {
        [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeLeading
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeTrailing
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:0]
        ]];
    } else if (title.length == 0 && image != nil) {
        [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.imageView
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeLeading
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.imageView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.imageView
                                         attribute:NSLayoutAttributeTrailing
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.imageView
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeBottom
                                        multiplier:1.0
                                          constant:0]
        ]];
    } else if (title.length > 0 && image != nil) {
        self.titleLabel.verticalAlignment = self.isImageTop ? WRTextVerticalAlignmentLeading : WRTextVerticalAlignmentTrailing;
        CGFloat titleHeight = [title boundingRectWithSize:CGSizeZero options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleLabel.font} context:nil].size.width;
        CGFloat totalHeight = ceil(titleHeight) + 10 + image.size.height;
        
        [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeLeading
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.titleLabel
                                         attribute:NSLayoutAttributeTrailing
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1.0
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.imageView
                                         attribute:NSLayoutAttributeCenterX
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self
                                         attribute:NSLayoutAttributeCenterX
                                        multiplier:1.0
                                          constant:0]
        ]];
        
        [self.imageView addConstraints:@[
            [NSLayoutConstraint constraintWithItem:self.imageView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1.0
                                          constant:image.size.width],
            [NSLayoutConstraint constraintWithItem:self.imageView
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:nil
                                         attribute:NSLayoutAttributeNotAnAttribute
                                        multiplier:1.0
                                          constant:image.size.height]
        ]];

        if (self.isImageTop) {
            [self addConstraints:@[
                [NSLayoutConstraint constraintWithItem:self.imageView
                                             attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeCenterY
                                            multiplier:1.0
                                              constant:-totalHeight / 2.0],
                [NSLayoutConstraint constraintWithItem:self.titleLabel
                                             attribute:NSLayoutAttributeBottom
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeBottom
                                            multiplier:1.0
                                              constant:0],
                [NSLayoutConstraint constraintWithItem:self.titleLabel
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.imageView
                                             attribute:NSLayoutAttributeBottom
                                            multiplier:1.0
                                              constant:10]
            ]];
        } else {
            [self addConstraints:@[
                [NSLayoutConstraint constraintWithItem:self.imageView
                                             attribute:NSLayoutAttributeCenterY
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeCenterY
                                            multiplier:1.0
                                              constant:totalHeight / 2.0],
                [NSLayoutConstraint constraintWithItem:self.titleLabel
                                             attribute:NSLayoutAttributeTop
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self
                                             attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                              constant:0],
                [NSLayoutConstraint constraintWithItem:self.titleLabel
                                             attribute:NSLayoutAttributeBottom
                                             relatedBy:NSLayoutRelationEqual
                                                toItem:self.imageView
                                             attribute:NSLayoutAttributeTop
                                            multiplier:1.0
                                              constant:-10]
            ]];
        }
    }
    
}

//MARK:-  private
- (void)init_defaultValue {
    self.font = [UIFont systemFontOfSize:15];
    self.isImageTop = YES;
    self.imagesDictionary = [NSMutableDictionary dictionary];
}

- (void)init_UI {
    self.titleLabel.textColor = [self.coverButton titleColorForState:UIControlStateNormal];
    self.titleLabel.highlightedTextColor = [self.coverButton titleColorForState:UIControlStateHighlighted];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.coverButton addTarget:target action:action forControlEvents:controlEvents];
}

- (void)setNumberOfLines:(NSInteger)numberOfLines {
    self.titleLabel.numberOfLines = numberOfLines;
}

- (void)refreshTitleLabel {
    self.titleLabel.text = self.coverButton.currentTitle;
    self.titleLabel.textColor = self.coverButton.currentTitleColor;
}

- (void)setFont:(UIFont *)font {
    _font = font;
    self.titleLabel.font = _font;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.coverButton.highlighted != highlighted) {
        self.coverButton.highlighted = highlighted;
    }
    
    UIControlState state = highlighted ? UIControlStateHighlighted : UIControlStateNormal;
    UIImage *image = self.imagesDictionary[@(state)] == nil ? self.imagesDictionary[@(UIControlStateNormal)] : self.imagesDictionary[@(state)];
    self.imageView.image = image;
    self.imageView.alpha = highlighted ? 0.3 : 1;
    
    [self refreshTitleLabel];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.coverButton.selected != selected) {
        self.coverButton.selected = selected;
    }

    UIControlState state = selected ? UIControlStateSelected : UIControlStateNormal;
    UIImage *image = self.imagesDictionary[@(state)] == nil ? self.imagesDictionary[@(UIControlStateNormal)] : self.imagesDictionary[@(state)];
    self.imageView.image = image;
    self.imageView.alpha = selected ? 0.5 : 1;

    [self refreshTitleLabel];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (self.coverButton.enabled != enabled) {
        self.coverButton.enabled = enabled;
    }
    
    UIControlState state = !enabled ? UIControlStateDisabled : UIControlStateNormal;
    UIImage *image = self.imagesDictionary[@(state)] == nil ? self.imagesDictionary[@(UIControlStateNormal)] : self.imagesDictionary[@(state)];
    self.imageView.image = image;
    self.imageView.alpha = !enabled ? 0.5 : 1;

    [self refreshTitleLabel];
}

//MARK:-  public
- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state {
    [self.coverButton setTitle:title forState:state];
    [self refreshTitleLabel];
}
- (void)setAttributedTitle:(nullable NSAttributedString *)title forState:(UIControlState)state {
    [self.coverButton setAttributedTitle:title forState:state];
    self.titleLabel.attributedText = self.coverButton.currentAttributedTitle;
}

- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state {
    [self.coverButton setTitleColor:color forState:state];
    [self refreshTitleLabel];
}

- (void)setImage:(nullable UIImage *)image forState:(UIControlState)state {
    self.imageView.image = image;
    
    if (image != nil) {
        self.imagesDictionary[@(state)] = image;
    } else {
        [self.imagesDictionary removeObjectForKey:@(state)];
    }
}

- (void)setBackgroundImage:(nullable UIImage *)image forState:(UIControlState)state {
    
}

- (nullable NSString *)titleForState:(UIControlState)state {
    return [self.coverButton titleForState:state];
}

- (nullable UIColor *)titleColorForState:(UIControlState)state {
    return [self.coverButton titleColorForState:state];
}

- (nullable NSAttributedString *)attributedTitleForState:(UIControlState)state {
    return [self.coverButton attributedTitleForState:state];
}

- (nullable UIImage *)imageForState:(UIControlState)state {
    return [self.coverButton imageForState:state];
}

- (nullable UIImage *)backgroundImageForState:(UIControlState)state {
    return [self.coverButton backgroundImageForState:state];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:UIButton.class]) {
        if ([object isKindOfClass:WRButton.class]) {
            WRButton *button = (WRButton *)object;
            return button.verticalButton == self;
        } else if ([object isKindOfClass:WRVerticalButton.class]) {
            return object == self;
        }
        return  NO;
    }
    return NO;
}
//MARK:-  lazy
- (WRVerticalLabel *)titleLabel {
    if (_titleLabel == nil) {
        WRVerticalLabel *titleLabel = [WRVerticalLabel new];
        [self insertSubview:titleLabel aboveSubview:self.backgroundImageView];
        _titleLabel = titleLabel;
        
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.verticalAlignment = WRTextVerticalAlignmentCenter;
        _titleLabel.horizontalAlignment = WRTextHorizontalAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
    }
    return _titleLabel;
}

- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        UIImageView *backgroundImageView = [UIImageView new];
        [self insertSubview:backgroundImageView atIndex:0];
        backgroundImageView.backgroundColor = [UIColor blueColor];
        _backgroundImageView = backgroundImageView;
    }
    return _backgroundImageView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        UIImageView *imageview = [UIImageView new];
        [self insertSubview:imageview aboveSubview:self.backgroundImageView];
        _imageView = imageview;
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _imageView;
}

- (WRButton *)coverButton {
    if (_coverButton == nil) {
        WRButton *coverButton = [WRButton buttonWithType:UIButtonTypeCustom];
        [self insertSubview:coverButton aboveSubview:self.titleLabel];
        _coverButton = coverButton;
        _coverButton.translatesAutoresizingMaskIntoConstraints = NO;
        _coverButton.titleLabel.alpha = 0.0;
        _coverButton.verticalButton = self;

        [self addConstraints:@[
            [NSLayoutConstraint constraintWithItem:_coverButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
            [NSLayoutConstraint constraintWithItem:_coverButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
            [NSLayoutConstraint constraintWithItem:_coverButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
            [NSLayoutConstraint constraintWithItem:_coverButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]
        ]];
    }
    return _coverButton;
}

@end

// MARK: -
@implementation WRButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.verticalButton.highlighted != highlighted) {
        self.verticalButton.highlighted = highlighted;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (self.verticalButton.selected != selected) {
        self.verticalButton.selected = selected;
    }
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (self.verticalButton.enabled != enabled) {
        self.verticalButton.enabled = enabled;
    }
}
@end


