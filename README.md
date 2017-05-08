# ZHNformView
项目需要用到表格来展示数据，最开始我想到的是封装一些tableview来显示。但是我尝试了之后发现实在是性能堪忧。没办法，找了一圈也找到符合我要求的库。干脆自己写一个算了

![image](https://raw.githubusercontent.com/zhnnnnn/ZHNformView/master/demo.gif)

###### 主要特性

* 异步绘制，性能保障。

* 自定义各类颜色字体大小之类属性。

* 接口设计类似`UitableView`一看就懂。

###### 使用方法

1.把ZHNformView文件拖入到项目中

2.创建view设置属性实现代理方法类似如下（具体看如何使用viewcontroller里代码）

```
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
```
