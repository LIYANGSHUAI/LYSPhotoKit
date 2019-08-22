//
//  LYSPhotoCollectController.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/22.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoCollectController.h"
#import "LYSPhotoImageCell.h"
#import "LYSPhotoFolderCell.h"
#import "LYSPhotoFolderModel.h"
#import <Photos/Photos.h>

typedef NS_ENUM(NSUInteger, LYSPhotoCollectType) {
    LYSPhotoCollectTypeNone,
    LYSPhotoCollectTypeFolder,
    LYSPhotoCollectTypeAllImage,
    LYSPhotoCollectTypeSectionImage
};
static LYSPhotoCollectController *photoVC = nil;
@interface LYSPhotoCollectController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) BOOL isNotMain;
@property (nonatomic, assign) LYSPhotoCollectType collectType;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *folderData;
@property (nonatomic, strong) NSMutableArray *imageData;

@property (nonatomic, strong) UICollectionViewFlowLayout *currentFlowLayout;

@property (nonatomic, strong) LYSPhotoFolderModel *sectionFolderModel;

@property (nonatomic, strong) NSMutableArray *selectImageArr;

@end

@implementation LYSPhotoCollectController

+ (instancetype)collectController
{
    if (photoVC==nil) {
        photoVC = [[LYSPhotoCollectController alloc] init];
        photoVC.isNotMain = YES;
        photoVC.collectType = LYSPhotoCollectTypeNone;
        LYSPhotoCollectController *folderVC = [[LYSPhotoCollectController alloc] init];
        folderVC.isNotMain = NO;
        folderVC.collectType = LYSPhotoCollectTypeFolder;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:folderVC];
        [photoVC addChildViewController:nav];
        [photoVC.view addSubview:nav.view];
        LYSPhotoCollectController *imageVC = [[LYSPhotoCollectController alloc] init];
        imageVC.isNotMain = NO;
        imageVC.collectType = LYSPhotoCollectTypeAllImage;
        [nav pushViewController:imageVC animated:NO];
    }
    return photoVC;
}

+ (void)releaseController
{
    photoVC= nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    if (!self.isNotMain) {
        [self customNav];
        [self customSubViews];
    }
}

- (void)customSubViews
{
    self.selectImageArr = [NSMutableArray array];
    
    UICollectionViewFlowLayout *defaultFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:defaultFlowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollsToTop = NO;
    [self.view addSubview:self.collectionView];
    self.currentFlowLayout = defaultFlowLayout;
    
    [self.collectionView registerClass:[LYSPhotoImageCell class] forCellWithReuseIdentifier:@"LYSPhotoImageCell"];
    [self.collectionView registerClass:[LYSPhotoFolderCell class] forCellWithReuseIdentifier:@"LYSPhotoFolderCell"];
    
    if (self.collectType == LYSPhotoCollectTypeAllImage) {
        self.navigationItem.title = @"所有照片";
        self.imageData = [NSMutableArray array];
        CGFloat w = (CGRectGetWidth(self.view.bounds) - 25)/4.0;
        CGFloat h = (CGRectGetWidth(self.view.bounds) - 25)/4.0;
        UICollectionViewFlowLayout *imageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        imageFlowLayout.itemSize = CGSizeMake(w, h);
        imageFlowLayout.minimumLineSpacing = 5;
        imageFlowLayout.minimumInteritemSpacing = 5;
        imageFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.collectionView setCollectionViewLayout:imageFlowLayout];
        self.currentFlowLayout = imageFlowLayout;
        [self loadAllPhotoImage];
    }
    
    if (self.collectType == LYSPhotoCollectTypeSectionImage) {
        self.navigationItem.title = self.sectionFolderModel.folderAsset.localizedTitle;
        self.imageData = [NSMutableArray array];
        CGFloat w = (CGRectGetWidth(self.view.bounds) - 25)/4.0;
        CGFloat h = (CGRectGetWidth(self.view.bounds) - 25)/4.0;
        UICollectionViewFlowLayout *imageFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        imageFlowLayout.itemSize = CGSizeMake(w, h);
        imageFlowLayout.minimumLineSpacing = 5;
        imageFlowLayout.minimumInteritemSpacing = 5;
        imageFlowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        [self.collectionView setCollectionViewLayout:imageFlowLayout];
        self.currentFlowLayout = imageFlowLayout;
        [self loadPhotoImageWith:self.sectionFolderModel];
    }
    
    if (self.collectType == LYSPhotoCollectTypeFolder) {
        self.navigationItem.title = @"照片";
        self.folderData = [NSMutableArray array];
        CGFloat w = CGRectGetWidth(self.view.bounds);
        CGFloat h = 60;
        UICollectionViewFlowLayout *folderFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        folderFlowLayout.itemSize = CGSizeMake(w, h);
        folderFlowLayout.minimumLineSpacing = 0;
        folderFlowLayout.minimumInteritemSpacing = 0;
        folderFlowLayout.sectionInset = UIEdgeInsetsMake(5, 0, 5, 0);
        [self.collectionView setCollectionViewLayout:folderFlowLayout];
        self.currentFlowLayout = folderFlowLayout;
        [self loadAllFolder];
    }
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1]}];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
}

- (void)loadPhotoImageWith:(LYSPhotoFolderModel *)sectionFolderModel
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.imageData = [self getImageWith:sectionFolderModel.folderAsset];
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat s = self.imageData.count * self.currentFlowLayout.itemSize.height + (self.imageData.count+1)*5;
            [self.collectionView reloadData];
            [self.collectionView setContentOffset:CGPointMake(0, s)];
        });
    });
}

- (void)loadAllPhotoImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum) subtype:(PHAssetCollectionSubtypeSmartAlbumUserLibrary) options:nil];
        for (PHAssetCollection *assetCollection in assetCollections) {
            self.imageData = [self getImageWith:assetCollection];
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat s = self.imageData.count * self.currentFlowLayout.itemSize.height + (self.imageData.count+1)*5;
                [self.collectionView reloadData];
                [self.collectionView setContentOffset:CGPointMake(0, s)];
            });
        }
    });
}

- (void)loadAllFolder
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 所有照片
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:(PHAssetCollectionTypeSmartAlbum) subtype:(PHAssetCollectionSubtypeAny) options:nil];
        for (PHAssetCollection *assetCollection in assetCollections) {
            LYSPhotoFolderModel *folderModel = [[LYSPhotoFolderModel alloc] init];
            folderModel.folderAsset = assetCollection;
            [self.folderData addObject:folderModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

- (NSMutableArray<LYSPhotoImageModel *> *)getImageWith:(PHAssetCollection *)assetCollection
{
    NSMutableArray *tempArr = [NSMutableArray array];
    PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
    for (PHAsset *asset in assets) {
        LYSPhotoImageModel *imageModel = [[LYSPhotoImageModel alloc] init];
        imageModel.imgAsset = asset;
        [tempArr addObject:imageModel];
    }
    return tempArr;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (self.collectType) {
        case LYSPhotoCollectTypeAllImage:
            return self.imageData.count;
            break;
        case LYSPhotoCollectTypeSectionImage:
            return self.imageData.count;
            break;
        case LYSPhotoCollectTypeFolder:
            return self.folderData.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.collectType) {
        case LYSPhotoCollectTypeAllImage:
        {
            LYSPhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYSPhotoImageCell" forIndexPath:indexPath];
            LYSPhotoImageModel *imageModel = self.imageData[indexPath.row];
            cell.imageModel = imageModel;
            cell.selectEnable = imageModel.selected;
            return cell;
        }
            break;
        case LYSPhotoCollectTypeSectionImage:
        {
            LYSPhotoImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYSPhotoImageCell" forIndexPath:indexPath];
            LYSPhotoImageModel *imageModel = self.imageData[indexPath.row];
            cell.imageModel = imageModel;
            cell.selectEnable = imageModel.selected;
            return cell;
        }
            break;
        case LYSPhotoCollectTypeFolder:
        {
            LYSPhotoFolderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LYSPhotoFolderCell" forIndexPath:indexPath];
            LYSPhotoFolderModel *folderModel = self.folderData[indexPath.row];
            cell.folderModel = folderModel;
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (self.collectType) {
        case LYSPhotoCollectTypeFolder:
        {
            LYSPhotoFolderModel *folderModel = self.folderData[indexPath.row];
            LYSPhotoCollectController *imageVC = [[LYSPhotoCollectController alloc] init];
            imageVC.isNotMain = NO;
            imageVC.collectType = LYSPhotoCollectTypeSectionImage;
            imageVC.sectionFolderModel = folderModel;
            [self.navigationController pushViewController:imageVC animated:YES];
        }
            break;
        case LYSPhotoCollectTypeAllImage:
        {
            LYSPhotoImageCell *cell = (LYSPhotoImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
            LYSPhotoImageModel *imageModel = self.imageData[indexPath.row];
            BOOL select = !imageModel.selected;
            if (select) {
                if (self.selectImageArr.count < [LYSPhotoCollectController collectController].canSelectImageNum) {
                    if (![self.selectImageArr containsObject:imageModel]) {
                        [self.selectImageArr addObject:imageModel];
                        imageModel.selected = select;
                        cell.selectEnable = select;
                    }
                }
            } else {
                if ([self.selectImageArr containsObject:imageModel]) {
                    [self.selectImageArr removeObject:imageModel];
                    imageModel.selected = select;
                    cell.selectEnable = select;
                }
            }
            if (self.selectImageArr.count == [LYSPhotoCollectController collectController].canSelectImageNum) {
                for (int i = 0; i < self.imageData.count; i++) {
                    LYSPhotoImageModel *tempImageModel = self.imageData[i];
                    if (![self.selectImageArr containsObject:tempImageModel]) {
                        tempImageModel.showCorver = YES;
                    } else {
                        tempImageModel.showCorver = NO;
                    }
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    LYSPhotoImageCell *tempCell = (LYSPhotoImageCell *)[collectionView cellForItemAtIndexPath:tempIndexPath];
                    tempCell.showCorver = tempImageModel.showCorver;
                }
            } else {
                for (int i = 0; i < self.imageData.count; i++) {
                    LYSPhotoImageModel *tempImageModel = self.imageData[i];
                    tempImageModel.showCorver = NO;
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    LYSPhotoImageCell *tempCell = (LYSPhotoImageCell *)[collectionView cellForItemAtIndexPath:tempIndexPath];
                    tempCell.showCorver = tempImageModel.showCorver;
                }
            }
        }
            break;
        case LYSPhotoCollectTypeSectionImage:
        {
            LYSPhotoImageCell *cell = (LYSPhotoImageCell *)[collectionView cellForItemAtIndexPath:indexPath];
            LYSPhotoImageModel *imageModel = self.imageData[indexPath.row];
            BOOL select = !imageModel.selected;
            if (select) {
                if (self.selectImageArr.count < [LYSPhotoCollectController collectController].canSelectImageNum) {
                    if (![self.selectImageArr containsObject:imageModel]) {
                        [self.selectImageArr addObject:imageModel];
                        imageModel.selected = select;
                        cell.selectEnable = select;
                    }
                }
            } else {
                if ([self.selectImageArr containsObject:imageModel]) {
                    [self.selectImageArr removeObject:imageModel];
                    imageModel.selected = select;
                    cell.selectEnable = select;
                }
            }
            if (self.selectImageArr.count == [LYSPhotoCollectController collectController].canSelectImageNum) {
                for (int i = 0; i < self.imageData.count; i++) {
                    LYSPhotoImageModel *tempImageModel = self.imageData[i];
                    if (![self.selectImageArr containsObject:tempImageModel]) {
                        tempImageModel.showCorver = YES;
                    } else {
                        tempImageModel.showCorver = NO;
                    }
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    LYSPhotoImageCell *tempCell = (LYSPhotoImageCell *)[collectionView cellForItemAtIndexPath:tempIndexPath];
                    tempCell.showCorver = tempImageModel.showCorver;
                }
            } else {
                for (int i = 0; i < self.imageData.count; i++) {
                    LYSPhotoImageModel *tempImageModel = self.imageData[i];
                    tempImageModel.showCorver = NO;
                    NSIndexPath *tempIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    LYSPhotoImageCell *tempCell = (LYSPhotoImageCell *)[collectionView cellForItemAtIndexPath:tempIndexPath];
                    tempCell.showCorver = tempImageModel.showCorver;
                }
            }
        }
            break;
        default:
            break;
    }
    if (self.selectImageArr.count) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleDone) target:self action:@selector(saveAction:)];
        self.navigationItem.rightBarButtonItem = btn;
    } else {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelAction:)];
        self.navigationItem.rightBarButtonItem = btn;
    }
}

- (void)saveAction:(UIBarButtonItem *)sender
{
    if ([LYSPhotoCollectController collectController].delegate && [[LYSPhotoCollectController collectController].delegate respondsToSelector:@selector(didSelectImages:)]) {
        [[LYSPhotoCollectController collectController].delegate didSelectImages:self.selectImageArr];
    }
    [self.navigationController.parentViewController dismissViewControllerAnimated:YES completion:^{
        [LYSPhotoCollectController releaseController];
    }];
}

+ (void)transitionImageModel:(LYSPhotoImageModel *)imageModel originality:(BOOL)originality customSize:(CGSize)customSize callback:(void(^)(UIImage *image))callback
{
    CGSize size = originality ? CGSizeMake(imageModel.imgAsset.pixelWidth, imageModel.imgAsset.pixelHeight) : customSize;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:imageModel.imgAsset targetSize:size contentMode:(PHImageContentModeAspectFill) options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"%@",info);
                if (callback) {
                    callback(result);
                };
            });
        }];
    });
}

- (void)customNav
{
    if (self.collectType == LYSPhotoCollectTypeAllImage || self.collectType == LYSPhotoCollectTypeSectionImage) {
        UIImage*image = [UIImage imageNamed:@"LYSPhotoResource.bundle/fanhui.png"];
        UIButton *returnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [returnBtn setImage:image forState:(UIControlStateNormal)];
        [returnBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        [returnBtn addTarget:self action:@selector(returnClickAction:) forControlEvents:(UIControlEventTouchUpInside)];
        UIBarButtonItem *returnBtnItem = [[UIBarButtonItem alloc] initWithCustomView:returnBtn];
        self.navigationItem.leftBarButtonItem = returnBtnItem;
    }
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStyleDone) target:self action:@selector(cancelAction:)];
    self.navigationItem.rightBarButtonItem = btn;
}

- (void)cancelAction:(UIBarButtonItem *)sender
{
    if ([LYSPhotoCollectController collectController].delegate && [[LYSPhotoCollectController collectController].delegate respondsToSelector:@selector(didDismiss)]) {
        [[LYSPhotoCollectController collectController].delegate didDismiss];
    }
    [self.navigationController.parentViewController dismissViewControllerAnimated:YES completion:^{
        [LYSPhotoCollectController releaseController];
    }];
}

- (void)returnClickAction:(UIButton *)sender
{
    switch (self.collectType) {
        case LYSPhotoCollectTypeAllImage:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case LYSPhotoCollectTypeSectionImage:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}
- (void)dealloc
{
    NSLog(@"释放");
}
@end
