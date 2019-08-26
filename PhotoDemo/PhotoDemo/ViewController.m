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
