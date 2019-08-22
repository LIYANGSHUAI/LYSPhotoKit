//
//  LYSPhotoImageCell.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/22.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoImageCell.h"

@interface LYSPhotoImageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *duiImageView;
@property (nonatomic, strong) UIView *coverView;
@end

@implementation LYSPhotoImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:self.imageView];
        self.duiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-20, frame.size.height-20, 20, 20)];
        self.duiImageView.image = [UIImage imageNamed:@"LYSPhotoResource.bundle/dui_press.png"];
        self.duiImageView.alpha = 0;
        [self.contentView addSubview:self.duiImageView];
        self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.coverView.backgroundColor = [UIColor whiteColor];
        self.coverView.alpha = 0.5;
        [self.contentView addSubview:self.coverView];
        self.coverView.hidden = YES;
    }
    return self;
}

- (void)setShowCorver:(BOOL)showCorver
{
    _showCorver = showCorver;
    self.coverView.hidden = !showCorver;
}

- (void)setSelectEnable:(BOOL)selectEnable
{
    _selectEnable = selectEnable;
    self.duiImageView.alpha = _selectEnable;
}

- (void)setImageModel:(LYSPhotoImageModel *)imageModel
{
    _imageModel = imageModel;
    self.coverView.hidden = !imageModel.showCorver;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageForAsset:imageModel.imgAsset targetSize:CGSizeMake(87.5, 87.5) contentMode:(PHImageContentModeAspectFill) options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = result;
            });
        }];
    });
}

@end
