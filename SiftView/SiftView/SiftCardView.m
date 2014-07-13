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
        self.layer.cornerRadius = 6.f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.f;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _viewWidth-20, _viewWidth*0.66)];
        _imageView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_imageView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _viewWidth*0.66, _viewWidth-20, 40)];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"Card Title";
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _titleLabel.frame.origin.y+30, _viewWidth-20, 20)];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.f];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.text = @"Card Subtitle";
        [self addSubview:_subtitleLabel];
        
    }
    return self;
}

@end
