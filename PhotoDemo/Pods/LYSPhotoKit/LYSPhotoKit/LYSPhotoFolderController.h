//
//  LYSPhotoFolderController.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYSPhotoControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface LYSPhotoFolderController : UIViewController
// 默认是被模态出来的,主要是用来解决控制器如果是模态出来的,此属性不用做修改,默认属性就可以,如果是导航push出来的
@property (nonatomic, assign) BOOL fromPresent;
@property (nonatomic, assign) id<LYSPhotoControllerDelegate> delegate;
/// 可选图片的个数
@property (nonatomic, assign) NSInteger canSelectNum;
@end

NS_ASSUME_NONNULL_END
