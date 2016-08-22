//
//  ZCGTableView.h
//  ZCGBookmarkManager
//
//  Created by zcgong on 16/8/22.
//  Copyright © 2016年 ZCG. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ZCGTableViewDelegate <NSObject>
- (void)rightMouseKeyDown:(NSUInteger)index;
@end

@interface ZCGTableView : NSTableView
@property (nonatomic, weak) id<ZCGTableViewDelegate> kDelegate;
@end
