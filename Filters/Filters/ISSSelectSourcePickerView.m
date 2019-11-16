//
//  ISSSelectSourcePickerView.m
//  Filters
//
//  Created by Кирилл Афонин on 12/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

#import "ISSSelectSourcePickerView.h"
#import "ISSFiltersCollectionView.h"

const CGFloat ISSButtonHeight = 50.0;
const CGFloat ISSLabelHeight = 45.0;

@interface ISSSelectSourcePickerView() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ISSCollectionViewCellDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) UIButton *galleryButton;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) ISSFiltersCollectionView *collectionView;

- (BOOL)canShowCamera;

@end

@implementation ISSSelectSourcePickerView

/**
 Инициализация view, отображение всех UI элементов
 */
+ (ISSSelectSourcePickerView *)selectSourceView
{
    ISSSelectSourcePickerView *selectPickerView = [ISSSelectSourcePickerView new];
    
    selectPickerView.frame = [UIScreen mainScreen].bounds;
    [selectPickerView addSubview:selectPickerView.imageView];
    [selectPickerView addSubview:selectPickerView.collectionView];
    [selectPickerView addSubview:selectPickerView.titleLabel];
    [selectPickerView addSubview:selectPickerView.galleryButton];
    if ([selectPickerView canShowCamera])
    {
        [selectPickerView addSubview:selectPickerView.cameraButton];
    }
    
    return selectPickerView;
}


/**
 Метод, который проверяет, есть ли доступ к камере на устройстве
 */
- (BOOL)canShowCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}


/**
 Метод делегата, устанавливает изображение с фильтровм
 @param imageWithFilter отфильтрованное изображение
 */
- (void)didSelectImageWithFilter:(UIImage *)imageWithFilter
{
    self.imageView.image = imageWithFilter;
}


#pragma mark - Getters

// Отображает основную картинку
- (UIImageView *)imageView
{
    if (_imageView)
    {
        return _imageView;
    }
    
    CGFloat imageViewWidth = [UIScreen mainScreen].bounds.size.width;
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, imageViewWidth, imageViewWidth)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    _imageView.clipsToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped)];
    [_imageView addGestureRecognizer:tap];
    
    return _imageView;
}

/**
 Содержит изображения с применнёнными к ним фильтрами
 */
- (UICollectionView *)collectionView
{
    if (_collectionView)
    {
        return _collectionView;
    }
    
    CGRect frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 25, [UIScreen mainScreen].bounds.size.width, 125);
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[ISSFiltersCollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    _collectionView.hidden = YES;
    _collectionView.cellDelegate = self;
    
    return _collectionView;
}

// Подсказка к действию
- (UILabel *)titleLabel
{
    if (_titleLabel)
    {
        return  _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.galleryButton.frame) - ISSLabelHeight, CGRectGetWidth(self.frame), ISSLabelHeight)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"Выберите изображение";
    
    return _titleLabel;
}


/**
 Кнопка открытия галлереи
 */
- (UIButton *)galleryButton
{
    if (_galleryButton)
    {
        return _galleryButton;
    }
    _galleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat minY = [self canShowCamera] ? CGRectGetMinY(self.cameraButton.frame) : CGRectGetMaxY(self.frame) - 50;
    _galleryButton.frame = CGRectMake(0, minY - ISSButtonHeight, CGRectGetWidth(self.frame), ISSButtonHeight);
    [_galleryButton setTitle:@"Галерея" forState:UIControlStateNormal];
    [_galleryButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_galleryButton addTarget:self action:@selector(galleryButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    return _galleryButton;
}


/**
 Кнопка открытия камеры, не отображается, если нет доступа к камере
 */
- (UIButton *)cameraButton
{
    if (_cameraButton)
    {
        return _cameraButton;
    }
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - ISSButtonHeight - 50, CGRectGetWidth(self.frame), ISSButtonHeight);
    [_cameraButton setTitle:@"Камера" forState:UIControlStateNormal];
    [_cameraButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_cameraButton addTarget:self action:@selector(cameraButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    return _cameraButton;
}


#pragma mark - Actions

/**
 По нажатию на imageView показывает/скрывает галлерею
 */
- (void)imageViewTapped
{
    if (_imageView.image) {
        _collectionView.hidden = !_collectionView.isHidden;
        if (_imageView.image)
        {
            _collectionView.image = _imageView.image;
            [_collectionView reloadData];
        }
    }
}

// Открывает галлерею
- (void)galleryButtonPressed
{
    _collectionView.hidden = YES;
    [self presentPickerControllerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

// Открывает камеру
- (void)cameraButtonPressed
{
    _collectionView.hidden = YES;
    [self presentPickerControllerForSourceType: UIImagePickerControllerSourceTypeCamera];
}

//  pickerView открывает камеру либо галлерею и презентует меню
- (void)presentPickerControllerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *pickerController = [UIImagePickerController new];
    pickerController.sourceType = sourceType;
    pickerController.delegate = self;
    pickerController.editing = YES;
    
    UIViewController *viewControllerToPresent = [UIApplication sharedApplication].delegate.window.rootViewController;
    [viewControllerToPresent presentViewController:pickerController animated:YES completion:nil];
}


#pragma mark - UIImagePickerController

// Устанавливает изображение в imageView, collectionView и закрывает представление камеры/галлереи
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info
{
    NSData *img = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage], 0.0);
    UIImage *imageFromGallery = [UIImage imageWithData:img];
    self.imageView.image = imageFromGallery;
    _collectionView.image = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// Закрывает представление камеры/галлереи
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
