//
//  Person.m
//  CodeConfusion
//
//  Created by lipengju on 2021/1/5.
//

#import "Person.h"

@implementation Person

- (void)testFunction
{
    NSLog(@"%s",__func__);
}

- (void)testFunctionWithParam:(NSString *)parameter
{
    NSLog(@"%s",__func__);
}

- (void)CC_testFunction
{
    NSLog(@"%s",__func__);
}

- (void)CC_testFunctionWithParam:(NSString *)parameter
{
    NSLog(@"%s",__func__);
}

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        NSLog(@"%@",name);
    }
    return self;
}

@end
