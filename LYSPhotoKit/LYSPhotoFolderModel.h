//
//  LYSPhotoFolderModel.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/22.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface LYSPhotoFolderModel : NSObject
@property (nonatomic, strong) PHAssetCollection *folderAsset;
@end

NS_ASSUME_NONNULL_END
