//
//  NSNotification+QTEvent.m
//  ios事件总线
//
//  Created by lipengju on 2019/8/15.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import "NSNotification+QTEvent.h"

@implementation NSNotification (QTEvent)

- (NSString *)eventType {
    return self.name;
}

@end
