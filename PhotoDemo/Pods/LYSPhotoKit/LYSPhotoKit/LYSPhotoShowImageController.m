//
//  LYSPhotoShowImageController.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoShowImageController.h"
#import <Photos/Photos.h>
#import "LYSPhotoImageModel.h"
#import "LYSPhotoImageCell.h"
#import "LYSPhotoFolderModel.h"
#import "LYSPhotoManager.h"

@interface LYSPhotoShowImageController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *selectDataArr;
@end

@implementation LYSPhotoShowImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *returnBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
    returnBtn.frame = CGRectMake(0, 0, 40, 40);
    UIImage *image = [UIImage imageNamed:@"fanhui.png"];
    [returnBtn setImage:image forState:(UIControlStateNormal)];
    [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    [returnBtn addTarget:self action:@selector(returnBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *returnBarItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
    self.navigationItem.leftBarButtonItem = returnBarItem;
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = cancelItem;
    
    CGFloat w = (CGRectGetWidth(self.view.frame)-25)/4.0;
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout.itemSize = CGSizeMake(w, w);
    self.flowLayout.minimumLineSpacing = 5;
    self.flowLayout.minimumInteritemSpacing = 5;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollsToTop = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    self.dataArr = [NSMutableArray array];
    self.selectDataArr = [NSMutableArray array];
    [self.collectionView registerClass:[LYSPhotoImageCell class] forCellWithReuseIdentifier:@"LYSPhotoImageCell"];
    [self loadPhotoImage];
}

- (void)returnBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadPhotoImage
{
    if (self.assetCollectionType==0) {
        self.assetCollectionType = PHAssetCollectionTypeSmartAlbum;
    }
    
    if (self.assetCollectionSubtype==0) {
        self.assetCollectionSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    }
    
    [LYSPhotoManager loadFolderWithType:(self.assetCollectionType) subtype:(self.assetCollectionSubtype) callback:^(NSArray<LYSPhotoFolderModel *> * _Nonnull result) {
        if (result.count) {
            LYSPhotoFolderModel *model = result[0];
            self.navigationItem.title = model.asset.localizedTitle;
            if (!model.subAssetArr) {
                [model updateAssetArrCallback:^(NSArray<PHAsset *> * _Nonnull resultArr) {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for (PHAsset *asset in resultArr) {
                        LYSPhotoImageModel *imageModel = [[LYSPhotoImageModel alloc] init];
                        imageModel.asset = asset;
                        [tempArr addObject:imageModel];
                    }
                    self.dataArr = tempArr;
                    CGFloat s = self.dataArr.count * self.flowLayout.itemSize.height + (self.dataArr.count+1)*5;
                    [self.collectionView reloadData];
                    [self.collectionView setContentOffset:CGPointMake(0, s)];
                }];
            } else {
                NSMutableArray *tempArr = [NSMutableArray array];
                for (PHAsset *asset in model.subAssetArr) {
                    LYSPhotoImageModel *imageModel = [[LYSPhotoImageModel alloc] init];
                    imageModel.asset = asset;
                    [tempArr addObject:imageModel];
                }
                self.dataArr = tempArr;
                CGFloat s = self.dataArr.count * self.flowLayout.itemSize.height + (self.dataArr.count+1)*5;
                [self.collectionView reloadData];
                [self.collectionView setContentOffset:CGPointMake(0, s)];
            }
        }
    }];
}
// 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYSPhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYSPhotoImageCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LYSPhotoImageCell *cell = (LYSPhotoImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
    LYSPhotoImageModel *imageModel = self.dataArr[indexPath.row];
    if (self.selectDataArr.count < self.canSelectNum) {
        if ([self.selectDataArr containsObject:imageModel]) {
            [self.selectDataArr removeObject:imageModel];
            imageModel.selected = NO;
            cell.selectEnable = NO;
        } else {
            [self.selectDataArr addObject:imageModel];
            imageModel.selected = YES;
            cell.selectEnable = YES;
        }
    } else {
        if ([self.selectDataArr containsObject:imageModel]) {
            [self.selectDataArr removeObject:imageModel];
            imageModel.selected = NO;
            cell.selectEnable = NO;
        }
    }
    [self updateCellStatus];
}

- (void)updateCellStatus
{
    if (self.selectDataArr.count == self.canSelectNum) {
        for (int i = 0; i < self.dataArr.count; i++) {
            LYSPhotoImageModel *tempModel = self.dataArr[i];
            if (![self.selectDataArr containsObject:tempModel]) {
                tempModel.showCorver = YES;
                NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                LYSPhotoImageCell *tempCell = (LYSPhotoImageCell *)[self.collectionView cellForItemAtIndexPath:tempIndexPath];
                tempCell.showCorver = YES;
            }
        }
    } else {
        for (int i = 0; i < self.dataArr.count; i++) {
            LYSPhotoImageModel *tempModel = self.dataArr[i];
            tempModel.showCorver = NO;
            NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            LYSPhotoImageCell *tempCell = (LYSPhotoImageCell *)[self.collectionView cellForItemAtIndexPath:tempIndexPath];
            tempCell.showCorver = NO;
        }
    }
    if (self.selectDataArr.count) {
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveAction)];
        self.navigationItem.rightBarButtonItem = cancelItem;
    } else {
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelAction)];
        self.navigationItem.rightBarButtonItem = cancelItem;
    }
}

- (void)saveAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectImageWithArr:)]) {
        [self.delegate didSelectImageWithArr:self.selectDataArr];
    }
    if (self.fromPresent) {
        [self.navigationController.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
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


@end
