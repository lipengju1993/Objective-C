//
//  AppDelegate.m
//  SignInWithAppleDemo
//
//  Created by lipengju on 2019/9/19.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "AppDelegate.h"
#import <AuthenticationServices/AuthenticationServices.h>
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    if (@available(iOS 13.0, *)) {
//        NSString *userIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"kAppleSignInUserID"];
//        if (userIdentifier) {
//            ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
//            [appleIDProvider getCredentialStateForUserID:userIdentifier
//                                              completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState,
//                                                           NSError * _Nullable error)
//            {
//                switch (credentialState) {
//                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
//                        // The Apple ID credential is valid
//                        NSLog(@"The Apple ID credential is valid");
//                        break;
//                    case ASAuthorizationAppleIDProviderCredentialRevoked:
//                        // Apple ID Credential revoked, handle unlink
//                        NSLog(@"Apple ID Credential revoked, handle unlink");
//                        break;
//                    case ASAuthorizationAppleIDProviderCredentialNotFound:
//                        NSLog(@"Credential not found, show login UI");
//                        // Credential not found, show login UI
//                        break;
//                    case ASAuthorizationAppleIDProviderCredentialTransferred:
//                        NSLog(@"Apple ID Provider Credential Transferred");
//                        break;
//                }
//            }];
//        }
//        
//    }
//    
//    [self observeAppleSignInState];
    
    return YES;
}


- (void)observeAppleSignInState
{
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(handleSignInWithAppleStateChanged:)
            name:ASAuthorizationAppleIDProviderCredentialRevokedNotification
          object:nil];
    }
}

- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification
{
    // Sign the user out, optionally guide them to sign in again
    NSLog(@"%@", notification.userInfo);
    // null
    
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
