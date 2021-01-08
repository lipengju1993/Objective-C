//
//  ViewController.m
//  CodeConfusion
//
//  Created by lipengju on 2021/1/5.
//

#import "ViewController.h"
#import "Person.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *p = [[Person alloc] init];
    [p testFunction];
    [p CC_testFunction];
    Person *pp = [[Person alloc] initWithName:@"apple"];
    [pp CC_testFunctionWithParam:@"run!!!"];
}


@end
