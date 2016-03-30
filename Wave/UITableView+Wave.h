//
//  UITableView+Wave.h
//  TableViewWaveDemo
//
//  Created by liulibo on 16-3-25.
//  Copyright (c) 2016年 liulibo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UITableViewWaveAnimation) {
  UITableViewWaveAnimationLeftToRight,
  UITableViewWaveAnimationRightToLeft,
  UITableViewWaveAnimationUpToDown,
  UITableViewWaveAnimationDownToUp
};
typedef NS_ENUM(NSInteger, UITableViewWaveInOut) {
  UITableViewWaveIn,
  UITableViewWaveOut
};
@interface UITableView (Wave)

/**
 *  falls the rows
 *
 *  @param animation  left,right,up or down
 *  @param inOut      rows in or out
 *  @param completion callback when alll of rows fall end
 */
- (void)cellWithAnimation:(UITableViewWaveAnimation)animation
                    inOut:(UITableViewWaveInOut)inOut
               completion:(void (^__nullable)(BOOL finished))completion;
@end
