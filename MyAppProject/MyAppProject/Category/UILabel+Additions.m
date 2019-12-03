//
//  UILabel+Additions.m
//  MyAppProject
//
//  Created by lipengju on 2019/8/16.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

+ (UILabel *(^)(void))hrt_label {
    return ^(void) {
        return [[UILabel alloc] init];
    };
}

- (UILabel *(^)(CGRect frame))hrt_frame {
    return ^(CGRect frame) {
        self.frame = frame;
        return self;
    };
}

- (UILabel *(^)(NSString *title))hrt_title {
    return ^(NSString *title) {
        if (title) {
            self.text = title;
        }
        return self;
    };
}

- (UILabel *(^)(UIColor *textColor))hrt_textColor {
    return ^(UIColor *textColor) {
        if (textColor) {
            self.textColor = textColor;
        }
        return self;
    };
}

- (UILabel *(^)(CGFloat fontSize))hrt_fontSize {
    return ^(CGFloat fontSize) {
        self.font = [UIFont systemFontOfSize:fontSize];
        return self;
    };
}

- (UILabel *(^)(NSTextAlignment textAlignment))hrt_textAlignment {
    return ^(NSTextAlignment textAlignment) {
        self.textAlignment = textAlignment;
        return self;
    };
}

- (UILabel *(^)(NSInteger numberOfLines))hrt_numberOfLines {
    return ^(NSInteger numberOfLines) {
        self.numberOfLines = numberOfLines;
        return self;
    };
}

- (UILabel *(^)(NSAttributedString *attributedText))hrt_attributedText {
    return ^(NSAttributedString *attributedText) {
        if (attributedText) {
            self.attributedText = attributedText;
        }
        return self;
    };
}

- (UILabel *(^)(UIView *superView))hrt_superView {
    return ^(UIView *superView) {
        if (superView) {
            [superView addSubview:self];
        }
        return self;
    };
}

@end
