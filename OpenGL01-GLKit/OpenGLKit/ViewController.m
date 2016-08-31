//
//  ViewController.m
//  OpenGLKit
//
//  Created by zhu on 16/8/30.
//  Copyright © 2016年 alexzhu. All rights reserved.
//

/* http://www.jianshu.com/p/750fde1d8b6a */

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) EAGLContext *mContext;
@property (strong, nonatomic) GLKBaseEffect *mEffect;
@property (assign, nonatomic) int mCount;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.mContext;
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;//颜色缓冲区格式
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;// 模板缓冲区格式
    [EAGLContext setCurrentContext:self.mContext];
    
    //顶点数据,前三个是顶点坐标,后三个是纹理坐标,每行一个顶点
    GLfloat squareVertexData[] = {
        0.5, -0.5, 0.0,  1.0, 0.0, //右下
        -0.5, 0.5, 0.0,  0.0, 1.0, //左上
        -0.5, -0.5, 0.0, 0.0, 0.0, //左下
        0.5, 0.5, -0.0,  1.0, 1.0 //右上
    };
    
    //顶点索引
    GLuint indices[] = {
        0, 1, 2,
        1, 3, 0
    };
    self.mCount = sizeof(indices) / sizeof(GLuint);
    
    //顶点数据缓存
    GLuint buffer;
    glGenBuffers(1, &buffer);//申请标示符
    glBindBuffer(GL_ARRAY_BUFFER, buffer);//把标示符绑定到GL_ARRAY_BUFFER上
    glBufferData(GL_ARRAY_BUFFER, sizeof(squareVertexData), squareVertexData, GL_STATIC_DRAW);//把顶点数据从CPU内存复制到GPU内存
    
    GLuint index;
    glGenBuffers(1, &index);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, index);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);//开启对应的顶点属性
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 0);//设置合适的格式从BUFFER里读取
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);//纹理
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat) * 5, (GLfloat *)NULL + 3);
    
    /*
     void glVertexAttribPointer(GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride,const GLvoid * pointer);
     * 该数组与GL_ARRAY_BUFFER绑定,储存于缓冲区中
     index  指定要修改顶点属性的索引值
     size   指定每个顶点属性的索引值,必须为1,2,3或者4,默认为4
     type   指定数组中每个顶点属性的组件数量
     normalized  指定当被访问时,固定点数据值是否应该被统一化
     stride  指定连续顶点之间的偏移量,如果为0,顶点属性会被理解为:它们是紧密排列在一起的
     pointer 指定第一个组件在第一个顶点属性中得偏移量,初始值为0
     */
    
    //纹理贴图
    NSString *str = [[NSBundle mainBundle] pathForResource:@"mine_bg" ofType:@"png"];
    NSDictionary *options = [NSDictionary dictionaryWithObject:@(1) forKey:GLKTextureLoaderOriginBottomLeft];//GLKTextureLoaderOriginBotstomLeft 纹理坐标系是相反的
    
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:str options:options error:nil];
    
    //启动着色器
    self.mEffect = [[GLKBaseEffect alloc] init];
    self.mEffect.texture2d0.enabled = GL_TRUE;
    self.mEffect.texture2d0.name = info.name;
    
    // Do any additional setup after loading the view, typically from a nib.
}
/**
 *  渲染场景代码
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClearColor(0.3f, 0.6f, 1.0f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT); //清除颜色,和深度缓冲
    
    //启动着色器
    [self.mEffect prepareToDraw];
    glDrawElements(GL_TRIANGLES, self.mCount, GL_UNSIGNED_INT, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
