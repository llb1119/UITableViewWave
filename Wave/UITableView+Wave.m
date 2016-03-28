//
//  UITableView+Wave.m
//  TableViewWaveDemo
//
//  Created by liulibo on 16-3-25.
//  Copyright (c) 2016年 liulibo. All rights reserved.
//

#import "UITableView+Wave.h"

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
    dispatch_time_t time =
        dispatch_time(DISPATCH_TIME_NOW, .1 * (i + 1) * NSEC_PER_SEC);
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

@end
