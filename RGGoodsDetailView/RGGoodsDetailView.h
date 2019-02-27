//
//  RGGoodsDetailView.h
//  RGGoodsDetailView
//
//  Created by yangrui on 2019/2/27.
//  Copyright © 2019 yangrui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^RGChangePageCallback)(BOOL isTop);


@interface RGGoodsDetailView : UIView
@property (assign, nonatomic)BOOL shouldAnimate;

@property (strong, nonatomic) RGChangePageCallback changePageCallback;
@end

NS_ASSUME_NONNULL_END
