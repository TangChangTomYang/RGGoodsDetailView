//
//  ViewController.m
//  RGGoodsDetailView
//
//  Created by yangrui on 2019/2/27.
//  Copyright © 2019 yangrui. All rights reserved.
//

#import "ViewController.h"
#import "RGGoodsDetailView.h"




@interface ViewController ()

@property (strong, nonatomic) RGGoodsDetailView *goodsDetailView ;
@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    RGGoodsDetailView *goodsDetailView = [[RGGoodsDetailView alloc]init];
    goodsDetailView.frame = self.view.bounds;
    [self.view addSubview:goodsDetailView];
    self.goodsDetailView = goodsDetailView;
    
}



 


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    NSLog(@"%@", NSStringFromCGRect(self.goodsDetailView.frame));
}

@end
