//
//  ViewController.m
//  SiftView
//
//  Created by Daniel.Burke on 7/9/14.
//  Copyright (c) 2014 D2 Development. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cardData = [NSMutableArray arrayWithObjects:
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Lebron as a rookie", @"title",
                  @"A star on the rise", @"subtitle",
                  @"lebron-rookie.png", @"imageName", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Lebron in Miami", @"title",
                  @"Finally a champion", @"subtitle",
                  @"lebron-miami.jpg", @"imageName", nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Lebron back in Cleveland", @"title",
                  @"The king returns", @"subtitle",
                  @"lebron-cavs.jpg", @"imageName",  nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Lebron back in Cleveland", @"title",
                  @"The king returns", @"subtitle",
                  @"lebron-cavs.jpg", @"imageName",  nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Lebron back in Cleveland", @"title",
                  @"The king returns", @"subtitle",
                  @"lebron-cavs.jpg", @"imageName",  nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Lebron back in Cleveland", @"title",
                  @"The king returns", @"subtitle",
                  @"lebron-cavs.jpg", @"imageName",  nil],
                 [NSDictionary dictionaryWithObjectsAndKeys:
                  @"Lebron back in Cleveland", @"title",
                  @"The king returns", @"subtitle",
                  @"lebron-cavs.jpg", @"imageName",  nil],
                 nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    CGRect siftViewFrame = self.view.bounds;
    siftViewFrame.origin.y = 84;
    _siftView = [[SiftView alloc] initWithFrame:siftViewFrame data:_cardData];
    [_siftView.rightActionButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_siftView.leftActionButton setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    [self.view addSubview:_siftView];
    [_siftView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
