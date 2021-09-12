//
//  ViewController.m
//  TYMenuController
//
//  Created by TY on 2021/9/7.
//

#import "ViewController.h"
#import "ShowTextViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(130, 200, 160, 75);
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"下一页" forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 8;
    [btn addTarget:self action:@selector(actionToEnterNextPage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
}

- (void)actionToEnterNextPage:(UIButton *)sender {
    ShowTextViewController *showText = [[ShowTextViewController alloc]init];
    showText.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:showText animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
