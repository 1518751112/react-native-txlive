#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import <React/RCTLog.h>
#import "TxlivePlayerManager.h"
#import "TxlivePlayerView.h"

@implementation TxlivePlayerManager

RCT_EXPORT_MODULE(TxlivePlayerView)

RCT_EXPORT_VIEW_PROPERTY(source, NSString); //播放地址
RCT_EXPORT_VIEW_PROPERTY(showVideoView, BOOL);
RCT_EXPORT_VIEW_PROPERTY(mute, BOOL);//是否静音
RCT_EXPORT_VIEW_PROPERTY(rate, float);//播放倍速
RCT_EXPORT_VIEW_PROPERTY(setAutoPlay, BOOL);//是否自动播放
RCT_EXPORT_VIEW_PROPERTY(renderNode, NSInteger);//渲染 0:将图像等比例铺满整个屏幕，多余部分裁剪掉 1:将图像等比例缩放，适配最长边，缩放后的宽和高都不会超过显示区域
RCT_EXPORT_VIEW_PROPERTY(startPlay, BOOL);

//0 HOME 键在右边，横屏模式
//1 HOME 键在下面，手机直播中最常见的竖屏直播模式
//2 HOME 键在左边，横屏模式
//3 HOME 键在上边，竖屏直播（适合小米 MIX2）
RCT_EXPORT_VIEW_PROPERTY(renderRotation, NSInteger);//画面角度
RCT_EXPORT_VIEW_PROPERTY(pausePlay, BOOL);
RCT_EXPORT_VIEW_PROPERTY(stopPlay, BOOL);
RCT_EXPORT_VIEW_PROPERTY(destroyPlay, BOOL);


//暴露事件监听
RCT_EXPORT_VIEW_PROPERTY(onPrepare, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onNetStatus, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSchedule, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onOther, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onEnd, RCTBubblingEventBlock)

//暴露方法（js调用，原生回调）
RCT_EXPORT_METHOD(play:(nonnull NSNumber *) reactTag state:(BOOL) state){
//    NSLog(@"bobobobob");
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        TxlivePlayerView * txPlayer  = (TxlivePlayerView *) viewRegistry[reactTag];
        
        [txPlayer play:state];
    }];
}
RCT_EXPORT_METHOD(stop:(nonnull NSNumber *) reactTag){
//    NSLog(@"bobobobob");
    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        TxlivePlayerView * txPlayer  = (TxlivePlayerView *) viewRegistry[reactTag];
        
        [txPlayer stop];
    }];
}
RCT_EXPORT_METHOD(isPlaying:(nonnull NSNumber *) reactTag
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        TxlivePlayerView * txPlayer  = (TxlivePlayerView *) viewRegistry[reactTag];
        
        resolve(@{@"state":[txPlayer isPlaying]?@YES:@NO});
        
    }];
}

RCT_EXPORT_METHOD(seek:(nonnull NSNumber *) reactTag
                  seek:(float)num){

    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        TxlivePlayerView * txPlayer  = (TxlivePlayerView *) viewRegistry[reactTag];
        
        [txPlayer seek:num];
        
    }];
}

//FLV 直播无缝切换 url:必须是当前播放直播流的不同清晰度，切换到无关流地址可能会失败
RCT_EXPORT_METHOD(switchStream:(nonnull NSNumber *) reactTag
                  url:(NSString *)url
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject){

    [self.bridge.uiManager addUIBlock:^(RCTUIManager *uiManager, NSDictionary<NSNumber *,UIView *> *viewRegistry) {
        TxlivePlayerView * txPlayer  = (TxlivePlayerView *) viewRegistry[reactTag];
        
        resolve(@{@"state":[txPlayer switchStream:url]>0?@YES:@NO});
        
    }];
}

- (UIView *)view
{

  return [TxlivePlayerView new];
}

- (dispatch_queue_t)methodQueue
{
    return self.bridge.uiManager.methodQueue;
}

@end
