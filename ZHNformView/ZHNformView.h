//
//  ZHNformView.h
//  ZHNformView
//
//  Created by zhn on 16/10/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHNformView;
@protocol ZHNformViewDataSource <NSObject>
- (NSArray <NSString *> *)headTitleArrayForZHNformView:(ZHNformView *)formView;
- (NSInteger)numbOfSectionsInZHNformView:(ZHNformView *)forView;
- (NSString *)ZHNformView:(ZHNformView *)formView ContentOfCol:(NSInteger)col inRow:(NSInteger)row;
@optional

/**
 返回列宽度百分比的数组（不实现这个方法默认是按照 headTitleArrayForZHNformView 方法返回的数组里面的文字长度的百分比来显示）

 * 数组的里面的数字的和必须等于 1
 * 数组里面的个数必须和 headTitleArrayForZHNformView 方法返回的数组的个数相等
 */
- (NSArray *)itemHeightPercentArrayForZHNformView:(ZHNformView *)formView;
- (CGFloat)headTitleHeightForZHNformView:(ZHNformView *)formView;
- (UIColor *)ZHNformView:(ZHNformView *)formView stringColorOfCol:(NSInteger)col inRow:(NSInteger)row;
- (UIColor *)ZHNformView:(ZHNformView *)formView headStringColorOfCol:(NSInteger)Col;
@end

@protocol ZHNformViewDelegate <NSObject>
@optional
- (void)ZHNformView:(ZHNformView *)formView selectedRow:(NSInteger)row col:(NSInteger)col;
@end



@interface ZHNformView : UIView

@property (nonatomic,assign) CGFloat titleFont;
@property (nonatomic,assign) CGFloat contentFont;
@property (nonatomic,strong) UIColor * headTitleBackColor;
@property (nonatomic,strong) UIColor * assistLayerColor;

// 是否显示水平和垂直的辅助显示的view（不填默认是显示的）
@property (nonatomic,getter = isShowVerticalLayer) BOOL showVerticalLayer;
@property (nonatomic,getter = isShowHorizontalLayer) BOOL showHorizontalLayer;

@property (nonatomic,weak) id <ZHNformViewDataSource> dataSource;
@property (nonatomic,weak) id <ZHNformViewDelegate> delegate;

// 刷新数据
- (void)ZHN_reloadData;
// 移除辅助layer
- (void)ZHN_removeAssistLayer;
@end
