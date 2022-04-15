#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
@import TXLiteAVSDK_Professional;

@interface TxlivePlayerView : UIView<TXLivePlayListener>

@property (assign, nonatomic) NSString *source;
@property (assign, nonatomic) BOOL showVideoView;
@property (assign, nonatomic) BOOL startPlay;
@property (assign, nonatomic) BOOL pausePlay;
@property (assign, nonatomic) BOOL stopPlay;
@property (assign, nonatomic) BOOL destroyPlay;

- (void)play:(BOOL)state;
- (void)stop;
- (void)seek:(float)num;
- (BOOL)isPlaying;
- (int)switchStream:(NSString *)url;

@property (nonatomic, copy) RCTBubblingEventBlock onPrepare;
@property (nonatomic, copy) RCTBubblingEventBlock onNetStatus;
@property (nonatomic, copy) RCTBubblingEventBlock onSchedule;
@property (nonatomic, copy) RCTBubblingEventBlock onOther;
@property (nonatomic, copy) RCTBubblingEventBlock onEnd;

@end
