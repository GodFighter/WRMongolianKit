//
//  WRTextPosition.m
//  Pods
//
//  Created by 项辉 on 2020/3/20.
//

#import "WRTextPosition.h"

@implementation WRTextPosition

+ (instancetype)positionWithIndex:(NSUInteger)index
{
    WRTextPosition *indexedPosition = [[self alloc] init];
    indexedPosition.index = index;
    return indexedPosition;
}

@end
