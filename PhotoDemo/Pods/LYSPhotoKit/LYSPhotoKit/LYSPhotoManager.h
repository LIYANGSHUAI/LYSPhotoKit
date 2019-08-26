//
//  LYSPhotoManager.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

#define LYSFolderCellHeight 70

@class LYSPhotoFolderModel;
@interface LYSPhotoManager : NSObject
+ (void)loadFolderWithType:(PHAssetCollectionType)type subtype:(PHAssetCollectionSubtype)subtype callback:(void(^)(NSArray<LYSPhotoFolderModel *> *result))callback;
+ (void)loadAssetsWithCollection:(PHAssetCollection *)assetCollection callback:(void(^)(NSArray<PHAsset *> *result))callback;
+ (void)loadImageWithCollection:(PHAsset *)asset original:(BOOL)original targetSize:(CGSize)targetSize callback:(void(^)(UIImage *image))callback;
@end

NS_ASSUME_NONNULL_END
