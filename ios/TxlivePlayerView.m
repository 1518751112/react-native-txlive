#import "TxlivePlayerView.h"
#import <UIKit/UIKit.h>

@implementation TxlivePlayerView

TXLivePlayer *_txLivePlayer;
bool isAuthPlay=NO;
bool isOne=YES;
- (instancetype)init {
  if (self == [super init]) {
    _txLivePlayer = [[TXLivePlayer alloc] init];
    //用 setupVideoWidget 给播放器绑定决定渲染区域的view，其首个参数 frame 在 1.5.2 版本后已经被废弃
    [_txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self insertIndex:0];

      
      TXLivePlayConfig*  _config = [[TXLivePlayConfig alloc] init];
      // 自动模式
      _config.bAutoAdjustCacheTime   = YES;
      _config.minAutoAdjustCacheTime = 1;
      _config.maxAutoAdjustCacheTime = 5;
      
      [_txLivePlayer setConfig:_config];
      _txLivePlayer.delegate = self;
  }
  return self;
}

- (void)setSource:(NSString *)url {
//  NSLog(@"setUrl地址 = %@", url);
    if([_source isEqual:url]!=YES){
//        [_txLivePlayer pause];
        isOne=YES;
    }
    _source = url;
    
    if(isAuthPlay){
        [self play:YES];
    }
}

- (void)setRate:(float)num {
    [_txLivePlayer setRate:num];
}

- (void)setMute:(BOOL)is {
    [_txLivePlayer setMute:is];
}

- (void)setRenderNode:(NSInteger)num {
    [_txLivePlayer setRenderMode:num];
}

- (void)setRenderRotation:(TX_Enum_Type_HomeOrientation)num {
    [_txLivePlayer setRenderRotation:num];
}

//设置是否自动播放
- (void)setSetAutoPlay:(BOOL)value {
    isAuthPlay = value;
    _txLivePlayer.isAutoPlay=value;
    if(value){
        [self play:true];
    }
    
}

// 停止播放
- (void)stop {
  [_txLivePlayer stopPlay];
  [_txLivePlayer removeVideoWidget]; // 记得销毁view控件
}

//获取播放状态
- (BOOL)isPlaying {
    return [_txLivePlayer isPlaying];
}

//切换直播分辨率地址
- (int)switchStream:(NSString *)url {
    return [_txLivePlayer switchStream:url];
}
//切换直播分辨率地址
- (void)seek:(float)num {
    [_txLivePlayer seek:num];
}

//播放 或暂停播放
- (void)play:(BOOL)state {
    if(_source==nil){
        return;
    }
    if(state){
        //第一次播放
        if(isOne){
//            if([_txLivePlayer isPlaying]){
//                return;
//            }
            NSInteger index;
            NSString* flvUrl = _source;
            // 播放类型识别
            if([flvUrl rangeOfString:@".mp4" options:NSBackwardsSearch].length>0){
                index = 4;
            }else if([flvUrl rangeOfString:@".flv" options:NSBackwardsSearch].length>0){

                index = 2; //直播flv使用2 1无效
            }else if([flvUrl rangeOfString:@".m3u8" options:NSBackwardsSearch].length>0){
                index = 3;
            }else if([flvUrl rangeOfString:@"rtmp://" options:NSBackwardsSearch].length>0){
                index = 0;
            }else{
                return;
            }
            isOne = NO;
            [_txLivePlayer startPlay:flvUrl type:index];
        }else{
            //继续播放
            [_txLivePlayer resume];
        }
        
    }else{
        [_txLivePlayer pause];
    }

}

/**
 * 直播事件通知
 * @param EvtID 参见 TXLiveSDKEventDef.h
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param{
//    NSLog(@"事件%i",EvtID);
    switch (EvtID) {
        case EVT_VIDEO_PLAY_BEGIN:
            if(self.onPrepare){
                self.onPrepare(param);
            }
            break;
        case EVT_VIDEO_PLAY_PROGRESS:
            if(self.onSchedule){
                self.onSchedule(param);
            }
            break;
        case EVT_VIDEO_PLAY_END:
            if(self.onEnd){
                self.onEnd(param);
            }
            break;
        default:
            if(self.onOther){
                self.onOther(@{@"code":[NSNumber numberWithInt:EvtID],@"data":param});
            }
            break;
    }
}

/**
 * 网络状态通知
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onNetStatus:(NSDictionary *)param{
    
    if(self.onNetStatus){
        self.onNetStatus(param);
    }
}

@end
