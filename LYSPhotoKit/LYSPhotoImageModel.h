//
//  LYSPhotoImageModel.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/22.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
NS_ASSUME_NONNULL_BEGIN

@interface LYSPhotoImageModel : NSObject
@property (nonatomic, strong) PHAsset *imgAsset;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL showCorver;
@end

NS_ASSUME_NONNULL_END
