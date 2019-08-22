//
//  LYSPhotoImageCell.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/22.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSPhotoImageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LYSPhotoImageCell : UICollectionViewCell
@property (nonatomic, strong) LYSPhotoImageModel *imageModel;
@property (nonatomic, assign) BOOL selectEnable;
@property (nonatomic, assign) BOOL showCorver;
@end

NS_ASSUME_NONNULL_END
