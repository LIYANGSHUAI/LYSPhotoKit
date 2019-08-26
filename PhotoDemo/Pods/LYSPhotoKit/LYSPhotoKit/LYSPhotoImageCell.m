//
//  LYSPhotoImageCell.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoImageCell.h"
#import "LYSPhotoManager.h"
#import "LYSPhotoImageModel.h"
#import "LYSPhotoResource.h"
@interface LYSPhotoImageCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *corverView;
@property (nonatomic, strong) UIButton *selectBtn;
@end

@implementation LYSPhotoImageCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.selectBtn];
        [self.contentView addSubview:self.corverView];
    }
    return self;
}

- (UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        UIImage *defaultImage = [UIImage imageNamed:@""];
        [_selectBtn setImage:defaultImage forState:(UIControlStateNormal)];
        NSData *decodeData = [[NSData alloc]initWithBase64EncodedString:LYSPHOTODUIHAO options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        UIImage *selectImage = [UIImage imageWithData:decodeData];
        [_selectBtn setImage:selectImage forState:(UIControlStateSelected)];
        _selectBtn.tintColor = [UIColor clearColor];
        _selectBtn.frame = CGRectMake(self.frame.size.width-20, self.frame.size.height-20, 20, 20);
    }
    return _selectBtn;
}

- (UIView *)corverView
{
    if (!_corverView) {
        _corverView = [[UIView alloc] initWithFrame:self.bounds];
        _corverView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _corverView;
}

- (void)setSelectEnable:(BOOL)selectEnable
{
    _selectEnable = selectEnable;
    self.selectBtn.selected = _selectEnable;
}

- (void)setShowCorver:(BOOL)showCorver
{
    _showCorver = showCorver;
    self.corverView.hidden = !showCorver;
}

- (void)setModel:(LYSPhotoImageModel *)model
{
    _model = model;
    self.corverView.hidden = !model.showCorver;
    self.selectBtn.selected = model.selected;
    [LYSPhotoManager loadImageWithCollection:model.asset original:NO targetSize:self.frame.size callback:^(UIImage * _Nonnull image) {
        self.imageView.image = image;
    }];
}
@end
