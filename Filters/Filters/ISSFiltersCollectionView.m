//
//  ISSFiltersCollectionView.m
//  Filters
//
//  Created by Кирилл Афонин on 12/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

#import "ISSFiltersCollectionView.h"
#import "ISSFiltersCollectionViewCell.h"

@interface ISSFiltersCollectionView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableDictionary <NSString *, UIImage *> *filtersDictionary; // Фильтр:Изображение с фильтром
@property (nonatomic, strong) NSArray <NSString *> *filtersArray; // список фильтров

@end

@implementation ISSFiltersCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[ISSFiltersCollectionViewCell class] forCellWithReuseIdentifier:@"FilterCell"];
        
        _filtersArray = [NSArray arrayWithObjects:@"CIColorMonochrome", @"CISepiaTone", @"CIVignette", @"CIUnsharpMask", @"CIBloom", @"CIEdges", @"CIGloom", nil];
        _filtersDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}


/**
 При установке изображения обновляем коллекцию и начинаем применять фильтры к нему
 */
- (void)setImage:(UIImage *)image
{
    _image = image;
    if (_image)
    {
        for (NSString *key in _filtersArray)
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self.filtersDictionary setObject:[self imageAfterFiltering:self.image withFilterName:key] forKey:key];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self reloadData]; // после того как фильтр применен обновляем коллекцию
                });
            });
        }
    } else
    {
        [_filtersDictionary removeAllObjects];
    }
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ISSFiltersCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FilterCell" forIndexPath:indexPath];

    if (self.image)
    {
        NSString *key = _filtersArray[indexPath.row];
        if (_filtersDictionary[key]) // если есть изображение с фильтром - ставим его
        {
            [cell.spinner stopAnimating];
            cell.imageView.image = _filtersDictionary[key];
            cell.titleLabel.text = key;
        } else { // если нет, то ставим оригинальное изображение с индикатором загрузки
            [cell.spinner startAnimating];
            cell.imageView.image = _image;
        }
    }
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _filtersArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width/4, collectionView.frame.size.height);
}

// Ставит изображение с фильтром вместо основного
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ISSFiltersCollectionViewCell *cell = (ISSFiltersCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self.cellDelegate didSelectImageWithFilter:cell.imageView.image];
}


#pragma mark - CIFilter


/**
 Применяет фильтр к изображению

 @param imageToFilter оригинальное изображение
 @param filterName название фильтра
 @return изображение с применнённым фильтром
 */
- (UIImage *)imageAfterFiltering:(UIImage *)imageToFilter withFilterName: (NSString *)filterName
{
    UIImage *imageToDisplay = [self normalizedImageWithImage:imageToFilter];
    
    CIContext *context = [[CIContext alloc] initWithOptions:nil];
    CIImage *ciImage = [[CIImage alloc] initWithImage:imageToDisplay];

    CIFilter *ciEdges = [CIFilter filterWithName:filterName];
    [ciEdges setValue:ciImage forKey:kCIInputImageKey];
    [ciEdges setValue:@1.0 forKey:@"inputIntensity"];

    CIImage *result = [ciEdges valueForKey:kCIOutputImageKey];

    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImage *filteredImage = [[UIImage alloc] initWithCGImage:cgImage];
    CFRelease(cgImage);
    
    return filteredImage;
}


#pragma mark - Helpers

- (UIImage *)normalizedImageWithImage:(UIImage *)image
{
    if (image.imageOrientation == UIImageOrientationUp)
    {
        return image;
    }
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
