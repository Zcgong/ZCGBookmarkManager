//
//  ZCGFileModel.m
//
//
//  Created by zcgong on 16/8/19.
//  Copyright © 2016年 MIT. All rights reserved.
//

#import "ZCGFileModel.h"
static NSString* list = @"WebBookmarkTypeList";
static NSString* leaf = @"WebBookmarkTypeLeaf";
static NSString* proxy = @"WebBookmarkTypeProxy";
static NSString* url   = @"url";
static NSString* folder = @"folder";
@implementation ZCGFileModel

- (void)getDataFromFile {
    NSString* path = [[NSBundle mainBundle]pathForResource:@"Bookmark" ofType:@"plist"];
    NSDictionary* dic  = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString* path1 = [[NSBundle mainBundle]pathForResource:@"Bookmarks" ofType:@"json"];
    NSString* string = [NSString stringWithContentsOfFile:path1 encoding:4 error:nil];
    
    NSArray* root = [dic objectForKey:@"Children"];
    
    [self handleChilden:root];
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
    }else {
        NSDictionary* tem = [jsonDic objectForKey:@"roots"];
        NSDictionary* temp = [tem objectForKey:@"bookmark_bar"];
        [self handleJSONDic:temp];
    }
    
    NSSortDescriptor* des = [[NSSortDescriptor alloc]initWithKey:@"url" ascending:YES];
    [self.dataArray sortUsingDescriptors:@[des]];
    NSMutableArray* temp = [NSMutableArray new];
    for (NSUInteger i=1,count=self.dataArray.count; i < count; i++) {
        ZCGFileModel* model = [self.dataArray objectAtIndex:i];
        ZCGFileModel* lastModel = [self.dataArray objectAtIndex:i-1];
        if ([model.url isEqualToString:lastModel.url]) {
            [temp addObject:model];
        }
        
    }
    [self.dataArray removeObjectsInArray:temp];
}

- (void)handleJSONDic:(NSDictionary*)dict {
    NSMutableArray* temparr = [NSMutableArray new];
    for (NSDictionary* dic  in [dict objectForKey:@"children"]) {
        if ([[dic objectForKey:@"type"] isEqualToString:folder]) {
            [self handleJSONDic:dic];
        } else if ([[dic objectForKey:@"type"] isEqualToString:url]) {
            ZCGFileModel* model = [[ZCGFileModel alloc]init];
            model.name = [dic objectForKey:@"name"];
            model.url = [dic objectForKey:url];
            [temparr addObject:model];
        }
    }
    [self.dataArray addObjectsFromArray:temparr];
}

- (void)handleChilden:(NSArray*)childen {
    NSMutableArray* temparr = [NSMutableArray new];
    for (NSDictionary* dic in childen) {
        if ([[dic objectForKey:@"WebBookmarkType"] isEqualToString:list]) {
            [self handleChilden:[dic objectForKey:@"Children"]];
        }else if ([[dic objectForKey:@"WebBookmarkType"]isEqualToString:leaf]){
            ZCGFileModel* model = [[ZCGFileModel alloc]init];
            model.name = [[dic objectForKey:@"URIDictionary"] objectForKey:@"title"];
            model.url = [dic objectForKey:@"URLString"];
            [temparr addObject:model];
        }
    }
    [self.dataArray addObjectsFromArray:temparr];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
