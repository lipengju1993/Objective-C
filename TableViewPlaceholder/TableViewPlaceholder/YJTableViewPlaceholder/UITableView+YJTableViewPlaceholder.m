//
//  UITableView+YJTableViewPlaceholder.m
//  TableViewPlaceholder
//
//  Created by lipengju on 2019/10/30.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "UITableView+YJTableViewPlaceholder.h"
#import "YJTableViewPlaceholderDelegate.h"

#import <objc/runtime.h>

@interface UITableView ()

@property (nonatomic, assign) BOOL scrollWasEnabled;
@property (nonatomic, strong) UIView *placeHolderView;

@end

@implementation UITableView (YJTableViewPlaceholder)

- (BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObjc = objc_getAssociatedObject(self, @selector(scrollWasEnabled));
    return [scrollWasEnabledObjc boolValue];
}

- (void)setScrollWasEnabled:(BOOL)scrollWasEnabled {
    NSNumber *scrollWasEnabledObjc = [NSNumber numberWithBool:scrollWasEnabled];
    objc_setAssociatedObject(self, @selector(scrollWasEnabled), scrollWasEnabledObjc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)placeHolderView {
    return objc_getAssociatedObject(self, @selector(placeHolderView));
}

- (void)setPlaceHolderView:(UIView *)placeHolderView {
    objc_setAssociatedObject(self, @selector(placeHolderView), placeHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yj_reloadData {
    [self reloadData];
    [self yj_checkEmpty];
}

- (void)yj_checkEmpty {
    BOOL isEmpty = YES;
    
    id<UITableViewDataSource> src = self.dataSource;
    NSInteger sections = 1;
    if ([src respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [src numberOfSectionsInTableView:self];
    }
    for (int i = 0; i < sections; i++) {
        NSInteger rows = [src tableView:self numberOfRowsInSection:i];
        if (rows) {
            isEmpty = NO;
            break;
        }
    }
    // yes nil / no objc
    if (!isEmpty != !self.placeHolderView) {
        if (isEmpty) {
            self.scrollWasEnabled = self.scrollEnabled;
            BOOL scrollEnabled = NO;
            if ([self respondsToSelector:@selector(enableScrollWhenPlaceHolderViewShowing)]) {
                scrollEnabled = [self performSelector:@selector(enableScrollWhenPlaceHolderViewShowing)];
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                    NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
                }
            } else if ([self.delegate respondsToSelector:@selector(enableScrollWhenPlaceHolderViewShowing)]) {
                scrollEnabled = [self.delegate performSelector:@selector(enableScrollWhenPlaceHolderViewShowing)];
                if (!scrollEnabled) {
                    NSString *reason = @"There is no need to return  NO for `-enableScrollWhenPlaceHolderViewShowing`, it will be NO by default";
                    NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
                }
            }
            self.scrollEnabled = scrollEnabled;
            if ([self respondsToSelector:@selector(makePlaceHolderView)]) {
                self.placeHolderView = [self performSelector:@selector(makePlaceHolderView)];
            } else if ([self.delegate respondsToSelector:@selector(makePlaceHolderView)]) {
                self.placeHolderView = [self.delegate performSelector:@selector(makePlaceHolderView)];
            } else {
                NSString *selectorName = NSStringFromSelector(_cmd);
                NSString *reason = [NSString stringWithFormat:@"You must implement makePlaceHolderView method in your custom tableView or its delegate class if you want to use %@", selectorName];
                NSLog(@"🔴类名与方法名：%@（在第%@行），描述：%@", @(__PRETTY_FUNCTION__), @(__LINE__), reason);
            }
            self.placeHolderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
            [self addSubview:self.placeHolderView];
        } else {
            self.scrollEnabled = self.scrollWasEnabled;
            [self.placeHolderView removeFromSuperview];
            self.placeHolderView = nil;
        }
    } else if (isEmpty) {
        [self.placeHolderView removeFromSuperview];
        if ([self respondsToSelector:@selector(makePlaceHolderView)]) {
            self.placeHolderView = [self performSelector:@selector(makePlaceHolderView)];
        } else if ([self.delegate respondsToSelector:@selector(makePlaceHolderView)]) {
            self.placeHolderView = [self.delegate performSelector:@selector(makePlaceHolderView)];
        }
        self.placeHolderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:self.placeHolderView];
    }
}

@end
