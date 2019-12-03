//
//  AnimalActivity.h
//  MyAppProject
//
//  Created by lipengju on 2019/8/16.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnimalActivity <NSObject>

@optional

- (void)ead:(NSString *)food;

- (void)sleep;

@end

