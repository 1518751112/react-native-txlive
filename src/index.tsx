import React, { Component } from 'react';
import {
  requireNativeComponent,
  NativeModules,
  Platform,
  findNodeHandle,
  UIManager,
  View,
  StyleProp, ViewStyle,
} from 'react-native';
import * as PropTypes from 'prop-types';
const { Txlive } = NativeModules;
const RCTTxlivePlayerView: any =
  Platform.OS === 'ios' ? requireNativeComponent('TxlivePlayerView') : requireNativeComponent('RCTTxlivePlayerView');
const RCTTxlivePusherView: any =
  Platform.OS === 'ios' ? View : requireNativeComponent('RCTTxlivePusherView');

export async function multiply(a: number, b: number) {
  return await Txlive.multiply(a, b);
}

enum IScaleMode {
  SCALEASPECTFIT = 0,
  SCALEASPECTFILL = 1,
  SCALETOFILL = 2,
}

interface TxPlayerProps {
  style?: StyleProp<ViewStyle>;
  source: string; // 播放地址
  setAutoPlay?: boolean; // 是否自动播放
  mute?: boolean; //是否静音
  setVolume?: number; //设置播放器音量,范围0~1.
  rate?: number; //播放速率，0.5-2.0之间，1为正常播放
  setReferer?: string; //设置请求referer
  setUserAgent?: string; // 设置UserAgent
  setMirrorMode?: number; // 0:无镜像;1:横向;2:竖向
  renderRotation?: number; // 设置旋转 0:0度;1:90度;2:180度;3:270度;
  renderNode?: IScaleMode; // 设置画面缩放模式 0:宽高比填充;1:宽高比适应;

  onPrepare?: (e: TxPlayerFuncParams<any>) => void, // 准备播放
  onSchedule?: (e: TxPlayerFuncParams<any>) => void, // 播放进度
  onNetStatus?: (e: TxPlayerFuncParams<any>) => void, // 网络状态
  onOther?: (e: TxPlayerFuncParams<{code:number,data:any}>) => void, // 其他事件
  onErr?: (e: TxPlayerFuncParams<{code:string,data:any}>) => void, // 错误事件
  onEnd?: (e: TxPlayerFuncParams<any>) => void, // 播放结束
}

interface TxPlayerFuncParams<T> {
  nativeEvent: T
}

export class TxlivePlayerView extends Component<TxPlayerProps> {
  static defaultProps = {
    style: {},
    url: '',
  };

  static propTypes = {
    style: PropTypes.object,
    url: PropTypes.string,
  };

  constructor(props: Object) {
    super(props);
    this.state = {
      stopPlay: false,
      destroyPlay: false,
    };

  }

  _assignRoot = (component) => {
    this._root = component;
  };

  _dispatchCommand = (command, params = []) => {
    if (this._root) {
      UIManager.dispatchViewManagerCommand(findNodeHandle(this._root), command, params);
    }
  };

  setNativeProps = (props) => {
    if (this._root) {
      this._root.setNativeProps(props);
    }
  };

  componentWillUnmount() {
    this.setState({
      stopPlay: true,
      destroyPlay: true,
    });
    this.stop();
  }

  // 播放
  play = (start:boolean) => {
    if(typeof start === 'boolean')
      this._dispatchCommand('play',[start]);
  };

  // 结束播放销毁组件
  stop = () => {
    this._dispatchCommand('stop');
  };

  // 结束播放销毁组件
  isPlaying = async() => {
    return this._dispatchCommand('isPlaying');
  };

  //FLV 直播无缝切换 url:必须是当前播放直播流的不同清晰度，切换到无关流地址可能会失败
  switchStream = async(url:string) => {
    if(typeof url =="string")
      return this._dispatchCommand('switchStream',[url]);
    else
      return false
  };

  //跳转到指定位置播放
  seek = async(postion:number) => {
    if(typeof postion =="number"){
      this._dispatchCommand('seek',[postion]);
    }
  };

  render() {
    return (
      <RCTTxlivePlayerView
        {...this.props}
        ref={this._assignRoot}
        stopPlay={this.state.stopPlay || false}
        destroyPlay={this.state.destroyPlay || false}
        // onChange={this._onChange.bind(this)}
      />
    );
  }
}

export class TxlivePusherView extends Component<any, any> {
  static defaultProps = {
    style: {},
    url: '',
  };

  static propTypes = {
    ...View,
    style: PropTypes.object,
    url: PropTypes.string,
  };

  constructor(props: Object) {
    super(props);
    this.state = {
      stopPush: false,
      destroyPush: false,
    };
  }

  componentWillUnmount() {
    this.setState({
      stopPush: true,
      destroyPush: false,
    });
  }

  render() {
    return (
      <RCTTxlivePusherView
        {...this.props}
        stopPush={this.state.stopPush || false}
        destroyPush={this.state.destroyPush || false}
        // onChange={this._onChange.bind(this)}
      />
    );
  }
}

