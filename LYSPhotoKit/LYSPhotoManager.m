//
//  LYSPhotoManager.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoManager.h"
#import "LYSPhotoFolderModel.h"
#import "LYSPhotoImageModel.h"

@implementation LYSPhotoManager

+ (void)loadFolderWithType:(PHAssetCollectionType)type subtype:(PHAssetCollectionSubtype)subtype callback:(void(^)(NSArray<LYSPhotoFolderModel *> *result))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHFetchResult<PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:(type) subtype:(subtype) options:nil];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (PHAssetCollection *asset in assetCollections) {
            LYSPhotoFolderModel *folderModel = [[LYSPhotoFolderModel alloc] init];
            folderModel.asset = asset;
            [tempArr addObject:folderModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(tempArr);
            }
        });
    });
}

+ (void)loadAssetsWithCollection:(PHAssetCollection *)assetCollection callback:(void(^)(NSArray<PHAsset *> *result))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *tempArr = [NSMutableArray array];
        PHFetchResult<PHAsset *> *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        for (PHAsset *asset in assets) {
            [tempArr addObject:asset];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(tempArr);
            }
        });
    });
}

+ (void)loadImageWithCollection:(PHAsset *)asset original:(BOOL)original targetSize:(CGSize)targetSize callback:(void(^)(UIImage *image))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:(PHImageContentModeAspectFill) options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (callback) {
                    callback(result);
                }
            });
        }];
    });
}


@end
