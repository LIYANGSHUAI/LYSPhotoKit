//
//  LYSPhotoFolderModel.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoFileModel.h"

NS_ASSUME_NONNULL_BEGIN
@class PHAssetCollection,PHAsset;
@interface LYSPhotoFolderModel : LYSPhotoFileModel
@property (nonatomic, strong) PHAssetCollection *asset;
@property (nonatomic, strong) NSArray<PHAsset *> *subAssetArr;
- (void)updateAssetArrCallback:(void(^)(NSArray<PHAsset *> *resultArr))callback;
@end

NS_ASSUME_NONNULL_END
