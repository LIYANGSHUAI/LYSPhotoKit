//
//  LYSPhotoController.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/23.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "LYSPhotoController.h"
#import "LYSPhotoFolderController.h"
#import "LYSPhotoShowImageController.h"

@interface LYSPhotoController ()
@property (nonatomic, strong) UINavigationController *nav;
@property (nonatomic, strong) LYSPhotoFolderController *folderVC;
@end

@implementation LYSPhotoController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.folderVC = [[LYSPhotoFolderController alloc] init];
        self.nav = [[UINavigationController alloc] initWithRootViewController:self.folderVC];
        [self.nav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1]}];
        self.nav.navigationBar.tintColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        [self addChildViewController:self.nav];
        self.canSelectNum = 1;
        self.fromPresent = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.nav.view];
    self.folderVC.canSelectNum = self.canSelectNum;
    self.folderVC.delegate = self.delegate;
    self.folderVC.fromPresent = self.fromPresent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LYSPhotoShowImageController *allImageVC = [[LYSPhotoShowImageController alloc] init];
    allImageVC.assetCollectionType = self.assetCollectionType;
    allImageVC.assetCollectionSubtype = self.assetCollectionSubtype;
    allImageVC.canSelectNum = self.canSelectNum;
    allImageVC.delegate = self.delegate;
    allImageVC.fromPresent = self.fromPresent;
    [self.nav pushViewController:allImageVC animated:NO];
}

@end
