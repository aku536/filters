//
//  ISSFiltersCollectionViewCell.m
//  Filters
//
//  Created by Кирилл Афонин on 12/11/2019.
//  Copyright © 2019 Кирилл Афонин. All rights reserved.
//

#import "ISSFiltersCollectionViewCell.h"

@implementation ISSFiltersCollectionViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
}

- (UIActivityIndicatorView *)spinner
{
    if (_spinner) {
        return _spinner;
    }
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _spinner.center = self.imageView.center;
    [self.contentView addSubview:_spinner];
    return _spinner;
}

- (UILabel *)titleLabel
{
    if (_titleLabel) {
        return _titleLabel;
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 25)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor blackColor];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_titleLabel];
    
    return _titleLabel;
}

- (UIImageView *)imageView
{
    if (_imageView) {
        return _imageView;
    }
    _imageView = [[UIImageView alloc] initWithFrame:
                  CGRectMake(0,
                             25,
                             self.contentView.frame.size.width,
                             self.contentView.frame.size.height - 25)];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.contentView addSubview:_imageView];
    return _imageView;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    [self.imageView setImage:nil];
    [self.titleLabel setText:@""];
    [self.spinner startAnimating];
}

@end
