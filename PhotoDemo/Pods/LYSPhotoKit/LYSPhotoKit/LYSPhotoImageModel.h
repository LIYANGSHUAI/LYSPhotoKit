//
//  LYSPhotoImageModel.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoFileModel.h"

NS_ASSUME_NONNULL_BEGIN
@class PHAsset;
@interface LYSPhotoImageModel : LYSPhotoFileModel
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL showCorver;
@end

NS_ASSUME_NONNULL_END
