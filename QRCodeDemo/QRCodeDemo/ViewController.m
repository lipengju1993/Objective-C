//
//  ViewController.m
//  QRCodeDemo
//
//  Created by lipengju on 2021/1/7.
//

#import "ViewController.h"
#import "LPJScanQRCodeViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LPJScanQRCodeViewController *vc = [[LPJScanQRCodeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
