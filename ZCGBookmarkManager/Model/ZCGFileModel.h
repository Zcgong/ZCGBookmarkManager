//
//  ZCGFileModel.h
// 
//
//  Created by zcgong on 16/8/19.
//  Copyright © 2016年 MIT. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface ZCGFileModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void)getDataFromFile;
@end
