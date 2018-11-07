//
//  ZFLandScapeControlView.m
//  ZFPlayer
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ZFLandScapeControlView.h"
#import "UIView+ZFFrame.h"
#import "ZFUtilities.h"
#import <ZFPlayer/ZFPlayer.h>

@interface ZFLandScapeControlView () <ZFSliderViewDelegate>
/// 顶部工具栏
@property (nonatomic, strong) UIView *topToolView;
/// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 底部工具栏
@property (nonatomic, strong) UIView *bottomToolView;
/// 播放或暂停按钮
@property (nonatomic, strong) UIButton *playOrPauseBtn;
/// 退出全屏
@property (nonatomic, strong) UIButton *outFullSCreenBtn;
/// 播放的当前时间
@property (nonatomic, strong) UILabel *currentTimeLabel;
/// 滑杆
@property (nonatomic, strong) ZFSliderView *slider;
/// 视频总时间
@property (nonatomic, strong) UILabel *totalTimeLabel;
/// 锁定屏幕按钮
@property (nonatomic, strong) UIButton *lockBtn;
/// 头像
@property (nonatomic, strong) UIImageView *headImageView;
/// 用户昵称
@property (nonatomic, strong) UILabel *userNameLable;
/// 关注
@property (nonatomic, strong) UIButton *attentiongBtn;

@property (nonatomic, assign) BOOL isShow;

@end

@implementation ZFLandScapeControlView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.topToolView];
        [self.topToolView addSubview:self.backBtn];
        
        [self addSubview:self.playOrPauseBtn];
        
        [self addSubview:self.bottomToolView];
        [self.bottomToolView addSubview:self.outFullSCreenBtn];
        [self.bottomToolView addSubview:self.currentTimeLabel];
        [self.bottomToolView addSubview:self.slider];
        [self.bottomToolView addSubview:self.totalTimeLabel];
        [self.bottomToolView addSubview:self.titleLabel];
        [self.bottomToolView addSubview:self.headImageView];
        [self.bottomToolView addSubview:self.userNameLable];
        [self.bottomToolView addSubview:self.attentiongBtn];
        
//        [self addSubview:self.lockBtn];
        
        // 设置子控件的响应事件
        [self makeSubViewsAction];
        [self resetControlView];
        
        /// statusBarFrame changed
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(layOutControllerViews) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat min_x = 0;
    CGFloat min_y = 0;
    CGFloat min_w = 0;
    CGFloat min_h = 0;
    CGFloat min_view_w = self.bounds.size.width;
    CGFloat min_view_h = self.bounds.size.height;
    
    CGFloat max_bottomView_h = 70; //(底部工具条70 加上文案 头像等 总高度140)
    
    CGFloat min_margin = 9; 
    
    min_x = 0;
    min_y = 0;
    min_w = min_view_w;
    min_h = iPhoneX ? 110 : 80;
    self.topToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 44: 15;
    min_y = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 15: (iPhoneX ? 40 : 20);
    min_w = 40;
    min_h = 40;
    self.backBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_h = 140;
    min_h = iPhoneX ? 170 : 140;
    min_x = 0;
    min_y = min_view_h - min_h;
    min_w = min_view_w;
    self.bottomToolView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    //暂停开始按钮 中间
    min_x = 0;
    min_y = 0;
    min_w = 32;
    min_h = 32;
    self.playOrPauseBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.playOrPauseBtn.center = self.center;
    
    //详细内容
    min_h = 30;
    min_w = min_view_w - min_x * 2 ;
    min_x = 16;
    min_y = self.bottomToolView.height - 60 - min_h;
    self.titleLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    //退出全屏按钮
    min_w = 30;
    min_h = min_w;
    min_x = self.bottomToolView.width - min_w - min_margin;
    min_y = (max_bottomView_h - min_h)/2 + max_bottomView_h;
    self.outFullSCreenBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    min_w = 45;
    min_h = 28;
    min_x = self.outFullSCreenBtn.left - min_w - 4;
    min_y = 0;
    self.totalTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.totalTimeLabel.centerY = self.outFullSCreenBtn.centerY;

    min_w = 40;
    min_h = 28;
    min_x = self.totalTimeLabel.left - min_w;
    min_y = (self.bottomToolView.height - min_h)/2;
    self.currentTimeLabel.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.currentTimeLabel.centerY = self.outFullSCreenBtn.centerY;

    min_x = 10;
    min_y = 0;
    min_w = self.bottomToolView.width - 15 - 40 - 45 - 28 - 15;//(相继减去全屏按钮 总时长 播放时长 间距)
    min_h = 30;
    self.slider.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.slider.centerY = self.outFullSCreenBtn.centerY;
    
    //添加头部 昵称 关注
    min_x = 10;
    min_y = 10;
    min_w = 32;
    min_h = 32;
    self.headImageView.frame = CGRectMake(min_x, min_y, min_w, min_h);
    
    //昵称
    min_x = 10 + self.headImageView.right;
    min_y = 10;
    min_w = [self textSizeWithFont:[UIFont systemFontOfSize:16] limitWidth:min_view_w - 20 - 32 - 60 - 20 withString:self.userNameLable.text].width;
    min_h = 32;
    self.userNameLable.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.userNameLable.centerY = self.headImageView.centerY;
    
    //关注
    min_x = 10 + self.userNameLable.right;
    min_y = 10;
    min_w = 60;
    min_h = 32;
    self.attentiongBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);

    min_x = (iPhoneX && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) ? 50: 18;
    min_y = 0;
    min_w = 40;
    min_h = 40;
    self.lockBtn.frame = CGRectMake(min_x, min_y, min_w, min_h);
    self.lockBtn.centerY = self.centerY;
    
    if (!self.isShow) {
        self.topToolView.y = -self.topToolView.height;
        self.bottomToolView.y = self.height;
    } else {
        if (self.player.isLockedScreen) {
            self.topToolView.y = -self.topToolView.height;
            self.bottomToolView.y = self.height;
        } else {
            self.topToolView.y = 0;
            self.bottomToolView.y = self.height - self.bottomToolView.height;
        }
    }
}

/// 计算字符串长度（一行时候）
- (CGSize)textSizeWithFont:(UIFont*)font limitWidth:(CGFloat)maxWidth withString:(NSString *)text {
    CGSize size = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 36)options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)  attributes:@{ NSFontAttributeName : font} context:nil].size;
    size.width = size.width > maxWidth ? maxWidth : size.width;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

- (void)makeSubViewsAction {
    [self.backBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playOrPauseBtn addTarget:self action:@selector(playPauseButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.lockBtn addTarget:self action:@selector(lockButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.outFullSCreenBtn addTarget:self action:@selector(backBtnClickAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)layOutControllerViews {
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

#pragma mark - ZFSliderViewDelegate

- (void)sliderTouchBegan:(float)value {
    self.slider.isdragging = YES;
}

- (void)sliderTouchEnded:(float)value {
    if (self.player.totalTime > 0) {
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
    }
    if (self.sliderValueChanged) self.sliderValueChanged(value);
}

- (void)sliderValueChanged:(float)value {
    if (self.player.totalTime == 0) {
        self.slider.value = 0;
        return;
    }
    self.slider.isdragging = YES;
    NSString *currentTimeString = [ZFUtilities convertTimeSecond:self.player.totalTime*value];
    self.currentTimeLabel.text = currentTimeString;
    if (self.sliderValueChanging) self.sliderValueChanging(value,self.slider.isForward);
}

- (void)sliderTapped:(float)value {
    if (self.player.totalTime > 0) {
        self.slider.isdragging = YES;
        @weakify(self)
        [self.player seekToTime:self.player.totalTime*value completionHandler:^(BOOL finished) {
            @strongify(self)
            if (finished) {
                self.slider.isdragging = NO;
                [self.player.currentPlayerManager play];
            }
        }];
    } else {
        self.slider.isdragging = NO;
        self.slider.value = 0;
    }
}

#pragma mark -

/// 重置ControlView
- (void)resetControlView {
    self.slider.value                = 0;
    self.slider.bufferValue          = 0;
    self.currentTimeLabel.text       = @"00:00";
    self.totalTimeLabel.text         = @"00:00";
    self.backgroundColor             = [UIColor clearColor];
    self.playOrPauseBtn.selected     = YES;
    self.titleLabel.text             = @"";
    self.topToolView.alpha           = 1;
    self.bottomToolView.alpha        = 1;
    self.isShow                      = NO;
}

- (void)showControlView {
    self.lockBtn.alpha               = 1;
    self.isShow                      = YES;
    if (self.player.isLockedScreen) {
        self.topToolView.y           = -self.topToolView.height;
        self.bottomToolView.y        = self.height;
    } else {
        self.topToolView.y           = 0;
        self.bottomToolView.y        = self.height - self.bottomToolView.height;
    }
    self.lockBtn.left                = iPhoneX ? 50: 18;
    self.player.statusBarHidden      = NO;
    if (self.player.isLockedScreen) {
        self.topToolView.alpha       = 0;
        self.bottomToolView.alpha    = 0;
    } else {
        self.topToolView.alpha       = 1;
        self.bottomToolView.alpha    = 1;
        self.playOrPauseBtn.alpha    = 1;
    }
}

- (void)hideControlView {
    self.isShow                      = NO;
    self.topToolView.y               = -self.topToolView.height;
    self.bottomToolView.y            = self.height;
    self.lockBtn.left                = iPhoneX ? -82: -47;
    self.player.statusBarHidden      = YES;
    self.topToolView.alpha           = 0;
    self.bottomToolView.alpha        = 0;
    self.lockBtn.alpha               = 0;
    self.playOrPauseBtn.alpha        = 0;
    
}

- (BOOL)shouldResponseGestureWithPoint:(CGPoint)point withGestureType:(ZFPlayerGestureType)type touch:(nonnull UITouch *)touch {
    CGRect sliderRect = [self.bottomToolView convertRect:self.slider.frame toView:self];
    if (CGRectContainsPoint(sliderRect, point)) {
        return NO;
    }
    if (self.player.isLockedScreen && type != ZFPlayerGestureTypeSingleTap) { // 锁定屏幕方向后只相应tap手势
        return NO;
    }
    return YES;
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime {
    if (!self.slider.isdragging) {
        NSString *currentTimeString = [ZFUtilities convertTimeSecond:currentTime];
        self.currentTimeLabel.text = currentTimeString;
        NSString *totalTimeString = [ZFUtilities convertTimeSecond:totalTime];
        self.totalTimeLabel.text = [NSString stringWithFormat:@"/%@",totalTimeString];
        self.slider.value = videoPlayer.progress;
    }
}

- (void)videoPlayer:(ZFPlayerController *)videoPlayer bufferTime:(NSTimeInterval)bufferTime {
    self.slider.bufferValue = videoPlayer.bufferProgress;
}

- (void)showTitle:(NSString *)title fullScreenMode:(ZFFullScreenMode)fullScreenMode {
    self.titleLabel.text = title;
    self.player.orientationObserver.fullScreenMode = fullScreenMode;
    self.lockBtn.hidden = fullScreenMode == ZFFullScreenModePortrait;
}

/// 调节播放进度slider和当前时间更新
- (void)sliderValueChanged:(CGFloat)value currentTimeString:(NSString *)timeString {
    self.slider.value = value;
    self.currentTimeLabel.text = timeString;
    self.slider.isdragging = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }];
}

/// 滑杆结束滑动
- (void)sliderChangeEnded {
    self.slider.isdragging = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.slider.sliderBtn.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - action

- (void)backBtnClickAction:(UIButton *)sender {
    self.lockBtn.selected = NO;
    self.player.lockedScreen = NO;
    self.lockBtn.selected = NO;
    if (self.player.orientationObserver.supportInterfaceOrientation & ZFInterfaceOrientationMaskPortrait) {
        [self.player enterFullScreen:NO animated:YES];
    }
    if (self.backBtnClickCallback) {
        self.backBtnClickCallback();
    }
}

- (void)playPauseButtonClickAction:(UIButton *)sender {
    [self playOrPause];
}

/// 根据当前播放状态取反
- (void)playOrPause {
    self.playOrPauseBtn.selected = !self.playOrPauseBtn.isSelected;
    self.playOrPauseBtn.isSelected? [self.player.currentPlayerManager play]: [self.player.currentPlayerManager pause];
}

- (void)playBtnSelectedState:(BOOL)selected {
    self.playOrPauseBtn.selected = selected;
}

- (void)lockButtonClickAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.player.lockedScreen = sender.selected;
}

#pragma mark - getter

- (UIView *)topToolView {
    if (!_topToolView) {
        _topToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_top_shadow");
        _topToolView.layer.contents = (id)image.CGImage;
    }
    return _topToolView;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:ZFPlayer_Image(@"ZFPlayer_back_full") forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (UIView *)bottomToolView {
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] init];
        UIImage *image = ZFPlayer_Image(@"ZFPlayer_bottom_shadow");
        _bottomToolView.layer.contents = (id)image.CGImage;
    }
    return _bottomToolView;
}

- (UIButton *)playOrPauseBtn {
    if (!_playOrPauseBtn) {
        _playOrPauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_play") forState:UIControlStateNormal];
        [_playOrPauseBtn setImage:ZFPlayer_Image(@"ZFPlayer_pause") forState:UIControlStateSelected];
    }
    return _playOrPauseBtn;
}

- (UIButton *)outFullSCreenBtn {
    if (!_outFullSCreenBtn) {
        _outFullSCreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_outFullSCreenBtn setImage:ZFPlayer_Image(@"ZFPlayer_play") forState:UIControlStateNormal];
    }
    return _outFullSCreenBtn;
}

- (UILabel *)currentTimeLabel {
    if (!_currentTimeLabel) {
        _currentTimeLabel = [[UILabel alloc] init];
        _currentTimeLabel.textColor = [UIColor whiteColor];
        _currentTimeLabel.font = [UIFont systemFontOfSize:13.0f];
        _currentTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _currentTimeLabel;
}

- (ZFSliderView *)slider {
    if (!_slider) {
        _slider = [[ZFSliderView alloc] init];
        _slider.delegate = self;
        _slider.maximumTrackTintColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.8];
        _slider.bufferTrackTintColor  = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.5];
        _slider.minimumTrackTintColor = [UIColor whiteColor];
        [_slider setThumbImage:ZFPlayer_Image(@"ZFPlayer_slider") forState:UIControlStateNormal];
        _slider.sliderHeight = 2;
    }
    return _slider;
}

- (UILabel *)totalTimeLabel {
    if (!_totalTimeLabel) {
        _totalTimeLabel = [[UILabel alloc] init];
        _totalTimeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        _totalTimeLabel.font = [UIFont systemFontOfSize:13.0f];
        _totalTimeLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _totalTimeLabel;
}

- (UIButton *)lockBtn {
    if (!_lockBtn) {
        _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_unlock-nor") forState:UIControlStateNormal];
        [_lockBtn setImage:ZFPlayer_Image(@"ZFPlayer_lock-nor") forState:UIControlStateSelected];
    }
    return _lockBtn;
}

-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = _headImageView.height * 0.5;
        _headImageView.layer.masksToBounds = YES;
        _headImageView.image = ZFPlayer_Image(@"ZFPlayer_unlock-nor");
    }
    return _headImageView;
}

- (UILabel *)userNameLable {
    if (!_userNameLable) {
        _userNameLable = [[UILabel alloc] init];
        _userNameLable.textColor = [UIColor whiteColor];
        _userNameLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        _userNameLable.text = @"虾仁虾仁虾仁";
        _userNameLable.textAlignment = NSTextAlignmentLeft;
    }
    return _userNameLable;
}

- (UIButton *)attentiongBtn {
    if (!_attentiongBtn) {
        _attentiongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_attentiongBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_attentiongBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_attentiongBtn setTitle:@"已关注" forState:UIControlStateNormal];
    }
    return _attentiongBtn;
}

@end
