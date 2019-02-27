//
//  UIView+nib.m
//  RGGoodsDetailView
//
//  Created by yangrui on 2019/2/27.
//  Copyright © 2019 yangrui. All rights reserved.
//

#import "UIView+nib.h"

@implementation UIView (nib)
+(instancetype)nibView{
    
    return  [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject ];
}
@end
