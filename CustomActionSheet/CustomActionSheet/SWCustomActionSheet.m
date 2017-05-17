//
//  SWCustomActionSheet.m
//  CustomActionSheet
//
//  Created by sword on 2017/5/17.
//  Copyright © 2017年 sword. All rights reserved.
//

#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ACTION_BTN_TAG 10000

#define ACTIONSHEET_BTN_HEIGHT 50.0

#import "SWCustomActionSheet.h"

@implementation SWCustomActionSheet{
    UIWindow *_window;
    UIView   *_bgView;
    UIView   *_actionSheetView;
    UIButton *_cancelButton;
    float    _lastHeight;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithDelegate:(id)delegate title:(NSString *)title  CancelButtonTitle:(NSString*)cancelTitle ButtonTitles:(NSString *)firstItem, ... NS_REQUIRES_NIL_TERMINATION
{
    _window = [UIApplication sharedApplication].keyWindow;
    self = [super initWithFrame:CGRectMake(0, 0, _window.bounds.size.width, _window.bounds.size.height)];
    if(self){
        _delegate = delegate;
        
        [self initBgView];
        
        [self addTap];
        
        _actionSheetView = [[UIView alloc] init];
        [self addSubview:_actionSheetView];
        
        if(title.length)
        {
            [self titleViewWithTitle:title];
        }
        
        //遍历buttons
        va_list args;
        va_start(args, firstItem);
        
        NSString *itemTitle = firstItem;
        for (int i=0; itemTitle != nil; itemTitle = va_arg(args,NSString*)) {
            UIButton *button = [self getButtonByIndex:i Title:itemTitle];
            
            //如果是确认删除，或者title为删除，则button显示红色
            [_actionSheetView addSubview:button];
            
            _lastHeight = button.frame.origin.y+button.frame.size.height;
            i++;
        }
        va_end(args);
        
        
        UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0, _lastHeight, self.frame.size.width, ACTIONSHEET_BTN_HEIGHT + 10)];
        cancelView.backgroundColor = RGBA(221, 221, 221, 1);
        [_actionSheetView addSubview:cancelView];
        
        //取消按钮
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.tag = ACTION_BTN_TAG;
        _cancelButton.frame = CGRectMake(0, 10, self.frame.size.width, ACTIONSHEET_BTN_HEIGHT);
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [cancelView addSubview:_cancelButton];
        
        [_cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
        [_cancelButton.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, cancelView.frame.origin.y+cancelView.frame.size.height);
    }
    return self;
}

- (void)initBgView
{
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0;
    [self addSubview:_bgView];
}

- (void)addTap
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
}

- (void)buttonClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if(!button || ![button isKindOfClass:[UIButton class]]){
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(SWCustomActionSheet:clickedButtonAtIndex:)]){
        [self.delegate SWCustomActionSheet:self clickedButtonAtIndex:button.tag-ACTION_BTN_TAG];
    }
    [self hide];
}

//显示
- (void)show
{
    [_window addSubview:self];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _actionSheetView.frame = CGRectMake(0, _window.frame.size.height - _actionSheetView.frame.size.height, _window.frame.size.width, _actionSheetView.frame.size.height);
        
        _bgView.alpha = 0.7;
    } completion:^(BOOL finished){
        if (finished){
        }}];
}

//隐藏
- (void)hide
{
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        _actionSheetView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, _actionSheetView.frame.size.height);
        _bgView.alpha = 0;
    } completion:^(BOOL finished){
        if (finished){
            [self removeFromSuperview];
        }}];
}


- (void)titleViewWithTitle:(NSString *)title
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, ACTIONSHEET_BTN_HEIGHT)];
    [titleView setBackgroundColor:[UIColor whiteColor]];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, titleView.frame.size.width-20, titleView.frame.size.height)];
    titleLabel.text = title;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor grayColor];
    [titleView addSubview:titleLabel];
    [_actionSheetView addSubview:titleView];
}

-(UIButton *)getButtonByIndex:(int)index Title:(NSString*)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = ACTION_BTN_TAG + index + 1;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    lineView.backgroundColor = RGBA(221, 221, 221, 1);
    
    btn.frame = CGRectMake(0, ACTIONSHEET_BTN_HEIGHT * (index + 1), self.frame.size.width, ACTIONSHEET_BTN_HEIGHT);
    btn.backgroundColor = [UIColor whiteColor];
    [btn addSubview:lineView];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    
    return btn;
}

@end
