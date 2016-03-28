//
//  ViewController.m
//  TableViewWaveDemo
//
//  Created by liulibo on 16-3-25.
//  Copyright (c) 2016年 liulibo. All rights reserved.
//

#import "UITableView+Wave.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 10;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                      forIndexPath:indexPath];
  cell.textLabel.text =
      [NSString stringWithFormat:@"Row:                                  %ld",
                                 (long)indexPath.row];
  cell.hidden = YES;
  return cell;
}

- (IBAction)LeftIn:(id)sender {

  [self.tableView cellWithAnimation:UITableViewWaveAnimationLeftToRight
                              inOut:UITableViewWaveIn
                         completion:^(BOOL finished) {
                           NSLog(@"all of rows fall finished");
                         }];
}

- (IBAction)rightOut:(id)sender {
  [self.tableView cellWithAnimation:UITableViewWaveAnimationLeftToRight
                              inOut:UITableViewWaveOut
                         completion:^(BOOL finished) {
                           NSLog(@"all of rows fall finished");
                         }];
}

@end
