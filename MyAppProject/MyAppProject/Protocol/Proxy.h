//
//  Proxy.h
//  MyAppProject
//
//  Created by lipengju on 2019/8/16.
//  Copyright © 2019 lipengju. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimalActivity.h"
@interface Proxy : NSObject

@property (nonatomic, weak) id<AnimalActivity> activity;

@end

