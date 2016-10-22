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
- (NSArray *)itemHeightPercentArrayForZHNformView:(ZHNformView *)formView;
- (CGFloat)headTitleHeightForZHNformView:(ZHNformView *)formView;
- (UIColor *)ZHNformView:(ZHNformView *)formView stringColorOfCol:(NSInteger)col inRow:(NSInteger)row;
- (UIColor *)ZHNformView:(ZHNformView *)formView headStringColorOfCol:(NSInteger)Col;
@end



@interface ZHNformView : UIView

@property (nonatomic,assign) CGFloat titleFont;

@property (nonatomic,assign) CGFloat contentFont;

@property (nonatomic,strong) UIColor * headTitleBackColor;

@property (nonatomic,strong) UIColor * assistLayerColor;

@property (nonatomic,getter = isShowVerticalLayer) BOOL showVerticalLayer;

@property (nonatomic,getter = isShowHorizontalLayer) BOOL showHorizontalLayer;

@property (nonatomic,weak) id <ZHNformViewDataSource> dataSource;

- (void)ZHN_reloadData;

- (void)ZHN_removeAssistLayer;

@end
