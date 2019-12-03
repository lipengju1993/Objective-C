//
//  QTEvent.h
//  ios事件总线
//
//  Created by lipengju on 2019/8/15.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QTEvent <NSObject>

@optional
- (NSString *)eventType;

@end

NS_ASSUME_NONNULL_END
