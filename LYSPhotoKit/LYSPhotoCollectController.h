//
//  LYSPhotoCollectController.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/22.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSPhotoImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LYSPhotoCollectControllerDelegate <NSObject>

@required
- (void)didSelectImages:(NSArray<LYSPhotoImageModel *> *)images;
- (void)didDismiss;

@end
@interface LYSPhotoCollectController : UIViewController
@property (nonatomic, assign) id<LYSPhotoCollectControllerDelegate> delegate;

// 可选择图片的个数,默认是一个
@property (nonatomic, assign) NSInteger canSelectImageNum;
/// 创建实例
+ (instancetype)collectController;

+ (void)transitionImageModel:(LYSPhotoImageModel *)imageModel originality:(BOOL)originality customSize:(CGSize)customSize callback:(void(^)(UIImage *image))callback;

@end

NS_ASSUME_NONNULL_END
