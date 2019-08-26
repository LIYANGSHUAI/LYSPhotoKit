//
//  LYSPhotoFolderController.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoFolderController.h"
#import "LYSPhotoManager.h"
#import "LYSPhotoFolderModel.h"
#import "LYSPhotoFolderCell.h"
#import "LYSPhotoImageController.h"
#define FolderCellHeight 60

@interface LYSPhotoFolderController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation LYSPhotoFolderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"相册";
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.scrollsToTop = NO;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[LYSPhotoFolderCell class] forCellReuseIdentifier:@"LYSPhotoFolderCell"];
    self.dataArr = [NSMutableArray array];
    [self loadAllFolder];
}
- (void)cancelAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancelSelect)]) {
        [self.delegate didCancelSelect];
    }
    if (self.fromPresent) {
        [self.navigationController.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)loadAllFolder
{
    [LYSPhotoManager loadFolderWithType:(PHAssetCollectionTypeSmartAlbum) subtype:(PHAssetCollectionSubtypeAny) callback:^(NSArray<LYSPhotoFolderModel *> * _Nonnull result) {
        self.dataArr = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
    }];
}
// 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LYSPhotoFolderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LYSPhotoFolderCell"];
    
    if (!cell) {
        cell = [[LYSPhotoFolderCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"LYSPhotoFolderCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return LYSFolderCellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    LYSPhotoImageController *imageVC = [[LYSPhotoImageController alloc] init];
    imageVC.canSelectNum = self.canSelectNum;
    imageVC.model = self.dataArr[indexPath.row];
    imageVC.delegate = self.delegate;
    imageVC.fromPresent = self.fromPresent;
    [self.navigationController pushViewController:imageVC animated:YES];
}

@end
