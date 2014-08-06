//
//  SiftCardView.m
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import "SiftCardView.h"

@implementation SiftCardView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    _viewWidth = frame.size.width;
    _viewHeight = frame.size.height;
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _viewWidth, _viewHeight*0.85)];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imageView];
        
        _gradientView = [[GradientView alloc] initWithFrame:_imageView.frame];
        [self addSubview:_gradientView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imageView.frame.size.height-60, _viewWidth-20, 40)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"Card Title";
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _imageView.frame.size.height-30, _viewWidth-20, 30)];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.f];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.text = @"Card Subtitle";
        _subtitleLabel.numberOfLines = 2;
        [self addSubview:_subtitleLabel];
        
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftButton.frame = CGRectMake(0, _viewHeight*0.85, _viewWidth/2, _viewWidth*0.15);
        _leftButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:24.f];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_leftButton setTitle:@")" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(_viewWidth/2, _viewHeight*0.85, _viewWidth/2, _viewWidth*0.15);
        _rightButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:24.f];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_rightButton setTitle:@"R" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:_rightButton];
        
        _tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:_tapGesture];
        
    }
    return self;
}

@end
