# LYSPhotoKit
实现图标选择组件

![iOS技术群群二维码](https://github.com/LIYANGSHUAI/LYSRepository/blob/master/iOS技术群群二维码.JPG)

```objc
@interface LYSPhotoController : UIViewController

// 代理
@property (nonatomic, assign) id<LYSPhotoControllerDelegate> delegate;

// 默认是被模态出来的,主要是用来解决控制器如果是模态出来的,此属性不用做修改,默认属性就可以,如果是导航push出来的
@property (nonatomic, assign) BOOL fromPresent;

// 默认打开的相册
@property (nonatomic, assign) PHAssetCollectionType assetCollectionType;
@property (nonatomic, assign) PHAssetCollectionSubtype assetCollectionSubtype;
/// 可选图片的个数,默认是一张
@property (nonatomic, assign) NSInteger canSelectNum;

@end
```
```objc
@class LYSPhotoImageModel;
@protocol LYSPhotoControllerDelegate <NSObject>
- (void)didSelectImageWithArr:(NSArray<LYSPhotoImageModel *> *)imageModels;
- (void)didCancelSelect;
@end
```
```objc
// 使用方法
LYSPhotoController *vc = [LYSPhotoController new];
vc.canSelectNum = 5;
vc.assetCollectionType = PHAssetCollectionTypeSmartAlbum;
vc.assetCollectionSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
[self presentViewController:vc animated:YES completion:nil];
```
