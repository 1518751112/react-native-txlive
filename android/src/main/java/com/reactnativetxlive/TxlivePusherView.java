package com.reactnativetxlive;

import android.content.Context;
import android.graphics.Color;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.uimanager.events.RCTEventEmitter;
import com.reactnativetxlive.R;

import com.tencent.liteav.demo.livepusher.camerapush.ui.CameraPushMainView;


class TxlivePusherView extends FrameLayout {
  public CameraPushMainView mCameraPushMainView;

  public TxlivePusherView(Context context) {
    super(context);
    init(context);
  }

  public TxlivePusherView(Context context, AttributeSet attrs) {
    super(context, attrs);
    init(context);
  }

  public TxlivePusherView(Context context, AttributeSet attrs, int defStyleAttr) {
    super(context, attrs, defStyleAttr);
    init(context);
  }

  private void init(Context context) {
    mCameraPushMainView = new CameraPushMainView(context);
    addView(mCameraPushMainView);
  }

  public CameraPushMainView getCameraPushMainView() {
    return mCameraPushMainView;
  }

  public void onReceiveNativeEvent(String message, Integer state) {
    WritableMap event = Arguments.createMap();
    WritableMap ee = Arguments.createMap();
    ee.putString("message", message);
    ee.putInt("state", state);
    event.putMap("message", ee);
    ReactContext reactContext = (ReactContext) getContext();
    reactContext.getJSModule(RCTEventEmitter.class).receiveEvent(
      getId(),
      "topChange",
      event);
  }
}