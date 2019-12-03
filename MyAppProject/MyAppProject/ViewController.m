//
//  ViewController.m
//  MyAppProject
//
//  Created by lipengju on 2019/8/16.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Proxy.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<AnimalActivity>activitier = (id)[[Person alloc] init];
    Proxy *pr = [[Proxy alloc] init];
    pr.activity = activitier;
    [pr.activity ead:@"水果"];
    [pr.activity sleep];
//    [self.view endEditing:YES];
    
}


@end
