//
//  ViewController.m
//  LYSPhotoKitDemo
//
//  Created by HENAN on 2019/8/21.
//  Copyright © 2019 HENAN. All rights reserved.
//

#import "ViewController.h"
#import "LYSPhotoCollectController.h"

@interface ViewController ()<LYSPhotoCollectControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, assign) LYSPhotoCollectController *collectVC;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(btnAction:)];
    self.navigationItem.rightBarButtonItem = btn;
    self.dataArr = [NSMutableArray array];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(100, 100);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [cell.contentView addSubview:imageView];
    LYSPhotoImageModel *model = self.dataArr[indexPath.row];
    [LYSPhotoCollectController transitionImageModel:model originality:YES customSize:CGSizeZero callback:^(UIImage * _Nonnull image) {
        imageView.image = image;
    }];
    return cell;
}

- (void)btnAction:(UIBarButtonItem *)sender
{
    [LYSPhotoCollectController collectController].canSelectImageNum = 5;
    [LYSPhotoCollectController collectController].delegate = self;
    [self presentViewController:[LYSPhotoCollectController collectController] animated:YES completion:nil];
}

- (void)didSelectImages:(NSArray<LYSPhotoImageModel *> *)images
{
    self.dataArr = [NSMutableArray arrayWithArray:images];
    [self.collectionView reloadData];
}

- (void)didDismiss
{
    NSLog(@"11");
}

@end
