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
const CGLine CGLineZero = {.from = {0, 0}, .to = {0, 0}};
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
    CGLine line = CGLineZero;

    for (int i = 0; i < [array count]; i++) {
        NSUInteger index = i;
        // the bigest cell is first to be moved when up to down
        if (UITableViewWaveAnimationUpToDown == animation) {
            index = [array count] - i - 1;
        }
        NSIndexPath *path = [array objectAtIndex:index];
        UITableViewCell *cell = [self cellForRowAtIndexPath:path];
        line = [self getAnimationLineWithOriginalPoint:cell.center Animation:animation inOut:inOut];
        cell.center = line.from;
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, .1 * (i + 1) * NSEC_PER_SEC);

        dispatch_after(time, dispatch_get_main_queue(), ^{
          [UIView animateWithDuration:0.3
              delay:0
              options:UIViewAnimationOptionCurveEaseOut
              animations:^{
                cell.center = line.to;
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
/**
 *  get the line of animation
 *
 *  @param originalPoint
 *  @param animation
 *  @param inOut
 *
 *  @return line of animation
 */
- (CGLine)getAnimationLineWithOriginalPoint:(CGPoint)originalPoint
                                  Animation:(UITableViewWaveAnimation)animation
                                      inOut:(UITableViewWaveInOut)inOut {
    CGLine line = CGLineZero;
    CGFloat offsetX = CGRectGetWidth(self.frame);
    CGFloat offsetY = CGRectGetHeight(self.frame);
    if (UITableViewWaveIn == inOut) {
        // cell in
        line.to = CGPointMake(originalPoint.x, originalPoint.y);
        switch (animation) {
            case UITableViewWaveAnimationLeftToRight: {
                line.from = CGPointMake(originalPoint.x - offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationRightToLeft: {
                line.from = CGPointMake(originalPoint.x + offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationUpToDown: {
                line.from = CGPointMake(originalPoint.x, originalPoint.y - offsetY);
                break;
            }
            case UITableViewWaveAnimationDownToUp: {
                line.from = CGPointMake(originalPoint.x, originalPoint.y + offsetY);
                break;
            }
        }
    } else if (UITableViewWaveOut == inOut) {
        // cell out
        line.from = CGPointMake(originalPoint.x, originalPoint.y);
        switch (animation) {
            case UITableViewWaveAnimationLeftToRight: {
                line.to = CGPointMake(originalPoint.x + offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationRightToLeft: {
                line.to = CGPointMake(originalPoint.x - offsetX, originalPoint.y);
                break;
            }
            case UITableViewWaveAnimationUpToDown: {
                line.to = CGPointMake(originalPoint.x, originalPoint.y + offsetY);
                break;
            }
            case UITableViewWaveAnimationDownToUp: {
                line.to = CGPointMake(originalPoint.x, originalPoint.y - offsetY);
                break;
            }
        }
    } else {
        NSLog(@"error inout = %ld", (long)inOut);
    }

    return line;
}
@end
