//
//  ViewController.m
//  ZHNformView
//
//  Created by zhn on 16/10/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "ZHNformView.h"

@interface ViewController ()<ZHNformViewDataSource>

@property (nonatomic,copy) NSArray * array;

@property (nonatomic,weak) ZHNformView * formView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@"有问题",@"直接联系我咯",@"建议",@"或者意见"];
    
    ZHNformView * forView = [[ZHNformView alloc]init];
    forView.dataSource = self;
//    forView.headTitleBackColor = [UIColor brownColor];
//    forView.showVerticalLayer = NO;
    forView.contentFont = 11;
    forView.titleFont = 20;
    forView.frame = CGRectMake(10, 100, 400, 300);
    [self.view addSubview:forView];
    self.formView = forView;
}

- (IBAction)reloadAction:(id)sender {
    self.array = @[@"看着",@"好像很厉害",@"的样子",@"🙄"];
    [self.formView ZHN_removeAssistLayer];
    [self.formView ZHN_reloadData];
}

#pragma mark - zhnformView delegate
- (NSArray<NSString *> *)headTitleArrayForZHNformView:(ZHNformView *)formView{
    return self.array;
}

- (NSInteger)numbOfSectionsInZHNformView:(ZHNformView *)forView{
    return 3;
}

- (NSString *)ZHNformView:(ZHNformView *)formView ContentOfCol:(NSInteger)col inRow:(NSInteger)row{
    return @"zhnnnnn出品";
}

- (NSArray *)itemHeightPercentArrayForZHNformView:(ZHNformView *)formView{
    return @[@"0.1",@"0.5",@"0.3",@"0.1"];
}

- (UIColor *)ZHNformView:(ZHNformView *)formView stringColorOfCol:(NSInteger)col inRow:(NSInteger)row{
    if (row == 1) {
        if (col == 1) {
            return [UIColor yellowColor];
        }
       return [UIColor redColor];
    }
    return nil;
}
- (UIColor *)ZHNformView:(ZHNformView *)formView headStringColorOfCol:(NSInteger)Col{
    if (Col == 1) {
        return [UIColor yellowColor];
    }
    return [UIColor blueColor];
}

- (CGFloat)headTitleHeightForZHNformView:(ZHNformView *)formView{
    return 100;
}

@end
