//
//  ViewControllerConfigure.m
//  MyAppProject
//
//  Created by lipengju on 2019/8/16.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "ViewControllerConfigure.h"
#import "Aspects.h"
@interface ViewControllerConfigure ()

@end

@implementation ViewControllerConfigure

+ (void)load {
    [super load];
    [ViewControllerConfigure sharedInstance];
}

+ (instancetype)sharedInstance
{
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //在这里做方法拦截
        [UIViewController aspect_hookSelector:@selector(loadView) withOptions:AspectPositionAfter usingBlock:^(id aspectInfo){
            
        } error:NULL];
        
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id aspectInfo, BOOL animated){
            
        } error:NULL];
    }
    return self;
}

@end
