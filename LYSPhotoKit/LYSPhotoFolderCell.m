//
//  LYSPhotoFolderCell.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoFolderCell.h"
#import "LYSPhotoManager.h"
#import "LYSPhotoFolderModel.h"

@implementation LYSPhotoFolderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImg];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

- (UIImageView *)headerImg
{
    if (!_headerImg) {
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, LYSFolderCellHeight-5, LYSFolderCellHeight-5)];
    }
    return _headerImg;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headerImg.frame)+10, 0, 100, LYSFolderCellHeight)];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame)+10, 0, 100, LYSFolderCellHeight)];
        _numLabel.font = [UIFont systemFontOfSize:15];
        _numLabel.textColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    }
    return _numLabel;
}

- (void)setModel:(LYSPhotoFolderModel *)model
{
    _model = model;
    self.nameLabel.text = model.asset.localizedTitle;
    [self updateFrame:self.nameLabel left:CGRectGetMaxX(self.headerImg.frame)+10];
    if (!_model.subAssetArr) {
        [_model updateAssetArrCallback:^(NSArray<PHAsset *> * _Nonnull resultArr) {
            self.numLabel.text = [NSString stringWithFormat:@"(%ld)",resultArr.count];
            [self updateFrame:self.numLabel left:CGRectGetMaxX(self.nameLabel.frame)+10];
            [LYSPhotoManager loadImageWithCollection:resultArr.lastObject original:NO targetSize:CGSizeMake(LYSFolderCellHeight, LYSFolderCellHeight) callback:^(UIImage * _Nonnull image) {
                self.headerImg.image = image;
            }];
        }];
    } else {
        self.numLabel.text = [NSString stringWithFormat:@"(%ld)",_model.subAssetArr.count];
        [self updateFrame:self.numLabel left:CGRectGetMaxX(self.nameLabel.frame)+10];
        [LYSPhotoManager loadImageWithCollection:_model.subAssetArr.lastObject original:NO targetSize:CGSizeMake(LYSFolderCellHeight, LYSFolderCellHeight) callback:^(UIImage * _Nonnull image) {
            self.headerImg.image = image;
        }];
    }
}
- (void)updateFrame:(UILabel *)label left:(CGFloat)left
{
    CGRect tempFrame = label.frame;
    [label sizeToFit];
    label.frame = CGRectMake(left, tempFrame.origin.y, label.frame.size.width, tempFrame.size.height);
}

@end
