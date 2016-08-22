//
//  ZCGTableView.m
//  ZCGBookmarkManager
//
//  Created by zcgong on 16/8/22.
//  Copyright © 2016年 ZCG. All rights reserved.
//

#import "ZCGTableView.h"
@interface ZCGTableView () <NSMenuDelegate>

@end
@implementation ZCGTableView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSMenu* menu = [[NSMenu alloc]init];
    menu.delegate = self;
    NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:@"Delete" action:@selector(rightMouseKeyDidDown:) keyEquivalent:@""];
    item.tag = 0;
    NSMenuItem* asyn = [[NSMenuItem alloc]initWithTitle:@"Asyn" action:@selector(rightMouseKeyDidDown:) keyEquivalent:@""];
    asyn.tag = 1;
    NSMenuItem* usable = [[NSMenuItem alloc]initWithTitle:@"Usable" action:@selector(rightMouseKeyDidDown:) keyEquivalent:@""];
    usable.tag = 2;
    [menu addItem:item];
    [menu addItem:asyn];
    [menu addItem:usable];
    [NSMenu popUpContextMenu:menu withEvent:theEvent forView:self];
}

- (void)rightMouseKeyDidDown:(NSMenuItem*)item {
    if ([self.kDelegate respondsToSelector:@selector(rightMouseKeyDown:)]) {
        [self.kDelegate rightMouseKeyDown:item.tag];
    }
}
@end
