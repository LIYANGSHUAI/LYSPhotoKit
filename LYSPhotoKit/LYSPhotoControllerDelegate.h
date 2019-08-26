//
//  LYSPhotoControllerDelegate.h
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class LYSPhotoImageModel;
@protocol LYSPhotoControllerDelegate <NSObject>
- (void)didSelectImageWithArr:(NSArray<LYSPhotoImageModel *> *)imageModels;
- (void)didCancelSelect;
@end

NS_ASSUME_NONNULL_END
