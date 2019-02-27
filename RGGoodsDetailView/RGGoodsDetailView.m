//
//  RGGoodsDetailView.m
//  RGGoodsDetailView
//
//  Created by yangrui on 2019/2/27.
//  Copyright © 2019 yangrui. All rights reserved.
//

#import "RGGoodsDetailView.h"
#import "UIView+Extension.h"
#import "RGBuyMenu.h"


#define kScreenW  [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height


#define isIPhoneXScreen               (kScreenH==812)
#define isIPhone5Screen               (kScreenH==568)
#define isIPhone4Screen               (kScreenH==480)
#define isIPhone6Screen               (kScreenH==667)
#define isIPhone6PScreen              (kScreenH==736)

#define kNaviH                  (isIPhoneXScreen ? 88 : 64)
#define kBottomMargin           (isIPhoneXScreen ? 34 : 0)  // iphoneX底部去除34
#define kTopSafeY               (isIPhoneXScreen ? 22 : 0)  // iphoneX导航条上面22高度



#define kBottomMenuHeight (49 + kBottomMargin)
#define kMinSlideChangeHeight   150.0  // 最小滑动 切换高度


@interface RGGoodsDetailView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *goodsContainer;
@property (strong, nonatomic) UITableView *goodsTableView;
@property (strong, nonatomic) UIView  *goodsHeaderView;
@property (strong, nonatomic) UILabel  *pushDTipView;
@property (strong, nonatomic) UILabel  *pullDTipView;
@property (strong, nonatomic) UIWebView *goodsWebView;

@property (strong, nonatomic) RGBuyMenu *buyMenu;


@end




@implementation RGGoodsDetailView

-(RGBuyMenu *)buyMenu{
    if (!_buyMenu) {
        _buyMenu = [RGBuyMenu nibView];
        _buyMenu.frame = CGRectMake(0, kScreenH - kBottomMenuHeight, kScreenW, kBottomMenuHeight);
    }
    return _buyMenu;
}


-(UIView *)goodsContainer{
    if (!_goodsContainer) {
        CGRect frame = CGRectMake(0, 0, kScreenW, (kScreenH - kBottomMenuHeight) * 2);
        _goodsContainer = [[UIView alloc] initWithFrame:frame];
        _goodsContainer.backgroundColor = [UIColor redColor];
   
    }
    return _goodsContainer;
}

-(UITableView *)goodsTableView{
    if (!_goodsTableView) {
        CGRect frame = CGRectMake(0, 0, kScreenW, (kScreenH - kBottomMenuHeight));
        _goodsTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _goodsTableView.delegate = self;
        _goodsTableView.dataSource = self;
        _goodsTableView.backgroundColor = [UIColor greenColor];
        
        _goodsTableView.tableHeaderView = self.goodsHeaderView;
        [_goodsTableView addSubview:self.pushDTipView];
        
        
        [_goodsTableView addObserver:self forKeyPath: @"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _goodsTableView;
}


-(void)dealloc{
    [_goodsTableView removeObserver:self forKeyPath:@"contentSize" ];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentSize"] && object == self.goodsTableView) {
        
        
        NSLog(@"-----%@-----", NSStringFromCGRect(self.goodsTableView.bounds));
         NSLog(@"-size----%@-----", NSStringFromCGSize(self.goodsTableView.contentSize));
        
        self.pushDTipView.frame = CGRectMake(0, self.goodsTableView.contentSize.height, kScreenW, self.pushDTipView.height);
    }
}



-(UIWebView *)goodsWebView{
    if (!_goodsWebView) {
        CGFloat height = (kScreenH - kBottomMenuHeight);
        CGRect frame = CGRectMake(0, height, kScreenW, height);
        _goodsWebView  = [[UIWebView alloc] initWithFrame:frame];
        _goodsWebView.backgroundColor = [UIColor blueColor];
        _goodsWebView.layer.masksToBounds = YES;
        
        _goodsWebView.scrollView.delegate = self;
        
        [_goodsWebView.scrollView addSubview:self.pullDTipView];
        self.pullDTipView.y = -self.pullDTipView.height;
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [_goodsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
        });
        
    }
    
    return _goodsWebView;
}



-(UIView *)goodsHeaderView{
    if (!_goodsHeaderView) {
        CGRect frame = CGRectMake(0, 0, kScreenW, 200);
        _goodsHeaderView = [[UIView alloc] initWithFrame:frame];
        _goodsHeaderView .backgroundColor = [UIColor purpleColor];
    }
    return _goodsHeaderView;
}

-(UILabel *)pushDTipView{
    if (!_pushDTipView) {
        _pushDTipView = [self tipViewWithMsg:@"上啦 显示商品详情"];
        
    }
    return _pushDTipView;
}

-(UILabel *)pullDTipView{
    if(!_pullDTipView){
        _pullDTipView = [self tipViewWithMsg:@"下拉显示 显示商品信息"];
    }
    return _pullDTipView;
}




- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.goodsContainer];
        
        [self.goodsContainer addSubview:self.goodsTableView];
       
        [self.goodsContainer addSubview:self.goodsWebView];
        
        [self.goodsContainer addSubview:self.buyMenu];
        
    }
    return self;
}


-(UILabel *)tipViewWithMsg:(NSString *)msg{
    CGRect frame = CGRectMake(0, 0, kScreenW, 60);
    UILabel *lb = [[UILabel alloc]initWithFrame:frame];
    lb.backgroundColor = [UIColor lightGrayColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = msg;
    return lb;
}


-(void)setView:(UIView *)view layerColor:(UIColor *)color {
    view.layer.borderWidth = 3.0;
    view.layer.borderColor = color.CGColor;
}






#pragma mark- UIScrollViewDelegate
#pragma mark -- 监听滚动实现商品详情与图文详情界面的切换
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
 
    __weak typeof(self) weakself = self;
    
    CGFloat offset = scrollView.contentOffset.y;
    if (scrollView == self.goodsTableView) {
        if (offset > scrollView.contentSize.height - kScreenH + kBottomMenuHeight + kMinSlideChangeHeight) {
            
            [UIView animateWithDuration:0.4 animations:^{
                weakself.goodsContainer.transform = CGAffineTransformTranslate(weakself.goodsContainer.transform, 0, -kScreenH +  kBottomMenuHeight + kNaviH);
                weakself.buyMenu.alpha = 0;
            } completion:^(BOOL finished) {
                
                if (weakself.changePageCallback) {
                    weakself.changePageCallback(NO);
                }
                
            }];
        }
    }
    if (scrollView == self.goodsWebView.scrollView) {

        NSLog(@"------------");

        if (offset < - kMinSlideChangeHeight) {
            
            [UIView animateWithDuration:0.4 animations:^{
                [UIView animateWithDuration:0.4 animations:^{
                    weakself.goodsContainer.transform = CGAffineTransformIdentity;
                    weakself.buyMenu.alpha = 1;
                }];
            } completion:^(BOOL finished) {
                if (weakself.changePageCallback) {
                    weakself.changePageCallback(YES);
                }
            }];
        }
    }
}



//*******************下面TableView的代理是需要自行实现*********************
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"ID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"%@", NSStringFromCGRect(tableView.bounds));
    
}



@end
