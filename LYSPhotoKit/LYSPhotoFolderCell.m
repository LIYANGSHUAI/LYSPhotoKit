//
//  LYSPhotoFolderCell.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/22.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoFolderCell.h"
#import "LYSPhotoImageModel.h"

@interface LYSPhotoFolderCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) NSMutableArray *subImgData;
@end

@implementation LYSPhotoFolderCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, 0, 100, frame.size.height)];
        [self.contentView addSubview:self.titleLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, 0, 100, frame.size.height)];
        self.numLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.numLabel];
        
        self.indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame)-30,CGRectGetHeight(frame)/2.0-10, 20, 20)];
        self.indicatorImageView.tintColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.indicatorImageView];
        UIImage*image = [UIImage imageNamed:@"LYSPhotoResource.bundle/right.png"];
        self.indicatorImageView.image = image;
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, .5)];
        bottomLine.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
        [self.contentView addSubview:bottomLine];
        
    }
    return self;
}

- (void)setFolderModel:(LYSPhotoFolderModel *)folderModel
{
    _folderModel = folderModel;
    self.imageView.image = nil;
    self.titleLabel.text = _folderModel.folderAsset.localizedTitle;
    [self.titleLabel sizeToFit];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, 0, CGRectGetWidth(self.titleLabel.frame), CGRectGetHeight(self.frame));
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.subImgData = [self getImageWith:folderModel.folderAsset];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        LYSPhotoImageModel *imageModel = self.subImgData.lastObject;
        [[PHImageManager defaultManager] requestImageForAsset:imageModel.imgAsset targetSize:CGSizeMake(87.5, 87.5) contentMode:(PHImageContentModeAspectFill) options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = result;
                self.numLabel.text = [NSString stringWithFormat:@"(%ld)",self.subImgData.count];
                [self.numLabel sizeToFit];
                self.numLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, 0, CGRectGetWidth(self.numLabel.frame), CGRectGetHeight(self.frame));
            });
        }];
    });
}
- (NSMutableArray<UIImage *> *)getImageWith:(PHAssetCollection *)assetCollection
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
@end
