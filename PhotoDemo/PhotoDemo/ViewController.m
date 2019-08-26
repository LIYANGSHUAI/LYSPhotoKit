//
//  ViewController.m
//  PhotoDemo
//
//  Created by HENAN on 2019/8/26.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "ViewController.h"
#import <LYSPhotoKit/LYSPhotoController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString * bundleNameWithExtension = @"LYSPhotoResource.bundle";
    NSString * bundlePath = [[NSBundle bundleForClass:[ViewController class]].resourcePath
                             stringByAppendingPathComponent:bundleNameWithExtension];
    NSBundle * bundle = [NSBundle bundleWithPath:bundlePath];
    NSLog(@"%@",bundle);
    UIImage * image = [UIImage imageNamed:@"Resources/fanhui" inBundle:bundle compatibleWithTraitCollection:nil];
    
    NSLog(@"%@",image);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    LYSPhotoController *vc = [LYSPhotoController new];
    vc.canSelectNum = 5;
    vc.assetCollectionType = PHAssetCollectionTypeSmartAlbum;
    vc.assetCollectionSubtype = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
    [self presentViewController:vc animated:YES completion:nil];
}

@end
