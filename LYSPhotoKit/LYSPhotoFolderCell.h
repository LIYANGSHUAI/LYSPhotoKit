//
//  LYSPhotoFolderCell.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class LYSPhotoFolderModel;
@interface LYSPhotoFolderCell : UITableViewCell
@property (nonatomic, strong) LYSPhotoFolderModel *model;
@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numLabel;
@end

NS_ASSUME_NONNULL_END
