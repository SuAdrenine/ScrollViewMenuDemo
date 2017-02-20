//
//  XBYMainTableViewCell.m
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/20.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "XBYMainTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <Masonry.h>

@interface XBYMainTableViewCell()<XBYMainCellDelegate>
@property(nonatomic, strong) UILabel *titleLB;
@property(nonatomic, strong) UIImageView *iconIV;

@end

@implementation XBYMainTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = ColorFromRGB(ggbWhiteGray);
        
        [self.contentView addSubview:self.iconIV];
        [self.contentView addSubview:self.titleLB];
        
        [self updateFrame];
    }
    
    return self;
}

-(void)updateFrame {
    
    [self.iconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(60,60));
        //        make.centerY.mas_equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(self.iconIV.mas_right).offset(20);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

-(void)fillWithContent {
    //    [self.titleLB setNumberOfLines:0];
    self.titleLB.text = self.item.title;
    [self.titleLB sizeToFit];
    //    self.titleLB.text = @"kengbi";
    if (_item.picUrl) {
        //生成图片链接
        NSURL *picURL = [NSURL URLWithString:_item.picUrl];
        //从网络获取照片,如果没有就用系统自带占位照片
        [self.iconIV sd_setImageWithURL:picURL];
        //下面这个方法多了个参数 placeholderImage，意思是如果没有从网络请求到数据，用使用我们预先设置的这张照片。
        [self.iconIV sd_setImageWithURL:picURL placeholderImage:[UIImage imageNamed:@"占位图"]];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setItem:(XBYDataModel *)item {
    if (_item == item) {
        return;
    }
    _item = item;
    
    [self fillWithContent];
}

- (void)orderCell:(id)cellView
didClickBtnWithBtnTitle:(NSString *)title
           params:(NSDictionary *)params {
    if ([self.delegate respondsToSelector:@selector(orderCell:didClickBtnWithBtnTitle:params:)]) {
        [self.delegate orderCell:self didClickBtnWithBtnTitle:title params:nil];
    }
}

LabelGetter(titleLB,NSTextAlignmentLeft,ColorFromRGB(ggbBlack),[UIFont systemFontOfSize:18])
ImageViewGetter(iconIV, @"headView")


@end
