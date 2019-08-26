//
//  LYSPhotoFolderModel.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoFolderModel.h"
#import "LYSPhotoManager.h"

@interface LYSPhotoFolderModel ()
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation LYSPhotoFolderModel
- (void)updateAssetArrCallback:(void(^)(NSArray<PHAsset *> *resultArr))callback
{
    [LYSPhotoManager loadAssetsWithCollection:self.asset callback:^(NSArray<PHAsset *> * _Nonnull result) {
        self.dataArr = result;
        if (callback) {
            callback(result);
        }
    }];
}

- (NSArray<PHAsset *> *)subAssetArr
{
    if (!_subAssetArr) {
        _subAssetArr = self.dataArr;
    }
    return _subAssetArr;
}

@end
