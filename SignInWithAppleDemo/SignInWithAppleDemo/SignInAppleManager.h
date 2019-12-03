//
//  SignInAppleManager.h
//  SignInWithAppleDemo
//
//  Created by lipengju on 2019/9/23.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignInAppleUserInfo : NSObject

@end

typedef void (^SignSuccess) (SignInAppleUserInfo *);
typedef void (^SignFailure) (NSString *msg);

@interface SignInAppleManager : NSObject

+ (instancetype)sharedInstance;

- (void)createAppleIDButtonWithFrame:(CGRect)frame superView:(UIView *)superView;

@property (nonatomic, copy) SignSuccess success;
@property (nonatomic, copy) SignFailure failure;
@end

NS_ASSUME_NONNULL_END
