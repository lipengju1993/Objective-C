//
//  SignInAppleManager.m
//  SignInWithAppleDemo
//
//  Created by lipengju on 2019/9/23.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "SignInAppleManager.h"

@implementation SignInAppleUserInfo

@end

@interface SignInAppleManager ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end

@implementation SignInAppleManager {
    UIView *_currentView;
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

- (void)createAppleIDButtonWithFrame:(CGRect)frame superView:(UIView *)superView {
    NSAssert(superView, @"superView can't be nil");
    _currentView = superView;
    ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
    [button addTarget:self action:@selector(signInWithApple) forControlEvents:UIControlEventTouchUpInside];
    button.frame = frame;
    [superView addSubview:button];
}

- (void)signInWithApple {
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    ASAuthorizationController *vc = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    vc.delegate = self;
    vc.presentationContextProvider = self;
    [vc performRequests];
}

#pragma mark - ASAuthorizationControllerDelegate
// 授权成功回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization
{
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        
        NSString *state = credential.state;
        NSString *userID = credential.user;
        
        NSPersonNameComponents *fullName = credential.fullName;
        NSString *email = credential.email;
        NSString *authorizationCode = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding]; // refresh token
        NSString *identityToken = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding]; // access token
        ASUserDetectionStatus realUserStatus = credential.realUserStatus;
        
        NSLog(@"state: %@", state);
        NSLog(@"userID: %@", userID);
        NSLog(@"fullName: %@", fullName);
        NSLog(@"email: %@", email);
        NSLog(@"authorizationCode: %@", authorizationCode);
        NSLog(@"identityToken: %@", identityToken);
        NSLog(@"realUserStatus: %@", @(realUserStatus));
        
        SignInAppleUserInfo *info = [[SignInAppleUserInfo alloc] init];
        
        if (self.success) {
            self.success(info);
        }
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error
{
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    if (self.failure) {
        self.failure(errorMsg);
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
{
    return _currentView.window;
}

@end
