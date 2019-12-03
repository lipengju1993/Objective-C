//
//  ViewController.m
//  ios事件总线
//
//  Created by lipengju on 2019/8/15.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "ViewController.h"
#import "UILabel+Additions.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = UILabel.hrt_label()
    .hrt_frame(CGRectMake(100, 100, 100, 40))
    .hrt_title(@"我是链式编程哦")
    .hrt_textColor([UIColor redColor])
    .hrt_superView(self.view);
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:@""];
    
    NSLog(@"%@",[NSCharacterSet illegalCharacterSet]);
}


@end
