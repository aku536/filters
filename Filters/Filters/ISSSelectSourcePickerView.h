//
//  ISSSelectSourcePickerView.h
//  Filters
//
//  Created by Кирилл Афонин on 12/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Главное представление, содержит в себе кнопки открытия камеры и галлереи, изображение и collectionView с фильтрами
 */
@interface ISSSelectSourcePickerView : UIView
+ (ISSSelectSourcePickerView *)selectSourceView;
@end
