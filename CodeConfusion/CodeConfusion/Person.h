//
//  Person.h
//  CodeConfusion
//
//  Created by lipengju on 2021/1/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

- (void)testFunction;
- (void)testFunctionWithParam:(NSString *)parameter;

- (void)CC_testFunction;
- (void)CC_testFunctionWithParam:(NSString *)parameter;

- (instancetype)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
