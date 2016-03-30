//
//  UITableView+Wave.m
//  TableViewWaveDemo
//
//  Created by liulibo on 16-3-25.
//  Copyright (c) 2016年 liulibo. All rights reserved.
//

#import "UITableView+Wave.h"
typedef struct CGLine {
    CGPoint from;
    CGPoint to;
} CGLine;
const CGLine CGLineZero = {{0, 0}, {0, 0}};
@implementation UITableView (Wave)
/**
 *  falls the rows
 *
 *  @param animation  left,right,up or down
 *  @param inOut      rows in or out
 *  @param completion callback when alll of rows fall end
 */
- (void)cellWithAnimation:(UITableViewWaveAnimation)animation
                    inOut:(UITableViewWaveInOut)inOut
               completion:(void (^__nullable)(BOOL finished))completion {
    [self rowsBeginWithAnimation:animation inOut:inOut completion:completion];
}

- (void)rowsBeginWithAnimation:(UITableViewWaveAnimation)animation
                         inOut:(UITableViewWaveInOut)inOut
                    completion:(void (^__nullable)(BOOL finished))completion {
    NSArray *array = [self indexPathsForVisibleRows];

    for (int i = 0; i < [array count]; i++) {
        NSIndexPath *path = [array objectAtIndex:i];
        UITableViewCell *cell = [self cellForRowAtIndexPath:path];
        CGFloat offsetX = CGRectGetMidX(self.frame);
        CGPoint fromPoint = CGPointZero, toPoint = CGPointZero;

        if (UITableViewWaveIn == inOut) {
            // cell in
            if (UITableViewWaveAnimationLeftToRight == animation) {
                fromPoint = CGPointMake(-offsetX, cell.center.y);
            } else {
                fromPoint = CGPointMake(offsetX * 3, cell.center.y);
            }
            toPoint = CGPointMake(offsetX, cell.center.y);
        } else {
            // cell out
            if (UITableViewWaveAnimationLeftToRight == animation) {
                toPoint = CGPointMake(offsetX * 3, cell.center.y);
            } else {
                toPoint = CGPointMake(-offsetX, cell.center.y);
            }
            fromPoint = CGPointMake(offsetX, cell.center.y);
        }
        cell.center = fromPoint;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, .1 * (i + 1) * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
          [UIView animateWithDuration:0.3
              delay:0
              options:UIViewAnimationOptionCurveEaseOut
              animations:^{
                cell.center = toPoint;
                cell.hidden = NO;
              }
              completion:^(BOOL finished) {
                if (i == ([array count] - 1)) {
                    if (completion) {
                        completion(YES);
                    }
                }
              }];
        });
    }
}
- (CGLine)getAnimationLineWithOriginalPoint:(CGPoint)originalPoint
                                  Animation:(UITableViewWaveAnimation)animation
                                      inOut:(UITableViewWaveInOut)inOut {
    CGLine line = CGLineZero;
    CGFloat offsetX = CGRectGetMidX(self.frame);
    CGPoint fromPoint = CGPointZero, toPoint = CGPointZero;

    if (UITableViewWaveIn == inOut) {
        switch (animation) {
            case UITableViewWaveAnimationLeftToRight: {
                line.from = CGPointMake(-offsetX, originalPoint.y);
                toPoint = CGPointMake(offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationRightToLeft: {
                line.from = fromPoint = CGPointMake(offsetX * 3, originalPoint.y);
                toPoint = CGPointMake(offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationUpToDown: {
                //
                break;
            }
            case UITableViewWaveAnimationDownToUp: {
                //
                break;
            }
        }
    } else if (UITableViewWaveOut == inOut) {
        switch (animation) {
            case UITableViewWaveAnimationLeftToRight: {
                line.to = toPoint = CGPointMake(offsetX * 3, originalPoint.y);
                fromPoint = CGPointMake(offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationRightToLeft: {
                line.to = CGPointMake(-offsetX, originalPoint.y);
                fromPoint = CGPointMake(offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationUpToDown: {
                //
                break;
            }
            case UITableViewWaveAnimationDownToUp: {
                //
                break;
            }
        }
    } else {
        NSLog(@"error inout = %ld", (long)inOut);
    }

    return line;
}
@end
