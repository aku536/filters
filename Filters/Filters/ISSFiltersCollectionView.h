//
//  ISSFiltersCollectionView.h
//  Filters
//
//  Created by Кирилл Афонин on 12/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ISSCollectionViewCellDelegate <NSObject>
/**
 Передает изображение с фильтром делегату
 */
- (void)didSelectImageWithFilter:(UIImage *)imageWithFilter;
@end

/**
 Содержит изображения с применнеными к ним фильтрами
 */
@interface ISSFiltersCollectionView : UICollectionView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id <ISSCollectionViewCellDelegate> cellDelegate;

@end

