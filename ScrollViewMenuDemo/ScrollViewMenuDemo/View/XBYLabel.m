//
//  XBYLabel.m
//  ScrollViewMenuDemo
//
//  Created by xby on 2017/2/15.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "XBYLabel.h"

@implementation XBYLabel{
    int regularColorHex, selectedColorHex;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:CalcFont(16)];
        
        regularColorHex = 0x333333;
        selectedColorHex = 0x3285ff;
        
        self.scale = 0;
    }
    return self;
}

//0.8时colorHex为0x666666  1时colorHex为0x3285ff
- (void)setScale:(CGFloat)scale {
    if (scale < 0) {
        return;
    }
    _scale = scale;
    
    CGFloat minScale = 0.8;
    CGFloat realScale = minScale + (1 - minScale) * _scale;
    
    int rhhex = (regularColorHex>>16),rmhex = (regularColorHex>>8)&0xff, rlhex = regularColorHex&0xff;
    int shhex = (selectedColorHex>>16),smhex = (selectedColorHex>>8)&0xff, slhex = selectedColorHex&0xff;
    
    int hHex = (rhhex - shhex) * (1 - realScale) / 0.2;
    int mHex = (rmhex - smhex) * (1 - realScale) / 0.2;
    NSInteger lHex = (rlhex - slhex) * (1 - realScale) / 0.2;
    
    NSInteger colorHex = (shhex + hHex)*(1<<16) + (smhex + mHex)*(1<<8) + (slhex + lHex);
    self.textColor = ColorFromRGB(colorHex);
    
    //    if (scale > 0.9) {
    //        self.textColor = kStatusBarColor;
    //    } else {
    //        self.textColor = kGrayFontColor;
    //    }
    
    self.transform = CGAffineTransformMakeScale(realScale, realScale);
}

@end
