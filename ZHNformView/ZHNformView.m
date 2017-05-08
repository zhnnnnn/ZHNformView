//
//  ZHNformView.m
//  ZHNformView
//
//  Created by zhn on 16/10/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "ZHNformView.h"

#define KZHN_VIEWHEIGHT self.frame.size.height
#define KZHN_VIEWWIDTH self.frame.size.width

@interface ZHNformView()

// -------- 用于显示 ------------//
@property (nonatomic,weak) CALayer * contentLayer;
@property (nonatomic,weak) CALayer * verticalShowLayer;
@property (nonatomic,weak) CALayer * HorizontalShowLayer;

// ------- 用于手势计算 ---------//
@property (nonatomic,assign) CGFloat KheadHeight;
@property (nonatomic,assign) CGFloat KitemHeight;
@property (nonatomic,copy) NSArray * kitemWidthArray;

@end


@implementation ZHNformView
#pragma mark  - view cycle

- (instancetype)init{
    if (self = [super init]) {
        self.showHorizontalLayer = YES;
        self.showVerticalLayer = YES;
        self.clipsToBounds = YES;
        [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    if (!self.headTitleBackColor) {
        self.headTitleBackColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1.0];
    }
    if (!self.titleFont) {
        self.titleFont = 17;
    }
    if (!self.contentFont) {
        self.contentFont = 14;
    }
    
    if (self.showVerticalLayer) {
        [self.layer addSublayer:self.verticalShowLayer];
    }
    if (self.showHorizontalLayer) {
        [self.layer addSublayer:self.HorizontalShowLayer];
    }
    [self.layer addSublayer:self.contentLayer];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseItemAction:)];
    [self addGestureRecognizer:tap];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self p_layoutContent];
    });
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"bounds"]) {
        self.contentLayer.frame = self.bounds;
    }
}

#pragma mark - target action
- (void)choseItemAction:(UITapGestureRecognizer *)tapGesture{
    
    CGPoint tapPoint =  [tapGesture locationInView:self];
    
    // 点击了标题
    if (tapPoint.y <= self.KheadHeight) {
        [self ZHN_removeAssistLayer];
        return;
    }
    
    // 水平
    NSInteger row =  (tapPoint.y - self.KheadHeight)/self.KitemHeight;
    CGRect HshowLayerRect = CGRectMake(0, (row * self.KitemHeight) + self.KheadHeight , KZHN_VIEWWIDTH, self.KitemHeight);
    
    // 垂直
    CGFloat sum = 0;
    NSInteger col = 0;
    CGRect VshowLayerRect = CGRectMake(0, 0, 0, 0);
    for (int index = 0; index < self.kitemWidthArray.count; index++) {
        CGFloat width = [self.kitemWidthArray[index]floatValue];
        if (tapPoint.x >= sum && tapPoint.x <= sum+width) {
            VshowLayerRect = CGRectMake(sum, self.KheadHeight, width, KZHN_VIEWHEIGHT - self.KheadHeight);
            col = index;
        }
        sum += width;
    }
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(ZHNformView:selectedRow:col:)]) {
        [self.delegate ZHNformView:self selectedRow:row col:col];
    }
    
    // CATransaction是为了关闭隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.HorizontalShowLayer.frame = HshowLayerRect;
    self.verticalShowLayer.frame = VshowLayerRect;
    [CATransaction commit];
    
}

#pragma mark - public method
- (void)ZHN_reloadData{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.layer.contents = nil;
        for (UIView * temp in self.subviews) {
            [temp removeFromSuperview];
        }
        [self p_layoutContent];
    });
}

- (void)ZHN_removeAssistLayer{
    // CATransaction是为了关闭隐式动画
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.HorizontalShowLayer.frame = CGRectMake(0, 0, 0, 0);
    self.verticalShowLayer.frame = CGRectMake(0, 0, 0, 0);
    [CATransaction commit];
}

#pragma mark - pravite method
- (void)p_layoutContent{
    
    NSArray * headTitleArray = [self.dataSource headTitleArrayForZHNformView:self];
    NSArray * itemWidthPercentArray;
    CGFloat headHeight = -1;
    
    // 处理有问题的输入
    if (self.isCustomHeadTitleWidth && [self.dataSource respondsToSelector:@selector(itemWidthPercentArrayForZHNformView:)]) {
        itemWidthPercentArray = [self.dataSource itemWidthPercentArrayForZHNformView:self];
        NSAssert(itemWidthPercentArray.count == headTitleArray.count, @"itemHeightPercentArrayForZHNformView方法和headTitleArrayForZHNformView返回数组的个数请相等");
        CGFloat sum = 0;
        for (int index = 0; index < itemWidthPercentArray.count; index++) {
            CGFloat currentPercent = [itemWidthPercentArray[index]floatValue];
            NSAssert(currentPercent != 0, @"itemHeightPercentArrayForZHNformView方法返回的数组请别包含负数或者字符");
            sum += currentPercent;
        }
        NSAssert(sum >= 1.00000001 && sum <= 1.0000001, @"itemHeightPercentArrayForZHNformView 方法输入的百分比的总和请等于1");
    }
    if ([self.dataSource respondsToSelector:@selector(headTitleHeightForZHNformView:)]) {
        CGFloat height = [self.dataSource headTitleHeightForZHNformView:self];
        NSAssert(height > 0 && headHeight <= KZHN_VIEWHEIGHT,@"headTitleHeightForZHNformView表格标题的高度必须大于0并且不能整个表格的高度高");
        headHeight = height;
    }
    
    NSInteger rowCount = headTitleArray.count;
    NSInteger sectionCount = [self.dataSource numbOfSectionsInZHNformView:self];
    CGFloat itemHeight = KZHN_VIEWHEIGHT / (sectionCount + 1);
    if (headHeight < 0) {
        headHeight = itemHeight;
    }else{
        itemHeight = (KZHN_VIEWHEIGHT - headHeight) / sectionCount;
    }
    self.KheadHeight = headHeight;
    self.KitemHeight = itemHeight;
    
    NSMutableArray * widthArray = [NSMutableArray array];
    NSMutableArray * newWidthArray = [NSMutableArray array];
    CGFloat titleStringSumWidth = 0;
    
    // 计算宽度
    if (itemWidthPercentArray.count > 0 && self.isCustomHeadTitleWidth) {
        for (int index = 0; index < itemWidthPercentArray.count; index++) {
            CGFloat percent = [itemWidthPercentArray[index]floatValue];
            [newWidthArray addObject:@(percent * KZHN_VIEWWIDTH)];
        }
    }else{
        for (NSString * titleString in headTitleArray) {
            CGSize size = [titleString sizeWithAttributes: @{NSFontAttributeName: [UIFont systemFontOfSize:self.titleFont]}];
            titleStringSumWidth += size.width;
            [widthArray addObject:@(size.width)];
        }
        
        for (int i = 0; i < widthArray.count; i++) {
            CGFloat width = [widthArray[i] floatValue];
            CGFloat percent = width/titleStringSumWidth;
            [newWidthArray addObject:@(percent * KZHN_VIEWWIDTH)];
        }
    }
    self.kitemWidthArray = [newWidthArray copy];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;// 这个属性是能够画字符的时候换行
    paragraphStyle.alignment=NSTextAlignmentCenter;
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, (1/[UIScreen mainScreen].scale));
    [self.headTitleBackColor setFill];
    
    // 画标题的背景
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, KZHN_VIEWWIDTH, 0);
    CGContextAddLineToPoint(context, KZHN_VIEWWIDTH, headHeight);
    CGContextAddLineToPoint(context, 0, headHeight);
    CGContextFillPath(context);
    
    // 画最外面的四边形
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, KZHN_VIEWWIDTH, 0);
    CGContextAddLineToPoint(context, KZHN_VIEWWIDTH, KZHN_VIEWHEIGHT);
    CGContextAddLineToPoint(context, 0, KZHN_VIEWHEIGHT);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextStrokePath(context);
    
    // 画横线
    for (int lineSec = 0; lineSec < sectionCount; lineSec ++) {
        CGContextSetLineWidth(context, (1/[UIScreen mainScreen].scale)/3);
        CGFloat height = lineSec * itemHeight + headHeight;
        CGContextMoveToPoint(context, 0, height);
        CGContextAddLineToPoint(context, KZHN_VIEWWIDTH, height);
        CGContextStrokePath(context);
    }
    
    // 画竖线
    CGFloat sumRowWidth = 0;
    for (int lineRow = 0; lineRow < rowCount; lineRow++) {
        CGFloat currentRowWidth = [newWidthArray[lineRow]floatValue];
        sumRowWidth += currentRowWidth;
        CGContextMoveToPoint(context, sumRowWidth, 0);
        CGContextAddLineToPoint(context, sumRowWidth, KZHN_VIEWHEIGHT);
        CGContextStrokePath(context);
    }
    
    // 画标题
    CGFloat currentSumWidth = 0;
    for (int j = 0; j < headTitleArray.count; j++) {
        
        NSString * headTitle = headTitleArray[j];
        CGFloat titleW = [newWidthArray[j] floatValue];
        CGSize fitSize =  [self p_boundingRectWithText:headTitle size:CGSizeMake(titleW, MAXFLOAT) font:self.titleFont];
        CGFloat titleH = headHeight;
        CGFloat titleX = currentSumWidth;
        CGFloat titleY = 0;
        if (fitSize.height < titleH) {
            titleY = (titleH - fitSize.height)/2;
        }
        currentSumWidth += titleW;
        
        UIColor * headTitleStringColor = [UIColor darkGrayColor];
        if ([self.dataSource respondsToSelector:@selector(ZHNformView:headStringColorOfCol:)]) {
            if ([self.dataSource ZHNformView:self headStringColorOfCol:j]) {
                headTitleStringColor = [self.dataSource ZHNformView:self headStringColorOfCol:j];
            }
        }
        [headTitle drawInRect:CGRectMake(titleX, titleY, titleW, titleH) withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:self.titleFont],NSForegroundColorAttributeName:headTitleStringColor,NSParagraphStyleAttributeName:paragraphStyle}];
    }
    
    // 画内容
    for (int ksec = 0; ksec < sectionCount; ksec++) {
        currentSumWidth = 0;
        for (int krow = 0; krow < headTitleArray.count; krow++) {
            
            NSString * content = [self.dataSource ZHNformView:self ContentOfCol:krow inRow:ksec];
            CGFloat contentH = itemHeight;
            CGFloat contentW = [newWidthArray[krow] floatValue];
            CGSize fitSize =  [self p_boundingRectWithText:content size:CGSizeMake(contentW, MAXFLOAT) font:self.contentFont];
            CGFloat contentX = currentSumWidth;
            CGFloat contentY = itemHeight * ksec + headHeight;
            if (fitSize.height < contentH) {
                contentY += (contentH - fitSize.height)/2;
            }
            currentSumWidth += contentW;
            
            UIColor * stringColor = [UIColor blackColor];
            if ([self.dataSource respondsToSelector:@selector(ZHNformView:stringColorOfCol:inRow:)]) {
                if ([self.dataSource ZHNformView:self stringColorOfCol:krow inRow:ksec]) {
                    stringColor = [self.dataSource ZHNformView:self stringColorOfCol:krow inRow:ksec];
                }
            }
            
            [content drawInRect:CGRectMake(contentX, contentY, contentW, contentH) withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:self.contentFont],NSForegroundColorAttributeName:stringColor,NSParagraphStyleAttributeName:paragraphStyle}];
        }
    }
    
    UIImage * currentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    dispatch_async(dispatch_get_main_queue(), ^{
        self.contentLayer.contents = (__bridge id _Nullable)(currentImage.CGImage);
    });
}

- (CGSize)p_boundingRectWithText:(NSString *)text size:(CGSize)size font:(CGFloat)font{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize retSize = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return retSize;
}

#pragma mark - setter getter
- (CALayer *)contentLayer{
    if (_contentLayer == nil) {
        CALayer * contentLayer = [CALayer layer];
        contentLayer.backgroundColor = [UIColor clearColor].CGColor;
        contentLayer.frame = self.bounds;
        _contentLayer = contentLayer;
    }
    return _contentLayer;
}

- (CALayer *)verticalShowLayer{
    if (_verticalShowLayer == nil) {
        CALayer * showLayer = [CALayer layer];
        UIColor * normalColor = [UIColor lightGrayColor];
        if (self.assistLayerColor) {
            normalColor = self.assistLayerColor;
        }
        showLayer.backgroundColor = normalColor.CGColor;
        _verticalShowLayer = showLayer;
    }
    return _verticalShowLayer;
}

- (CALayer *)HorizontalShowLayer{
    if (_HorizontalShowLayer == nil) {
        CALayer * showLayer = [CALayer layer];
        UIColor * normalColor = [UIColor lightGrayColor];
        if (self.assistLayerColor) {
            normalColor = self.assistLayerColor;
        }
        showLayer.backgroundColor = normalColor.CGColor;
        _HorizontalShowLayer = showLayer;
    }
    return _HorizontalShowLayer;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"bounds"];
}


@end
