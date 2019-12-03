//
//  YJTableViewPlaceholderDelegate.h
//  TableViewPlaceholder
//
//  Created by lipengju on 2019/10/30.
//  Copyright © 2019 lipengju. All rights reserved.
//

@protocol YJTableViewPlaceholderDelegate <NSObject>
@required
/*!
@brief  make an empty overlay view when the tableView is empty
@return an empty overlay view
*/
- (UIView *)makePlaceHolderView;

@optional
/*!
@brief enable tableView scroll when place holder view is showing, it is disabled by default.
@attention There is no need to return  NO, it will be NO by default
@return enable tableView scroll, you can only return YES
*/
- (BOOL)enableScrollWhenPlaceHolderViewShowing;





@end

