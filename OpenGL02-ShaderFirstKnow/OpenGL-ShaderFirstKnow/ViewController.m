//
//  ViewController.m
//  OpenGL-ShaderFirstKnow
//
//  Created by zhu on 16/8/30.
//  Copyright © 2016年 alexzhu. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"

/* http://www.jianshu.com/p/ee597b2bd399 */

@interface ViewController ()
@property (strong, nonatomic) OpenGLView *glView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    OpenGLView *view = [[OpenGLView alloc] init];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
