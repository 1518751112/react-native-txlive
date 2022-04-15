# react-native-txlive

react-native-txlive 腾讯移动直播SDK

## Installation

```sh
npm install @tg1518/react-native-txlive
```

## Usage

```js
import Txlive from "react-native-txlive";

// ...

const result = await Txlive.multiply(3, 7);
```

## ios示例

```tsx
import {TxlivePlayerView,multiply} from "@tg1518/react-native-txlive";
const [playUrl, setPlayUrl] = useState("https://vd2.bdstatic.com/mda-nahw7gsdxek1t73s/sc/mda-nahw7gsdxek1t73s.mp4?v_from_s=hkapp-haokan-nanjing&auth_key=1643377095-0-0-4f223c339c171cb0826fa288d201e493&bcevod_channel=searchbox_feed&pd=1&pt=3&logid=0495420516&vid=8198127163253506873&abtest=100534_1");
const val = useRef();

<TxlivePlayerView
  setAutoPlay={true}
  source={playUrl}
  style={{ width: 400, height: 200 }}
  ref={val}
  onPrepare={() => {
    console.log("播放准备");
    // val.play(true)
  }}

  onEnd={() => {
    console.log("播放结束");
  }}

  onSchedule={(data:any) => {
    console.log("播放进度",data);
  }}

  onNetStatus={(data:any) => {
    console.log("网络状态",data);
  }}

  onOther={(data:any) => {
    console.log("其他事件",data);
  }}

  onErr={(data:any) => {
    console.log("错误事件",data);
  }}
/>
// ...


```
##ios截图
<img src="https://os-c1.ccwtech.net/ck1/uploads/t2QSXC/{21CA47C4-0245-6A32-.jpg" width="200" alt="ios示例截图"/><br/>
<img src="https://os-c1.ccwtech.net/ck1/uploads/3C28Eg/image.png" width="600" alt="方法截图"/><br/>

## 更新说明
更新sdk版本报错
更新安卓sdk调用
添加ios直播观看

注：本次是在@kafudev 作者基础上更新

## License

MIT

