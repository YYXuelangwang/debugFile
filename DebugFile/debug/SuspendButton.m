//
//  SuspendButton.m
//  webViewForHttps
//
//  Created by wujie on 16/6/12.
//  Copyright © 2016年 yinyong. All rights reserved.
//

#import "SuspendButton.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

static const NSInteger KPrefixItem_Tag = 200;

@interface SuspendButton()

@end

@implementation SuspendButton

- (instancetype)init{
    return [self initWithFrame:CGRectMake(0, 0, 30, 30)];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.alpha = 0.3;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveInTheScreen:)];
        [self addGestureRecognizer:pan];
        [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)moveInTheScreen:(UIPanGestureRecognizer*)pan{
    
    NSAssert(self.superview, @"btn.superView cann't be nil");
    
    CGPoint pt = [pan locationInView:self.superview];
    self.center = pt;
    switch (pan.state) {
        case UIGestureRecognizerStateEnded:
            
            [self handleTheBtnToSideWith:pt];
            NSLog(@"pan end");
            break;
            
        case UIGestureRecognizerStateBegan:
            
            self.alpha = 1.0;
            break;
            
        default:
            break;
    }
}

- (void)handleTheBtnToSideWith:(CGPoint)lastPt{
    
    if (self.selected) {
        return;
    }
    
    CGPoint center = CGPointZero;
    
    if (CGRectContainsPoint(CGRectMake(0, 64, kScreenWidth * 0.5, kScreenHeight - 64 - 49), lastPt)) {
        center = CGPointMake(self.frame.size.width * 0.5, lastPt.y);
    }
    
    if (CGRectContainsPoint(CGRectMake(kScreenWidth * 0.5, 64, kScreenWidth * 0.5, kScreenHeight - 64 - 49), lastPt)) {
        center = CGPointMake(kScreenWidth - self.frame.size.width * 0.5, lastPt.y);
    }
    
    if (CGRectContainsPoint(CGRectMake(0, 0, kScreenWidth, 64), lastPt)) {
        center = CGPointMake(lastPt.x, self.frame.size.height * 0.5);
    }
    
    if (CGRectContainsPoint(CGRectMake(0, kScreenHeight - 49, kScreenWidth, 49), lastPt)) {
        center = CGPointMake(lastPt.x, kScreenHeight - self.frame.size.height * 0.5);
    }
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = center;
        self.alpha = 0.3;
    } completion:^(BOOL finished) {
    }];
    
}

- (void)clicked:(UIButton*)btn{
    self.selected = !self.selected;
    if (self.selected) {
        [self configItems];
    }else{
        for (UIView *view in self.subviews) {
            view.hidden = YES;
        }
        [self handleTheBtnToSideWith:self.center];
    }
}

- (void)configItems{
    int count = 1;
    if (self.itemsData && self.itemsData.count > 0) {
        count = (int)self.itemsData.count + 1;
    }
    if (count == self.subviews.count) {
        for (UIView *view in self.subviews) {
            view.hidden = NO;
        }
        return;
    }
    
    float angle = 2 * M_PI / (count * 1.0);
    float radius = 100.0;
    CGFloat itemWidth = 45;
    for (int i = 0; i < count; i ++) {
        UIButton *btn = [self viewWithTag:KPrefixItem_Tag + i];
        if (!btn) {
            btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = KPrefixItem_Tag + i;
            [self addSubview:btn];
            btn.layer.cornerRadius = itemWidth * 0.5;
            btn.layer.masksToBounds = YES;
            btn.backgroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:arc4random()%255/255.0];
            btn.titleLabel.adjustsFontSizeToFitWidth = YES;
            [btn addTarget:self action:@selector(clickedItem:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.frame = CGRectMake(radius * cos(angle * i) - itemWidth * 0.5 + self.bounds.size.width * 0.5, radius * sin(angle * i) - itemWidth * 0.5 + self.bounds.size.height * 0.5, itemWidth, itemWidth);
        if (i == count - 1) {
            [btn setTitle:@"delete" forState:UIControlStateNormal];
        }else{
            YYItemData *data = [self.itemsData objectAtIndex:i];
            [btn setTitle:data.allKeys.firstObject forState:UIControlStateNormal];
        }
        btn.hidden = NO;
    }
}

- (void)clickedItem:(UIButton*)btn{
    NSInteger index = btn.tag - KPrefixItem_Tag;
    if (!self.itemsData || self.itemsData.count <= 0 || index >= self.itemsData.count) {
        [self removeFromSuperview];
        return;
    }
    YYItemData *data = [self.itemsData objectAtIndex:index];
    yyItemClicked block = data.allValues.firstObject;
    if (block) {
        block(btn);
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint pt = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, pt) && (!subView.hidden)) {
                view = subView;
                break;
            }
        }
    }
    return view;
}

@end
