//
//  ViewController.m
//  ZHNformView
//
//  Created by zhn on 16/10/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ViewController.h"
#import "ZHNformView.h"

@interface ViewController ()<ZHNformViewDataSource,ZHNformViewDelegate>

@property (nonatomic,copy) NSArray * array;
@property (nonatomic,copy) NSArray * statusArray;

@property (nonatomic,weak) ZHNformView * formView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = @[@"姓名",@"得分",@"篮板",@"助攻",@"抢断"];
    self.statusArray = @[
                         @[@"库里",@"46",@"5",@"5",@"2"],
                         @[@"汤普森",@"24",@"4",@"1",@"3"],
                         @[@"杜兰特",@"22",@"3",@"5",@"1"],
                         @[@"格林",@"4",@"12",@"11",@"1"],
                         @[@"帕楚里亚",@"2",@"1",@"1",@"0"],
                         @[@"大卫韦斯特",@"8",@"4",@"2",@"0"],
                         @[@"利文斯顿",@"4",@"3",@"1",@"1"],
                         @[@"伊戈达拉",@"2",@"4",@"8",@"2"],
                         ];
    ZHNformView * forView = [[ZHNformView alloc]init];
    forView.dataSource = self;
    forView.delegate = self;
//    forView.headTitleBackColor = [UIColor brownColor];
//    forView.showVerticalLayer = NO;
    forView.contentFont = 11;
    forView.titleFont = 20;
    forView.frame = CGRectMake(10, 100, 300, 300);
    [self.view addSubview:forView];
    self.formView = forView;
}

- (IBAction)reloadAction:(id)sender {
    self.statusArray = @[
                         @[@"戴维斯",@"33",@"13",@"1",@"0"],
                         @[@"摩尔",@"15",@"3",@"5",@"0"],
                         @[@"弗雷泽",@"13",@"4",@"10",@"1"],
                         @[@"阿西克",@"6",@"8",@"0",@"0"],
                         @[@"所罗门希尔",@"2",@"5",@"4",@"1"],
                         @[@"加洛维",@"9",@"2",@"4",@"1"],
                         @[@"巴迪",@"9",@"6",@"1",@"1"],
                         @[@"康宁汉姆",@"8",@"1",@"1",@"0"],
                         ];
    [self.formView ZHN_removeAssistLayer];
    [self.formView ZHN_reloadData];
}

#pragma mark - zhnformView delegate
- (NSArray<NSString *> *)headTitleArrayForZHNformView:(ZHNformView *)formView{
    return self.array;
}

- (NSInteger)numbOfSectionsInZHNformView:(ZHNformView *)forView{
    return self.statusArray.count;
}

- (NSString *)ZHNformView:(ZHNformView *)formView ContentOfCol:(NSInteger)col inRow:(NSInteger)row{
    return self.statusArray[row][col];
}

- (NSArray *)itemHeightPercentArrayForZHNformView:(ZHNformView *)formView{
    return @[@"0.4",@"0.15",@"0.15",@"0.15",@"0.15"];
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
    return 40;
}

#pragma mark zhnformView delegate
- (void)ZHNformView:(ZHNformView *)formView selectedRow:(NSInteger)row col:(NSInteger)col{
    
    NSLog(@"row - %ld col - %ld",row,col);
}

@end
