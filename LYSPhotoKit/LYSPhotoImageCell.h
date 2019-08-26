//
//  LYSPhotoImageCell.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LYSPhotoImageModel;
@interface LYSPhotoImageCell : UICollectionViewCell
@property (nonatomic, strong) LYSPhotoImageModel *model;
@property (nonatomic, assign) BOOL selectEnable;
@property (nonatomic, assign) BOOL showCorver;
@end

NS_ASSUME_NONNULL_END
