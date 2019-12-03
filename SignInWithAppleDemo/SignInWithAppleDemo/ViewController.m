//
//  ViewController.m
//  SignInWithAppleDemo
//
//  Created by lipengju on 2019/9/19.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "ViewController.h"
//#import <AuthenticationServices/AuthenticationServices.h>
#import "SignInAppleManager.h"
@interface ViewController ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>
@property (nonatomic, assign) BOOL isClicked;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%d",self.isClicked);
    /*
     typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonType) {
         ASAuthorizationAppleIDButtonTypeSignIn,
         ASAuthorizationAppleIDButtonTypeContinue,

         ASAuthorizationAppleIDButtonTypeDefault = ASAuthorizationAppleIDButtonTypeSignIn,
     }
     
     typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonStyle) {
         ASAuthorizationAppleIDButtonStyleWhite, //白色
         ASAuthorizationAppleIDButtonStyleWhiteOutline, //白色带边框
         ASAuthorizationAppleIDButtonStyleBlack, //黑色
     }
     */
    
//    ASAuthorizationAppleIDButton *button = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhiteOutline];
//
//    [button addTarget:self action:@selector(signInWithApple) forControlEvents:UIControlEventTouchUpInside];
//    button.center = self.view.center;
//
//    [self.view addSubview:button];
    
    [[SignInAppleManager sharedInstance] createAppleIDButtonWithFrame:CGRectMake(100, 100, 150, 40) superView:self.view];
    
    
}

- (void)signInWithApple API_AVAILABLE(ios(13.0))
{
    ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
    ASAuthorizationAppleIDRequest *request = [provider createRequest];
    request.requestedScopes = @[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail];
    ASAuthorizationController *vc = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    vc.delegate = self;
    vc.presentationContextProvider = self;
    [vc performRequests];
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"kAppleSignInUserID"]) {
//        [self perfomExistingAccountSetupFlows];
//    } else {
//        
//    }
//#if 0
//
//#else
//
//#endif
    
}

// 如果存在iCloud Keychain 凭证或者AppleID 凭证提示用户
- (void)perfomExistingAccountSetupFlows API_AVAILABLE(ios(13.0))
{
    // 基于用户的Apple ID授权用户，生成用户授权请求的一种机制
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    // 授权请求依赖于用于的AppleID
    ASAuthorizationAppleIDRequest *authAppleIDRequest = [appleIDProvider createRequest];
    // 为了执行钥匙串凭证分享生成请求的一种机制
    ASAuthorizationPasswordRequest *passwordRequest = [[ASAuthorizationPasswordProvider new] createRequest];
    
    NSMutableArray <ASAuthorizationRequest *>* array = [NSMutableArray arrayWithCapacity:2];
    if (authAppleIDRequest) {
        [array addObject:authAppleIDRequest];
    }
    if (passwordRequest) {
        [array addObject:passwordRequest];
    }
    NSArray <ASAuthorizationRequest *>* requests = [array copy];
    
    ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
    authorizationController.delegate = self;
    authorizationController.presentationContextProvider = self;
    [authorizationController performRequests];
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
        //  需要使用钥匙串的方式保存用户的唯一信息 这里暂且处于测试阶段 是否的NSUserDefaults
        [[NSUserDefaults standardUserDefaults] setValue:userID forKey:@"kAppleSignInUserID"];
        
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
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *passwordCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *userIdentifier = passwordCredential.user;
        // 密码凭证对象的密码
        NSString *password = passwordCredential.password;
        
        NSLog(@"userIdentifier: %@", userIdentifier);
        NSLog(@"password: %@", password);
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
    NSLog(@"%@", errorMsg);
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller
{
    return self.view.window;
}


- (void)dealloc {
    
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

@end
