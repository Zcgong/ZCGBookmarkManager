//
//  ViewController.m
//  ZCGClipShare
//
//  Created by zcgong on 16/8/19.
//  Copyright © 2016年 MIT. All rights reserved.
//

#import "ViewController.h"
#import "ZCGFileModel.h"
#import "ZCGTableView.h"
@interface ViewController ()<NSTableViewDataSource,NSTableViewDelegate,ZCGTableViewDelegate>
@property (nonatomic, strong) ZCGFileModel* fma;
@property (nonatomic, strong) ZCGTableView *kTableview;
@property (nonatomic, strong) NSScrollView *kScrollView;
@end
@implementation ViewController {
    BOOL asc;
    ZCGFileModel* selectedModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIconfig];
    asc = YES;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewSelectionDidChange:) name:NSTableViewSelectionDidChangeNotification object:nil];
}

- (void)UIconfig {
    self.title = @"ZCGClipShare";
    
    [self.view addSubview:self.kScrollView];
    [self.kScrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [self.kScrollView setDocumentView:self.kTableview];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.fma.dataArray.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray* array = @[@"OK",@"NO",@"NeedUpdate"];
    ZCGFileModel* dic = [self.fma.dataArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"name"]) {
        return dic.name;
    } else if ([tableColumn.identifier isEqualToString:@"state"]) {
        return [array objectAtIndex:dic.state];
    } else {
        return dic.url;
    }
}

- (void)btnAction {
    NSLog(@"btn clicked!");
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    NSSortDescriptor* des;
    asc = !asc;
    if ([tableColumn.identifier isEqualToString:@"name"]) {
        des = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:asc];
    } else if ([tableColumn.identifier isEqualToString:@"state"]) {
        des = [[NSSortDescriptor alloc]initWithKey:@"state" ascending:asc];
    } else {
        des = [[NSSortDescriptor alloc]initWithKey:@"url" ascending:asc];
    }
    [self.fma.dataArray sortUsingDescriptors:@[des]];
    [tableView reloadData];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView* ob = notification.object;
    NSLog(@"%ld",ob.selectedRow);
    selectedModel = [self.fma.dataArray objectAtIndex:ob.selectedRow];
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20;
}

- (void)rightMouseKeyDown:(NSUInteger)index {
    NSLog(@"%ld",index);
    if (index == 0) {
        
    } else if (index == 1) {
        
    } else if (index == 2) {
        NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:selectedModel.url]];
        NSURLSessionDataTask* datatask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSHTTPURLResponse* res = (NSHTTPURLResponse*)response;
            NSInteger index = [self.fma.dataArray indexOfObject:selectedModel];
            if (!error) {
                NSInteger status =  res.statusCode;
                if (status == 200) {
                    NSLog(@"OK");
                    selectedModel.state = 0;
                    
                    [self.fma.dataArray replaceObjectAtIndex:index withObject:selectedModel];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.kTableview reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:2]];
                    });
                }
            } else {
                NSLog(@"%@",error.description);
                selectedModel.state = 1;
                [self.fma.dataArray replaceObjectAtIndex:index withObject:selectedModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.kTableview reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:index] columnIndexes:[NSIndexSet indexSetWithIndex:2]];
                });
            }
        }];
        [datatask resume];
    }
    
}

- (ZCGTableView *)kTableview {
    if (!_kTableview) {
        _kTableview = [[ZCGTableView alloc] init];
        _kTableview.delegate = self;
        _kTableview.dataSource = self;
        _kTableview.kDelegate = self;
        NSTableColumn* columnTime = [[NSTableColumn alloc]initWithIdentifier:@"name"];
        columnTime.title = @"Name";
        NSTableColumn* columnContent = [[NSTableColumn alloc]initWithIdentifier:@"url"];
        columnContent.title = @"URL";
        NSTableColumn* columnState = [[NSTableColumn alloc]initWithIdentifier:@"state"];
        columnState.title = @"StateUpdate";
        [_kTableview addTableColumn:columnTime];
        [_kTableview addTableColumn:columnContent];
        [_kTableview addTableColumn:columnState];
    }
    return _kTableview;
}

- (NSScrollView *)kScrollView {
    if (!_kScrollView) {
        _kScrollView = [[NSScrollView alloc] init];
        [_kScrollView setHasVerticalScroller:YES];
    }
    return _kScrollView;
}

- (ZCGFileModel *)fma {
    if(_fma == nil) {
        _fma = [[ZCGFileModel alloc] init];
        [_fma getDataFromFile];
    }
    return _fma;
}

@end
