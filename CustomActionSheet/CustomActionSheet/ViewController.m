//
//  ViewController.m
//  CustomActionSheet
//
//  Created by sword on 2017/5/17.
//  Copyright © 2017年 sword. All rights reserved.
//

#import "ViewController.h"
#import "SWCustomActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)buttonClick:(id)sender
{
    SWCustomActionSheet *actionSheet = [[SWCustomActionSheet alloc] initWithDelegate:self title:nil CancelButtonTitle:@"取消" ButtonTitles:@"第一行",@"第二行",@"第三行",@"第四行", nil];
    [actionSheet show];
}

- (void)SWCustomActionSheet:(SWCustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"点击了取消按钮");
    }
    else{
        NSLog(@"点击了第%ld行",buttonIndex);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
