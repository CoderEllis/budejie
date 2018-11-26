//
//  ELLoginRegisterViewController.m
//  budejie
//
//  Created by Soul Ai on 24/11/2018.
//  Copyright © 2018 Soul Ai. All rights reserved.
//

#import "ELLoginRegisterViewController.h"
#import "ELLoginRegisterView.h"
#import "ELFastLoginView.h"

@interface ELLoginRegisterViewController ()

@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadCons;
@property (weak, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation ELLoginRegisterViewController

// 越复杂的界面 越要封装(复用)
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ELLoginRegisterView *loginView = [ELLoginRegisterView loginView];
    [self.middleView addSubview:loginView];
    
    ELLoginRegisterView *registerView = [ELLoginRegisterView registerView];
    [self.middleView addSubview:registerView];
    
    ELFastLoginView *fastloginView = [ELFastLoginView fastLoginView];
    [self.buttonView addSubview:fastloginView];
}

// viewDidLayoutSubviews:才会根据布局调整控件的尺寸
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    ELLoginRegisterView *loginView = self.middleView.subviews[0];
    loginView.frame = CGRectMake(0, 0, self.middleView.el_width * 0.5, self.middleView.el_height);
    
    ELLoginRegisterView *registerView = self.middleView.subviews[1];
    registerView.frame = CGRectMake(self.middleView.el_width * 0.5, 0, self.middleView.el_width * 0.5, self.middleView.el_height);
    
    ELFastLoginView *fastloginView = self.buttonView.subviews.firstObject;
    fastloginView.frame = self.buttonView.bounds;
    
}


- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickRegister:(UIButton *)sender {
    sender.selected = !sender.selected;
    // 平移中间view
    _leadCons.constant = _leadCons.constant == 0? -self.middleView.el_width * 0.5:0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
