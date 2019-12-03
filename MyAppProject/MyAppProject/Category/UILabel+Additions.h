//
//  UILabel+Additions.h
//  MyAppProject
//
//  Created by lipengju on 2019/8/16.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Additions)

+ (UILabel *(^)(void))hrt_label;

- (UILabel *(^)(CGRect frame))hrt_frame;

- (UILabel *(^)(NSString *title))hrt_title;

- (UILabel *(^)(UIColor *textColor))hrt_textColor;

- (UILabel *(^)(CGFloat fontSize))hrt_fontSize;

- (UILabel *(^)(NSTextAlignment textAlignment))hrt_textAlignment;

- (UILabel *(^)(NSInteger numberOfLines))hrt_numberOfLines;

- (UILabel *(^)(NSAttributedString *attributedText))hrt_attributedText;

- (UILabel *(^)(UIView *superView))hrt_superView;

@end

