//
//  telstraTableViewCell.m
//  telstra_poc
//
//  Created by Mehak Kalra on 25/07/17.
//  Copyright © 2017 Mehak Kalra. All rights reserved.
//

#import "telstraTableViewCell.h"
#import "Masonry.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIView+WebCache.h"

float const kCellPadding = 1.0;

@implementation telstraTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateConstraints {
 int padding = 10;
    // use of masonry framework for setting up connstraints.
    [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@10);
        make.right.equalTo(@10);
        make.height.equalTo(@20);
    }];
    
    [_descriptionLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(padding);
        make.left.equalTo(@10);
        make.right.equalTo(@10);
    }];
    
    _descriptionLabel.numberOfLines = 0;
    
    
    [_imageInView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.lessThanOrEqualTo(_descriptionLabel.mas_bottom).offset(padding);
        make.left.equalTo(@10);
    }];


    
    [super updateConstraints];

    
}


-(void)setDetails:(Details *)details
{
    //_details=details;
    // int padding = 10;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.tag=1;
    
    _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _descriptionLabel.textColor = [UIColor blackColor];
    _descriptionLabel.tag=2;
    
    _imageInView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 85, 60, 50)];
    _imageInView.tag=3;

    if ((([self viewWithTag:1]) && ([self viewWithTag:2] && ([self viewWithTag:3]))))
    {
        [[self viewWithTag:1]removeFromSuperview];
        [[self viewWithTag:2]removeFromSuperview];
        [[self viewWithTag:3]removeFromSuperview];
    }

    [self addSubview:_titleLabel];
    [self addSubview:_descriptionLabel];
    [self addSubview:_imageInView];
    
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 1.0;
    
    
    
    _titleLabel.text = [details.detailTitle isKindOfClass:[NSNull class]]?@"":details.detailTitle;
    _descriptionLabel.text = [details.detailDescription isKindOfClass:[NSNull class]]?@"":details.detailDescription;
}


@end
