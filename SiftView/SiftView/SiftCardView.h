//
//  SiftCardView.h
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SiftCardView : UIView

@property (nonatomic) CGFloat viewWidth;
@property (nonatomic) CGFloat viewHeight;
@property (nonatomic) CGFloat imageURL;
@property (copy, nonatomic) NSDictionary *cardInfo;

@property (copy, nonatomic) UILabel *titleLabel;
@property (copy, nonatomic) UILabel *subtitleLabel;
@property (copy, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) UIImageView *leftActionImageView;
@property (copy, nonatomic) UIImageView *rightActionImageView;

@end
