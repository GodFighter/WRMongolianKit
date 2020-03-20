//
//  WRTextCaretView.m
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import "WRTextCaretView.h"

static const NSTimeInterval WR_InitialBlinkDelay = 0.7;
static const NSTimeInterval WR_BlinkRate = 0.5;

@interface WRTextCaretView()

@property (nonatomic) NSTimer *blinkTimer;

@end

@implementation WRTextCaretView

- (void)dealloc
{
    [_blinkTimer invalidate];
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)didMoveToSuperview
{
    if (self.superview)
    {
        self.blinkTimer = [NSTimer scheduledTimerWithTimeInterval:WR_BlinkRate target:self selector:@selector(blink) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_blinkTimer forMode:NSDefaultRunLoopMode];
    }
    else
    {
        [self.blinkTimer invalidate];
        self.blinkTimer = nil;
    }

}

- (void)blink
{
    self.alpha = self.alpha == 0 ? 1 : 0;
}

- (void)delayBlink
{
    self.alpha = NO;
    [self.blinkTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:WR_InitialBlinkDelay]];
}

@end
