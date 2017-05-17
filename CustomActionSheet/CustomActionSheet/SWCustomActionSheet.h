//
//  SWCustomActionSheet.h
//  CustomActionSheet
//
//  Created by sword on 2017/5/17.
//  Copyright © 2017年 sword. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWCustomActionSheet;

@protocol SWCustomActionSheetDelegate <NSObject>

//点击的代理方法 ,buttonIndex为0时为取消按钮，当buttonIndex不为0时，为item索引（从1开始）
- (void)SWCustomActionSheet:(SWCustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface SWCustomActionSheet : UIView

@property (nonatomic,weak)id<SWCustomActionSheetDelegate> delegate;

/**
 *  @brief 初始化方法
 *  @param title 最上面的标题文字
 *  @param cancelTitle 取消按钮title
 *  @param firstItem item
 */
- (id)initWithDelegate:(id)delegate title:(NSString *)title  CancelButtonTitle:(NSString*)cancelTitle ButtonTitles:(NSString *)firstItem, ... NS_REQUIRES_NIL_TERMINATION;

//显示
- (void)show;

//隐藏
- (void)hide;

@end
