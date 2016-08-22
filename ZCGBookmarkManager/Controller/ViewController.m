//
//  ViewController.m
//  ZCGClipShare
//
//  Created by zcgong on 16/8/19.
//  Copyright © 2016年 MIT. All rights reserved.
//

#import "ViewController.h"
#import "ZCGFileModel.h"
@interface ViewController ()
@property (nonatomic, strong)  ZCGFileModel* fma;
@end
@implementation ViewController {
    BOOL asc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ZCGClipShare";
    [self.view addSubview:self.kScrollView];
    [self.kScrollView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.equalTo(self.view);
    }];
    [self.kScrollView setDocumentView:self.kTableview];
    asc = YES;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear {
    [super viewDidAppear];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewSelectionDidChange:) name:NSTableViewSelectionDidChangeNotification object:nil];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.fma.dataArray.count;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    ZCGFileModel* dic = [self.fma.dataArray objectAtIndex:row];
    if ([tableColumn.identifier isEqualToString:@"name"]) {
        return dic.name;
    } else {
        return dic.url;
    }
    
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn {
    NSSortDescriptor* des;
    asc = !asc;
    if ([tableColumn.identifier isEqualToString:@"name"]) {
        des = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:asc];
    } else {
        des = [[NSSortDescriptor alloc]initWithKey:@"url" ascending:asc];
    }
    [self.fma.dataArray sortUsingDescriptors:@[des]];
    [tableView reloadData];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView* ob = notification.object;
    NSLog(@"%ld",ob.selectedRow);
    //捕捉鼠标事件 右键
    
}
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    return 20;
}


- (NSTableView *)kTableview {
    if (!_kTableview) {
        _kTableview = [[NSTableView alloc] init];
        _kTableview.delegate = self;
        _kTableview.dataSource = self;
        NSTableColumn* columnTime = [[NSTableColumn alloc]initWithIdentifier:@"name"];
        columnTime.title = @"Name";
        NSTableColumn* columnContent = [[NSTableColumn alloc]initWithIdentifier:@"url"];
        columnContent.title = @"URL";
        [_kTableview addTableColumn:columnTime];
        [_kTableview addTableColumn:columnContent];
        
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
