# Project Context

## Purpose
娑旂増琛ラ崨妤嬬礄Oil Business App閿涘妲告稉鈧▎楣冩桨閸氭垵濮炲▽鍦彲閻ㄥ嫭琛ュ鏃堝櫚鐠愵厾顓搁悶鍡櫺╅崝銊ョ安閻㈩煉绱濇稉鏄忣洣閸旂喕鍏橀弰顖氬簻閸斺晛濮炲▽鍦彲閸氭垶琛ユ惔鎾诲櫚鐠愵厾鐓跺▽骞库偓鍌炪€嶉惄顔芥暜閹?Android 閸?iOS 閸欏苯閽╅崣鑸偓?
## Tech Stack
- **濡楀棙鐏?*: Flutter 3.4+ (鐠恒劌閽╅崣鎵╅崝銊ョ安閻劌绱戦崣?
- **鐠囶叀鈻?*: Dart 3.4+
- **閻樿埖鈧胶顓搁悶?*: BLOC Pattern (bloc ^9.0.0 + flutter_bloc ^9.1.1 + hydrated_bloc ^10.1.1)
- **缂冩垹绮剁拠閿嬬湴**: Dio ^5.2.1 + Retrofit (娴狅絿鐖滈悽鐔稿灇)
- **鐠侯垳鏁辩粻锛勬倞**: Go Router ^16.0.0
- **閸ヤ粙妾崠?*: Easy Localization (閺€顖涘瘮娑擃厽鏋冮崪宀冨閺?
- **娴狅絿鐖滈悽鐔稿灇**: Freezed ^3.2.3 + JSON Serializable ^6.9.0 + Build Runner ^2.5.4
- **閺堫剙婀寸€涙ê鍋?*: Hive ^2.2.3 + Shared Preferences ^2.5.3
- **娓氭繆绂嗗▔銊ュ弳**: Get It ^8.2.0
- **UI缂佸嫪娆㈡惔?*: TDesign Flutter ^0.1.5
- **閸栧懐顓搁悶鍡楁珤**: pnpm (闁俺绻?rps 瀹搞儱鍙?^0.8.0)

## Project Conventions

### Code Style
- **娴狅絿鐖滈弽鐓庣础**: 闁潧鎯?Flutter/Dart 鐎规ɑ鏌熸禒锝囩垳妞嬪孩鐗搁幐鍥у础
- **鐞涘矂鏆辨惔锕傛閸?*: 120娑擃亜鐡х粭锔肩礄瀹告彃婀?analysis_options.yaml 娑擃參鍘ょ純顕嗙礆
- **缂傗晞绻?*: 2娑擃亞鈹栭弽?- **鐎涙顑佹稉?*: 娴ｈ法鏁ら崡鏇炵穿閸欏嚖绱?string'閿?- **閸涜棄鎮曠憴鍕灟**:
  - 缁鎮? PascalCase (婢堆団敇瀹?
  - 閺傝纭?閸欐﹢鍣?閸欏倹鏆? camelCase (鐏忓繘鈹樺畡?
  - 鐢悂鍣? UPPER_SNAKE_CASE (婢堆冨晸娑撳鍨濈痪?
  - 閺傚洣娆㈤崥?鎼存挸鎮? lowercase_with_underscores (鐏忓繐鍟撴稉瀣灊缁?
- **閺嬪嫰鈧姴鍤遍弫?*: 娴兼ê鍘涙担璺ㄦ暏 const 閺嬪嫰鈧姴鍤遍弫?- **鐎涙顔屾竟鐗堟**: 娴兼ê鍘涙担璺ㄦ暏 final 鐎涙顔?
- **Widget**: 闁灝鍘ら崷?createState 閺傝纭舵稉顓犵椽閸愭瑩鈧槒绶敍瀹慼ildren 鐏炵偞鈧勬杹閸︺劍娓堕崥?- **濞夈劑鍣寸憴鍕瘱**: 娴ｈ法鏁?/// 鏉╂稖顢戦弬鍥ㄣ€傚▔銊╁櫞閿涘奔濞囬悽?// 鏉╂稖顢戠悰灞藉敶濞夈劑鍣?

### Architecture Patterns

#### 妞ゅ湱娲扮紒鎾寸€?
**Feature-first 缂佸嫮绮愰弬鐟扮础**閿涘本瀵滈崝鐔诲厴濡€虫健閸掓帒鍨庨敍?
```
lib/
閳规壕鏀㈤埞鈧?pages/              # 妞ょ敻娼板Ο鈥虫健閿涘湗eature-first閿?閳?  閳规柡鏀㈤埞鈧?[feature]/
閳?      閳规壕鏀㈤埞鈧?page.dart         # 鐠侯垳鏁遍崗銉ュ經閿涘牏鎴烽幍?BasePage閿?閳?      閳规壕鏀㈤埞鈧?controller.dart   # Cubit/Bloc 閹貉冨煑閸?閳?      閳规壕鏀㈤埞鈧?state.dart        # 閻樿埖鈧胶琚敍鍫濆瘶閸?copyWith閿?閳?      閳规壕鏀㈤埞鈧?view.dart         # 鐟欏棗娴樼紒鍕棅鐏?閳?      閳规壕鏀㈤埞鈧?model/            # 妞ょ敻娼伴悧鐟扮暰閺佺増宓佸Ο鈥崇€烽敍鍫濆讲闁绱?
閳?      閳规柡鏀㈤埞鈧?widgets/          # 妞ょ敻娼扮粔浣规箒缂佸嫪娆?
閳?          閳规柡鏀㈤埞鈧?[feature]_screen.dart  # 鐎圭偤妾?UI 鐎圭偟骞?
閳规壕鏀㈤埞鈧?widgets/            # 闁氨鏁ら崣顖氼槻閻劎绮嶆禒?閳?  閳规壕鏀㈤埞鈧?base/          # 閸╄櫣顢呯紒鍕閿涘湑ommonButton閵嗕竼ommonText 缁涘绱?
閳?  閳规壕鏀㈤埞鈧?common/        # 娑撴艾濮熼柅姘辨暏缂佸嫪娆?
閳?  閳规柡鏀㈤埞鈧?popup/         # 瀵湱鐛ョ紒鍕
閳规壕鏀㈤埞鈧?global/            # 閸忋劌鐪仦?閳?  閳规壕鏀㈤埞鈧?app_controller.dart   # 閸忋劌鐪?HydratedCubit
閳?  閳规壕鏀㈤埞鈧?app_state.dart        # 閸忋劌鐪悩鑸碘偓?閳?  閳规壕鏀㈤埞鈧?service/              # 閸忋劌鐪?API 閺堝秴濮熼敍鍦trofit閿?閳?  閳规壕鏀㈤埞鈧?model/                # 閸忋劌鐪弫鐗堝祦濡€崇€?
閳?  閳规壕鏀㈤埞鈧?storage.dart          # 閺堫剙婀寸€涙ê鍋嶇粻锛勬倞
閳?  閳规柡鏀㈤埞鈧?events.dart           # 閸忋劌鐪禍瀣╂閹崵鍤?
閳规壕鏀㈤埞鈧?net/               # 缂冩垹绮剁仦?閳?  閳规壕鏀㈤埞鈧?net_manager.dart             # Dio 缁狅紕鎮婇崳?閳?  閳规壕鏀㈤埞鈧?base_interceptor.dart        # 閸╄櫣顢呴幏锔藉焻閸?閳?  閳规壕鏀㈤埞鈧?http_header_interceptor.dart # 鐠囬攱鐪版径瀛樺閹搭亜娅?
閳?  閳规壕鏀㈤埞鈧?http_resp_interceptor.dart   # 閸濆秴绨查幏锔藉焻閸?閳?  閳规壕鏀㈤埞鈧?http_log_interceptor.dart    # 閺冦儱绻旈幏锔藉焻閸?閳?  閳规柡鏀㈤埞鈧?response.dart                # 閸濆秴绨查崺铏硅
閳规壕鏀㈤埞鈧?router/            # 鐠侯垳鏁遍柊宥囩枂
閳?  閳规壕鏀㈤埞鈧?router.dart           # GoRouter 闁板秶鐤?
閳?  閳规壕鏀㈤埞鈧?routes.dart           # 鐠侯垳鏁遍弸姘閸滃本鐎鍝勬珤
閳?  閳规柡鏀㈤埞鈧?pageTransition/       # 妞ょ敻娼版潪顒€婧€閸斻劎鏁?
閳规壕鏀㈤埞鈧?config/            # 鎼存梻鏁ら柊宥囩枂
閳?  閳规壕鏀㈤埞鈧?config.dart           # 閸╄櫣顢呴柊宥囩枂閿涘牏骞嗘晶鍐︹偓浣筋啎婢跺洣淇婇幁顖ょ礆
閳?  閳规壕鏀㈤埞鈧?env.dart              # 閻滎垰顣ㄩ弸姘
閳?  閳规壕鏀㈤埞鈧?channel.dart          # 濞撶娀浜鹃柊宥囩枂
閳?  閳规柡鏀㈤埞鈧?address.dart          # 閸︽澘娼冮柊宥囩枂
閳规壕鏀㈤埞鈧?resources/         # 鐠у嫭绨粻锛勬倞
閳?  閳规壕鏀㈤埞鈧?colors.dart           # 妫版粏澹婃稉濠氼暯閿涘牊鏁幐浣峰瘨/閺嗘膩瀵骏绱?
閳?  閳规壕鏀㈤埞鈧?size.dart             # 鐏忓搫顕敮鎼佸櫤
閳?  閳规壕鏀㈤埞鈧?style.dart            # 閺嶅嘲绱＄€规矮绠?
閳?  閳规柡鏀㈤埞鈧?theme.dart            # 娑撳顣介柊宥囩枂
閳规壕鏀㈤埞鈧?static/            # 闂堟瑦鈧浇绁┃鎰穿閻㈩煉绱欓懛顏勫З閻㈢喐鍨氶敍?閳?  閳规壕鏀㈤埞鈧?img.dart              # 閸ュ墽澧栫挧鍕爱鐢悂鍣?
閳?  閳规壕鏀㈤埞鈧?icon.dart             # 閸ョ偓鐖ｇ挧鍕爱鐢悂鍣?
閳?  閳规柡鏀㈤埞鈧?svg.dart              # SVG 鐠у嫭绨敮鎼佸櫤
閳规壕鏀㈤埞鈧?utils/             # 瀹搞儱鍙跨猾?閳?  閳规壕鏀㈤埞鈧?sizer_utils.dart      # 閸濆秴绨插蹇撴槀鐎电浼愰崗鍑ょ礄AppSizes閿?閳?  閳规壕鏀㈤埞鈧?log.dart              # 閺冦儱绻斿銉ュ徔
閳?  閳规壕鏀㈤埞鈧?validators.dart       # 鐞涖劌宕熸宀冪槈閸?閳?  閳规柡鏀㈤埞鈧?...                   # 閸忔湹绮銉ュ徔
閳规柡鏀㈤埞鈧?models/            # 鐠恒劍膩閸ф鍙℃禍顐ゆ畱閺佺増宓佸Ο鈥崇€?
```

#### 妞ょ敻娼伴弸鑸电€Ο鈥崇础閿涘牆绻€妞よ寮楅弽濂镐紥鐎瑰牞绱?

**閺嶅洤鍣崶娑樼湴閺嬭埖鐎?*閿?1. **page.dart** - 鐠侯垳鏁遍柊宥囩枂閸忋儱褰?
   - 缂佈勫 `BasePage`
   - 濞ｅ嘲鍙?`BasicInitPage` 婢跺嫮鎮婇崚婵嗩潗閸?   - 娴ｈ法鏁?`BlocProvider` 濞夈劌鍙?Controller
   - 娴ｈ法鏁?`BlocBuilder` 閸濆秴绨查悩鑸碘偓浣稿綁閸?
2. **controller.dart** - 娑撴艾濮熼柅鏄忕帆閹貉冨煑閸?   - 缂佈勫 `Cubit<State>` 閹?`Bloc<Event, State>`
   - 妞ょ敻娼扮痪褏濮搁幀浣峰▏閻?Cubit閿涘牏鐣濋崡鏇礆
   - 閸忋劌鐪悩鑸碘偓浣峰▏閻?HydratedCubit閿涘牊瀵旀稊鍛閿?   - 閸栧懎鎯堢悰銊ュ礋 Key閵嗕椒绗熼崝鈩冩煙濞夋洏鈧胶濮搁幀浣规纯閺?
3. **state.dart** - 閻樿埖鈧礁鐣炬稊?   - 娑撳秴褰查崣妯煎Ц閹胶琚?
   - 韫囧懘銆忛崠鍛儓 `copyWith` 閺傝纭?
   - 娴ｈ法鏁ら崨钘夋倳閸欏倹鏆熼弸鍕偓鐘插毐閺?   - 閸欘垶鈧濞囬悽?Freezed 閻㈢喐鍨?

4. **view.dart** - 鐟欏棗娴樼紒鍕棅鐏?   - `StatefulWidget` 閹?`StatelessWidget`
   - 娴ｈ法鏁?`BlocListener` 婢跺嫮鎮婇崜顖欑稊閻㈩煉绱欑€佃壈鍩呴妴涔€oast閿?   - 鐠嬪啰鏁?widgets/ 娑撳娈戠€圭偤妾?UI 缂佸嫪娆?
   - 娣囨繃瀵旀潪濠氬櫤閿涘奔绗夐崠鍛儓婢跺秵娼呴柅鏄忕帆

5. **widgets/[feature]_screen.dart** - 鐎圭偤妾?UI 鐎圭偟骞?
   - 鐎圭偟骞囬崗铚傜秼閻ㄥ嫰銆夐棃銏犵鐏炩偓
   - 娴ｈ法鏁ら柅姘辨暏缂佸嫪娆㈤弸鍕紦 UI
   - 闁俺绻?`context.read<Ctrl>()` 鐠嬪啰鏁ゆ稉姘閺傝纭?

#### 閻樿埖鈧胶顓搁悶鍡欑摜閻?
**1. 妞ょ敻娼扮痪褏濮搁幀?- Cubit**
```dart
// 闁倻鏁ゆ禍搴ｇ暆閸楁洜娈戞い鐢告桨閻樿埖鈧胶顓搁悶?class LoginCtrl extends Cubit<LoginState> {
  LoginCtrl() : super(LoginState(loginLoading: false));
  
  submit() async {
    emit(state.copyWith(loginLoading: true));
    // 娑撴艾濮熼柅鏄忕帆
  }
}
```

**2. 閸忋劌鐪幐浣风畽閸栨牜濮搁幀?- HydratedCubit**
```dart
// 闁倻鏁ゆ禍搴ㄦ付鐟曚焦瀵旀稊鍛閻ㄥ嫬鍙忕仦鈧悩鑸碘偓渚婄礄婵″倻鏁ら幋铚備繆閹垽绱?
class AppController extends HydratedCubit<AppState> {
  AppController() : super(AppState());
  
  @override
  AppState? fromJson(Map<String, dynamic> json) {
    // 閸欏秴绨崚妤€瀵?
  }
  
  @override
  Map<String, dynamic>? toJson(AppState state) {
    // 鎼村繐鍨崠?  }
}
```

**3. 閸忋劌鐪禍瀣╂闁矮淇?- EventBus**
```dart
// 閻劋绨捄銊┿€夐棃?鐠恒劍膩閸ф鈧矮淇?
globalTabChangeEventBus.fire(index);
globalTabChangeEventBus.on<int>().listen((index) {
  // 婢跺嫮鎮婃禍瀣╂
});
```

#### 缂冩垹绮剁仦鍌涚仸閺?
**閹凤附鍩呴崳銊╂懠**閿?1. `HttpHeaderInterceptor` - 濞ｈ濮為柅姘辨暏鐠囬攱鐪版径杈剧礄Token閵嗕箒ser-Agent閿?2. `BaseInterceptor` - Token 閼奉亜濮╅崚閿嬫煀閵嗕線鏁婄拠顖炲櫢鐠?3. `HttpLogInterceptor` - 鐠囬攱鐪?閸濆秴绨查弮銉ョ箶鐠佹澘缍?
4. `HttpRespInterceptor` - 缂佺喍绔撮崫宥呯安婢跺嫮鎮婇妴渚€鏁婄拠顖氼槱閻?
**API 閺堝秴濮熺€规矮绠?*閿涘湩etrofit閿涘绱?
```dart
@RestApi()
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;
  
  @POST('/auth/login')
  Future<AuthResponse> login(@Body() LoginRequest request);
}
```

### UI Component Standards

#### 鐠佹崘顓搁崢鐔峰灟
- 閻滈鍞崠鏍ф櫌娑撴艾绨查悽銊ф櫕闂堛垼顔曠拋?- 閺€顖涘瘮濞村懓澹?濞ｈ精澹婃稉濠氼暯閸掑洦宕?
- 閸濆秴绨插蹇撶鐏炩偓閿涘本鏁幐浣瑰閺堟亽鈧礁閽╅弶瑁も偓浣瑰閸欑姴鐫?
- Material Design 3 鐠佹崘顓哥拠顓♀枅
- 妤傛ê鍞撮懕姘モ偓浣风秵閼帮箑鎮庨惃鍕矋娴犺泛瀵茬拋鎹愵吀

#### 闁氨鏁ょ紒鍕鎼存搫绱檂widgets/base/`閿?
##### **CommonText** - 缂佺喍绔撮弬鍥ㄦ拱缂佸嫪娆?

**鐏炵偞鈧嗩潐閼?*閿?| 鐏炵偞鈧?| 缁鐎?| 姒涙顓婚崐?| 鐠囧瓨妲?|
|-----|------|--------|------|
| text | String | 韫囧懎锝?| 閺傚洦婀伴崘鍛啇 |
| fontSize | double? | 14 | 鐎涙ぞ缍嬫径褍鐨敍鍫濈箑妞よ濞囬悽?setFontSize閿?|
| fontWeight | FontWeight | w400 | 鐎涙鍣?|
| textColor | Color? | txtBlack | 閺傚洤鐡ф０婊嗗 |
| textAlign | TextAlign | center | 鐎靛綊缍堥弬鐟扮础 |
| fontFamily | String | Urbanist | 鐎涙ぞ缍嬬€硅埖妫?|
| maxLines | int? | null | 閺堚偓婢堆嗩攽閺?|
| overflow | TextOverflow? | null | 濠с垹鍤径鍕倞 |
| letterSpacing | double? | null | 鐎涙妫跨捄?|

**娴ｈ法鏁ょ憴鍕瘱**閿?```dart
CommonText(
  text: '閺傚洦婀伴崘鍛啇',
  fontSize: AppSizes.setFontSize(14),
  fontWeight: FontWeight.w600,
  textColor: CustomAppColor.of(context).txtBlack,
)
```

- 閴?韫囧懘銆忔担璺ㄦ暏 `AppSizes.setFontSize()` 鐠佸墽鐤嗙€涙褰?
- 閴?韫囧懘銆忔担璺ㄦ暏 `CustomAppColor.of(context)` 閼惧嘲褰囨０婊嗗
- 閴?閸ュ搫鐣剧悰宀勭彯 1.2
- 閴?姒涙顓荤€涙ぞ缍嬮敍姝巖banist

##### **CommonButton** - 缂佺喍绔撮幐澶愭尦缂佸嫪娆?

**鐏炵偞鈧嗩潐閼?*閿?| 鐏炵偞鈧?| 缁鐎?| 姒涙顓婚崐?| 鐠囧瓨妲?|
|-----|------|--------|------|
| btnText | String? | null | 閹稿鎸抽弬鍥х摟 |
| child | Widget? | null | 閼奉亜鐣炬稊澶婄摍缂佸嫪娆?|
| onTap | Function()? | null | 閻愮懓鍤崶鐐剁殶 |
| buttonColor | Color? | btnPurple | 閹稿鎸抽懗灞炬珯閼?|
| borderColor | Color? | transparent | 鏉堣顢嬫０婊嗗 |
| height | double? | 52 | 閹稿鎸虫妯哄 |
| width | double? | fullWidth | 閹稿鎸崇€硅棄瀹?|
| radius | double | 8 | 閸﹀棜顫楅崡濠傜窞 |
| fontSize | double? | 15 | 閺傚洤鐡ф径褍鐨?|
| isButtonShadow | bool? | true | 閺勵垰鎯侀弰鍓с仛闂冩潙濂?|
| isLoading | bool? | false | 閺勵垰鎯侀弰鍓с仛閸旂姾娴?|

**閹稿鎸崇猾璇茬€?*閿?
*娑撴槒顩﹂幐澶愭尦閿涘湧rimary閿?閿?```dart
CommonButton(
  btnText: '娑撴槒顩﹂幙宥勭稊',
  buttonColor: CustomAppColor.of(context).btnPurple,
  height: AppSizes.buttonHeight,  // 52
  radius: 8,
  isButtonShadow: true,
  isLoading: state.loading,
)
```
- 閼冲本娅欓懝璇х窗缁鳖偉澹?#7165E3
- 閺傚洤鐡ф０婊嗗閿涙氨娅ч懝?- 闂冩潙濂栭敍姘变紶閼?40% 闁繑妲?
- 妤傛ê瀹抽敍?2閿涘苯娓剧憴鎺炵窗8

*濞喡ゎ洣閹稿鎸抽敍鍦玡condary閿?閿?```dart
CommonButton(
  btnText: '濞喡ゎ洣閹垮秳缍?,
  buttonColor: CustomAppColor.of(context).btnWhite,
  borderColor: CustomAppColor.of(context).borderGrey,
  isButtonShadow: false,
)
```
- 閼冲本娅欓懝璇х窗閻у€熷/濞ｈ精澹婇懗灞炬珯
- 鏉堣顢嬮敍?px 閻忔媽澹?
- 閺冪娀妲捐ぐ?
*鐏忓繑瀵滈柦?閿?```dart
CommonButton(
  btnText: '鐏忓繑瀵滈柦?,
  height: AppSizes.setHeight(34),
  width: AppSizes.setWidth(93),
  radius: 3,
)
```
- 妤傛ê瀹抽敍?4閿涘苯娓剧憴鎺炵窗3

##### **CommonTextFormField** - 鐞涖劌宕熸潏鎾冲弳缂佸嫪娆?

**鐏炵偞鈧嗩潐閼?*閿?| 鐏炵偞鈧?| 缁鐎?| 姒涙顓婚崐?| 鐠囧瓨妲?|
|-----|------|--------|------|
| name | String? | null | 鐎涙顔岄崥宥忕礄FormBuilder閿?|
| hintText | String? | null | 閸楃姳缍呴弬鍥х摟 |
| labelText | String? | null | 閺嶅洨顒烽弬鍥х摟 |
| controller | TextEditingController? | null | 鏉堟挸鍙嗛幒褍鍩楅崳?|
| leadingIcon | Widget? | null | 閸撳秶鐤嗛崶鐐垼 |
| suffixIcon | Widget? | null | 閸氬海鐤嗛崶鐐垼 |
| borderColor | Color? | borderGrey | 鏉堣顢嬫０婊嗗 |
| radius | double? | 12 | 閸﹀棜顫楅崡濠傜窞 |
| isPasswordField | bool | false | 閺勵垰鎯佺€靛棛鐖滃?|
| isPhoneNumberField | bool | false | 閺勵垰鎯侀幍瀣簚閸欓鐖滃?|
| validators | Function? | null | 妤犲矁鐦夐崳?|

**鏉堟挸鍙嗗鍡欏Ц閹?*閿?- 姒涙顓婚悩鑸碘偓渚婄窗閻忔媽澹婃潏瑙勵攱 1px閿涘苯娓剧憴?12
- 閼辨氨鍔嶉悩鑸碘偓渚婄窗缁鳖偉澹婃潏瑙勵攱 2px閿涘本鐖ｇ粵鐐癁閸斻劍妯夌粈?- 鐎靛棛鐖滃鍡窗閼奉亜濮╅弰楣冩鐎靛棛鐖滈崶鐐垼
- 閹靛婧€閸欏嚖绱伴崶浠嬫閻絻鐦介崣椋庣垳鏉堟挸鍙嗛敍鍦沶tlPhoneField閿?
**娴ｈ法鏁ょ粈杞扮伐**閿?```dart
CommonTextFormField(
  name: 'phone',
  hintText: '閹靛婧€閸?,
  leadingIcon: Image.asset(AssetsIcon.IC_PROFILE),
  borderColor: CustomAppColor.of(context).textFieldBorder,
  validators: FormBuilderValidators.compose([
    FormBuilderValidators.required(errorText: '閹靛婧€閸欒渹绗夐懗鎴掕礋缁?),
  ]),
)
```

##### **TopBar** - 妞ゅ爼鍎寸€佃壈鍩呴弽蹇曠矋娴?
**鐏炵偞鈧嗩潐閼?*閿?| 鐏炵偞鈧?| 缁鐎?| 姒涙顓婚崐?| 鐠囧瓨妲?|
|-----|------|--------|------|
| clickListener | TopBarClickListener | 韫囧懎锝?| 閻愮懓鍤禍瀣╂閻╂垵鎯夐崳?|
| title | String? | null | 閺嶅洭顣介弬鍥х摟 |
| isShowBack | bool | false | 閺勵垰鎯侀弰鍓с仛鏉╂柨娲栭幐澶愭尦 |
| isShowProfile | bool | false | 閺勵垰鎯侀弰鍓с仛婢舵潙鍎?|
| isShowNotification | bool | false | 閺勵垰鎯侀弰鍓с仛闁氨鐓￠崶鐐垼 |
| isShowSearch | bool | false | 閺勵垰鎯侀弰鍓с仛閹兼粎鍌ㄩ崶鐐垼 |
| isShowCart | bool | false | 閺勵垰鎯侀弰鍓с仛鐠愵厾澧挎潪?|
| topBarColor | Color? | white | 閼冲本娅欐０婊嗗 |
| textColor | Color | txtBlack | 閺傚洤鐡ф０婊嗗 |
| height | double | 100 | 妤傛ê瀹?|

**鐢啫鐪憴鍕瘱**閿?- 閸ュ搫鐣炬妯哄閿?00閿涘牆瀵橀崥?SafeArea閿?- 濮樻潙閽╅崘鍛扮珶鐠烘繐绱?8
- 閸ョ偓鐖ｇ亸鍝勵嚟閿?4x24
- 閸忓啰绀屾い鍝勭碍閿涙俺绻戦崶?閳?婢舵潙鍎?閳?閺嶅洭顣?閳?Spacer 閳?閹垮秳缍旈崶鐐垼

##### **CommonContainer** - 鐎圭懓娅掔紒鍕

**鐏炵偞鈧嗩潐閼?*閿?| 鐏炵偞鈧?| 缁鐎?| 姒涙顓婚崐?| 鐠囧瓨妲?|
|-----|------|--------|------|
| width | double | 韫囧懎锝?| 鐎圭懓娅掔€硅棄瀹?|
| height | double | 韫囧懎锝?| 鐎圭懓娅掓妯哄 |
| child | Widget | 韫囧懎锝?| 鐎涙劗绮嶆禒?|
| borderColor | Color? | containerBorder | 鏉堣顢嬫０婊嗗 |
| borderWidth | double? | 1 | 鏉堣顢嬬€硅棄瀹?|
| borderRadius | double? | 15 | 閸﹀棜顫楅崡濠傜窞 |

##### **Heading** - 閺嶅洭顣界紒鍕

**娴ｈ法鏁ょ粈杞扮伐**閿?```dart
Heading(
  title: '娑撶粯鐖ｆ０?,
  navigationTitle: '閺屻儳婀呴弴鏉戭樋',
  onTap: () {},
)
```

**閺嶅嘲绱＄憴鍕瘱**閿?- 娑撶粯鐖ｆ０姗堢窗鐎涙褰?18閿涘苯鐡ч柌?800
- 鐎佃壈鍩呴弬鍥х摟閿涙艾鐡ч崣?14閿涘苯鐡ч柌?700閿涘瞼浼犻懝?- 濮樻潙閽╅崘鍛扮珶鐠烘繐绱?0

#### 妫版粏澹婄化鑽ょ埠

**閸濅胶澧濋懝?*閿?```dart
AppColor.btnPurple = #7165E3      // 娑撹鎼ч悧宀冨閿涘牊瀵滈柦顔衡偓浣稿繁鐠嬪啫鍘撶槐鐙呯礆
AppColor.txtPurple = #7165E3      // 閺傚洦婀板楦跨殶閼?AppColor.icPurple = #7165E3       // 閸ョ偓鐖ｅ楦跨殶閼?AppColor.borderPurple = #7165E3   // 瀵缚鐨熸潏瑙勵攱
```

**娑擃厽鈧嗗**閿?```dart
AppColor.white = #FFFFFF          // 缁绢垳娅?
AppColor.black = #000000          // 缁绢垶绮?
AppColor.txtBlack = #000000       // 姒涙垼澹婇弬鍥ㄦ拱
AppColor.txtGrey = #9EA6BE        // 閻忔媽澹婇弬鍥ㄦ拱
AppColor.hintGrey = #AFB0B6       // 閹绘劗銇氶弬鍥ㄦ拱閻忔媽澹?
AppColor.borderGrey = #9EA6BE     // 鏉堣顢嬮悘鎷屽
```

**閸旂喕鍏橀懝?*閿?```dart
AppColor.green = #2AB126          // 閹存劕濮涢悩鑸碘偓?AppColor.txtRed = #FF4141         // 闁挎瑨顕?閸楅亶娅?
AppColor.txtOrange = #FF9B00      // 濮楁瑨澹婇幓鎰仛
AppColor.txtBlue = #383EAF        // 閽冩繆澹婇柧鐐复
```

**閼冲本娅欓懝?*閿?```dart
// 濞村懓澹婃稉濠氼暯
AppColor.white = #FFFFFF          // 娑撴槒鍎楅弲?AppColor.bgTopBar = #F9F9FB       // TopBar閼冲本娅?

// 濞ｈ精澹婃稉濠氼暯
AppColor.bgScaffold = #181A20     // 濞ｈ精澹婃稉鏄忓剹閺?AppColor.containerGrey = #1F222A  // 濞ｈ精澹婄€圭懓娅掗懗灞炬珯
```

**娑撳顣介柅鍌炲帳閿涘牆绻€妞よ濞囬悽顭掔礆**閿?```dart
// 閴?濮濓絿鈥橀敍姘▏閻?CustomAppColor 閸斻劍鈧椒瀵屾０?CustomAppColor.of(context).bgScaffold       // 妞ょ敻娼伴懗灞炬珯
CustomAppColor.of(context).txtBlack         // 姒涙垼澹婇弬鍥х摟
CustomAppColor.of(context).txtPurple        // 缁鳖偉澹婂楦跨殶
CustomAppColor.of(context).btnPurple        // 缁鳖偉澹婇幐澶愭尦
CustomAppColor.of(context).borderGrey       // 鏉堣顢?
CustomAppColor.of(context).textFieldBorder  // 鏉堟挸鍙嗗鍡氱珶濡?
// 閴?闁挎瑨顕ら敍姘扁€栫紓鏍垳妫版粏澹?
backgroundColor: Colors.white
textColor: Color(0xFF000000)
```

#### 鐎涙ぞ缍嬬化鑽ょ埠

**鐎涙ぞ缍嬬€硅埖妫?*閿?```dart
Constant.fontFamilyUrbanist = 'Urbanist'    // 娑撹鐡ф担?```

**鐎涙鍣哥€规矮绠?*閿?- Light: 300
- Regular: 400
- Medium: 500
- SemiBold: 600
- Bold: 700

**鐎涙褰跨憴鍕瘱**閿?| 閻劑鈧?| 鐎涙褰?| 鐎涙鍣?| 娴ｈ法鏁ら崷鐑樻珯 |
|-----|------|------|---------|
| 婢堆勭垼妫?| 35 | 800 | 妞ょ敻娼版稉缁樼垼妫版﹫绱欐俊?鐠愶附鍩涢崚娑樼紦閹存劕濮?閿?|
| 閺嶅洭顣?| 24 | 700 | 妞ょ敻娼伴弽鍥暯閿涘牆顩?閻ц缍嶉崚鐗堝亶閻ㄥ嫯澶勯幋?閿?|
| 娴滃瞼楠囬弽鍥暯 | 18 | 800 | 閸掑棛琚弽鍥暯閵嗕笭eading缂佸嫪娆?|
| 閹稿鎸抽弬鍥х摟 | 15 | 500 | 娑撴槒顩﹂幐澶愭尦閺傚洤鐡?|
| 濮濓絾鏋?| 14 | 400-700 | 閺咁噣鈧碍鏋冮張顑锯偓浣界翻閸忋儲顢嬮弬鍥ㄦ拱 |
| 閸擃垱鐖ｆ０?| 12 | 500 | 鏉堝懎濮穱鈩冧紖閵嗕焦鐖ｇ粵?|
| 鐏忓繐褰块弬鍥х摟 | 10 | 500 | 閹绘劗銇氭穱鈩冧紖 |

**鐞涘矂鐝憴鍕瘱**閿?- 閹碘偓閺堝鏋冮張顒傜埠娑撯偓鐞涘矂鐝敍姝歨eight: 1.2`

**閸濆秴绨插蹇撶摟娴ｆ挾缂夐弨?*閿?- 閹靛婧€閿涙岸绮拋銈囩級閺€?1.0
- 楠炶櫕婢橀敍姘辩級閺€?0.6
- 閹舵ê褰旂仦蹇ョ窗缂傗晜鏂?0.6
- 閻劍鍩涢弬鍥х摟缂傗晜鏂侀梽鎰煑閿涙碍娓舵径?1.2

#### 閸濆秴绨插蹇氼啎鐠伮ゎ潐閼煎喛绱欒箛鍛淬€忔稉銉︾壐闁潧鐣ч敍?
**鐏忓搫顕柅鍌炲帳 - AppSizes**閿?```dart
// 閴?濮濓絿鈥橀敍姘▏閻?AppSizes 瀹搞儱鍙跨猾?width: AppSizes.setWidth(80)
height: AppSizes.setHeight(60)
fontSize: AppSizes.setFontSize(14)
padding: EdgeInsets.symmetric(
  horizontal: AppSizes.setWidth(20),
  vertical: AppSizes.setHeight(16),
)

// 鐢摜鏁ょ敮鎼佸櫤
AppSizes.fullWidth        // 鐏炲繐绠风€硅棄瀹?
AppSizes.fullHeight       // 鐏炲繐绠锋妯哄
AppSizes.buttonHeight     // 閺嶅洤鍣幐澶愭尦妤傛ê瀹?52
AppSizes.topBarHeight     // 妞ゅ爼鍎撮弽蹇涚彯鎼?60

// 閴?闁挎瑨顕ら敍姘扁€栫紓鏍垳鐏忓搫顕?
width: 80
height: 60
fontSize: 14
```

**闂傜绐涚憴鍕瘱**閿?
*濮樻潙閽╅梻纾嬬獩*閿?| 闂傜绐涢崐?| 娴ｈ法鏁ら崷鐑樻珯 |
|-------|---------|
| 8 | 閺嬩礁鐨梻纾嬬獩 |
| 10 | 鐏忓繘妫跨捄?|
| 12 | 閸ョ偓鐖ｉ梻纾嬬獩 |
| 15 | 閺嶅洤鍣梻纾嬬獩 |
| 18-20 | 妞ょ敻娼板锕€褰告潏纭呯獩 |
| 22 | 婢堆囨？鐠?|
| 24 | 閻楃懓銇囬梻纾嬬獩 |

*閸ㄥ倻娲块梻纾嬬獩*閿?| 闂傜绐涢崐?| 娴ｈ法鏁ら崷鐑樻珯 |
|-------|---------|
| 5 | 閺嬩礁鐨梻纾嬬獩 |
| 10 | 鐏忓繘妫跨捄?|
| 12 | 閺嶅洤鍣亸蹇涙？鐠?|
| 15 | 閺嶅洤鍣梻纾嬬獩 |
| 16 | 鐞涖劌宕熸い褰掓？鐠?|
| 20 | 婢堆囨？鐠烘縿鈧礁鍨庣紒鍕？鐠?|
| 25 | 閹绘劗銇氶弬鍥ㄦ拱娑撳﹣绗呴梻纾嬬獩 |
| 32 | 鐞涖劌宕熼幓鎰唉閹稿鎸虫稉濠呯珶鐠?|
| 58 | 妞ょ敻娼伴弽鍥暯闂傜绐?|
| 61 | 閻ц缍嶆い鐢搞€婇柈銊╂？鐠?|
| 88 | 婢堆嗗Ν闂傜绐?|

**閸﹀棜顫楃憴鍕瘱**閿?| 閸﹀棜顫楅崐?| 娴ｈ法鏁ら崷鐑樻珯 |
|-------|---------|
| 3 | 鐏忓繑瀵滈柦顔兼妇鐟?|
| 5 | 閸熷棗鎼ч崡锛勫閸﹀棜顫?|
| 8 | 閺嶅洤鍣崷鍡氼潡閿涘牐绶崗銉︻攱閵嗕焦瀵滈柦顔衡偓浣割啇閸ｎ煉绱?|
| 12 | 閺嶅洤鍣€圭懓娅掗崷鍡氼潡閿涘牐绶崗銉︻攱閿?|
| 15 | 婢堆冩妇鐟?|
| 20 | BottomSheet閸﹀棜顫?|

**妫版粏澹婃稉濠氼暯 - CustomAppColor**閿?```dart
// 閴?濮濓絿鈥橀敍姘▏閻劌濮╅幀浣峰瘜妫版﹫绱欓弨顖涘瘮娴?閺嗘膩瀵骏绱?
backgroundColor: CustomAppColor.of(context).bgScaffold
textColor: CustomAppColor.of(context).txtBlack
borderColor: CustomAppColor.of(context).borderPurple

// 鐢摜鏁ゆ０婊嗗
.bgScaffold          // 妞ょ敻娼伴懗灞炬珯閿涘牏娅ч懝?濞ｈ精澹婇敍?.txtBlack / .txtWhite // 閺傚洤鐡ф０婊嗗閿涘牐鍤滈崝銊ュ冀鏉烆剨绱?
.txtGrey / .txtPurple // 閻忔媽澹?缁鳖偉澹婇弬鍥х摟
.btnPurple           // 閹稿鎸崇槐顐ュ閿涘牅瀵屾０妯垮 #7165E3閿?.borderGrey / .borderPurple // 鏉堣顢嬫０婊嗗
.textFieldBorder     // 鏉堟挸鍙嗗鍡氱珶濡?
// 閴?闁挎瑨顕ら敍姘扁€栫紓鏍垳妫版粏澹?
backgroundColor: Colors.white
textColor: Color(0xFF000000)
```

**鐠佹儳顦猾璇茬€烽崚銈嗘焽**閿?```dart
AppSizes.isTablet(context)         // 楠炶櫕婢橀崚銈嗘焽
AppSizes.isFoldablePhone(size)     // 閹舵ê褰旂仦蹇撳灲閺?```

**闂堟瑦鈧浇绁┃鎰穿閻?*閿?```dart
// 閴?濮濓絿鈥橀敍姘垛偓姘崇箖闂堟瑦鈧礁鐖堕柌蹇曡瀵洜鏁?
Image.asset(AssetsImg.LOGO)
Image.asset(AssetsIcon.IC_PROFILE)
SvgAsset(assetName: AssetsSvg.IC_HOME)

// 閴?闁挎瑨顕ら敍姘扁€栫紓鏍垳鐠侯垰绶?
Image.asset('assets/img/logo.webp')
```

#### 妞ょ敻娼扮敮鍐ㄧ湰鐟欏嫯瀵?

**閸╃儤婀版い鐢告桨缂佹挻鐎?*閿?```dart
SafeArea(
  bottom: true,
  top: false,
  child: Scaffold(
    backgroundColor: CustomAppColor.of(context).bgScaffold,
    body: ...,
  ),
)
```

**妞ょ敻娼扮猾璇茬€?*閿?
*1. 閺嶅洤鍣い鐢告桨鐢啫鐪?閿?- TopBar閿涘牆褰查柅澶涚礆
- 娑撹鍞寸€圭懓灏崺?- 鎼存洟鍎寸€佃壈鍩呴弽蹇ョ礄閸欘垶鈧绱?

*2. 濠婃艾濮╂い鐢告桨鐢啫鐪?閿?```dart
SingleChildScrollView(
  padding: EdgeInsets.symmetric(
    horizontal: AppSizes.setWidth(20),
  ),
  child: Column(
    children: [
      // 妞ょ敻娼伴崘鍛啇
    ],
  ),
)
```

*3. 閸掓銆冩い鐢告桨鐢啫鐪?閿?```dart
ListView.builder(
  padding: EdgeInsets.symmetric(
    horizontal: AppSizes.setWidth(20),
    vertical: AppSizes.setHeight(16),
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => ...,
)
```

**妞ょ敻娼版潏纭呯獩鐟欏嫯瀵?*閿?- 閺嶅洤鍣い鐢告桨瀹革箑褰告潏纭呯獩閿?0
- TopBar 瀹革箑褰告潏纭呯獩閿?8
- 閸掓銆冩い鐟颁箯閸欏疇绔熺捄婵撶窗18-20
- 閸楋紕澧栭崘鍛扮珶鐠烘繐绱?5-18

**鐎瑰鍙忛崠鍝勭厵婢跺嫮鎮?*閿?- 妞ゅ爼鍎撮敍姘垛偓姘埗 `top: false`閿涘牏鏁?TopBar 婢跺嫮鎮婇敍?- 鎼存洟鍎撮敍姘垛偓姘埗 `bottom: true`

#### 閸ョ偓鐖ｇ挧鍕爱鐟欏嫯瀵?

**閸ョ偓鐖ｉ弽鐓庣础**閿?- 閺嶇厧绱￠敍姝恊bP
- 閺€顖涘瘮閺嗘澹婃稉濠氼暯閸掑洦宕?

**閸ョ偓鐖ｇ亸鍝勵嚟鐟欏嫯瀵?*閿?| 娴ｈ法鏁ら崷鐑樻珯 | 鐏忓搫顕?| 鐠囧瓨妲?|
|---------|------|------|
| TopBar 閸ョ偓鐖?| 24x24 | 鐎佃壈鍩呴弽蹇撴禈閺?|
| 閹稿鎸抽崶鐐垼 | 18-22 | 閹稿鎸抽崘鍛禈閺?|
| 閸掓銆冮崶鐐垼 | 20x20 | 閸掓銆冩い鐟版禈閺?|
| 鏉堟挸鍙嗗鍡楁禈閺?| 20x20 | 鐞涖劌宕熼崶鐐垼 |
| 鐏忓繐娴橀弽?| 10-14 | 閺嶅洨顒烽妴浣筋潡閺嶅洤娴橀弽?|
| 婢舵潙鍎?| 35x35 | 閻劍鍩涙径鏉戝剼 |

**閸ョ偓鐖ｆ担璺ㄦ暏鐟欏嫯瀵?*閿?```dart
// 閴?濮濓絿鈥橀敍姘▏閻劑娼ら幀浣界カ濠ф劗琚?
Image.asset(
  AssetsIcon.IC_SEARCH,
  width: AppSizes.setWidth(24),
  height: AppSizes.setHeight(24),
  color: CustomAppColor.of(context).icBlack,
  gaplessPlayback: true,  // 閹恒劏宕樻担璺ㄦ暏閿涘矂浼╅崗宥呮禈閻楀洭妫悜?)

// 閴?闁挎瑨顕ら敍姘扁€栫紓鏍垳鐠侯垰绶?
Image.asset('assets/icon/ic_search.webp')
```

#### 闂冩潙濂栫憴鍕瘱

**閹稿鎸抽梼鏉戝**閿?```dart
BoxShadow(
  color: AppColor.btnPurple.withOpacity(0.4),
  spreadRadius: 1,
  blurRadius: 4,
  offset: Offset(0, 2),
)
```

**TopBar 闂冩潙濂?*閿?```dart
BoxShadow(
  color: CustomAppColor.of(context).txtBlack.withOpacity(0.01),
  blurRadius: 3,
  spreadRadius: 2,
  offset: Offset(0, 4),
)
```

**閸楋紕澧栭梼鏉戝**閿?```dart
BoxShadow(
  color: Color(0xff000000).withOpacity(0.10),
  blurRadius: 8,
  spreadRadius: 2,
  offset: Offset(0, 2),
)
```

#### 交互规范

**点击反馈**：
- 使用 `InkWell` 或 `GestureDetector`
- 禁用状态使用 `IgnorePointer(ignoring: true)`

**页面导航**：
```dart
BaseRouter.push(context, AppPage.home)
BaseRouter.pop(context)
```

**弹窗交互**：
- BottomSheet：`showModalBottomSheet`
- Dialog：`showDialog`
- Alert：TDesign Flutter 组件

**输入框焦点管理**：
- 使用 `FocusNode` 管理焦点
- 聚焦时显示标签，修改边框颜色

### 页面拆分与组件化规范
- 大型或内容丰富的页面必须拆分为职责明确的 Widgets；主页面文件只保留状态持有、导航、Toast/弹窗、截图/保存等业务流程，不内联大块 UI。
- UI 区块放入 `widgets/` 目录的独立组件（如 header、card、actions、sheet 等），组件仅负责展示和触发回调，不直接持有业务状态。
- 弹窗/BottomSheet/保存分享类组件通过参数传入的回调执行业务 IO 或导航，避免在组件内部管理状态或依赖全局单例。
- 命名建议：`xxx_header.dart`、`xxx_card.dart`、`xxx_actions.dart`、`xxx_sheet.dart`，职责清晰。
- 需截图/保存的页面使用 `RepaintBoundary` 包裹目标组件，主页面负责图片生成与存储逻辑，子组件保持纯 UI。



#### 娑撳顣介崚鍥ㄥ床

**娑撳顣介柊宥囩枂**閿?```dart
ThemeData(
  brightness: isLightTheme ? Brightness.light : Brightness.dark,
  fontFamily: Constant.fontFamilyUrbanist,
  useMaterial3: true,
  scaffoldBackgroundColor: isLightTheme 
    ? AppColor.white 
    : AppColor.bgScaffold,
)
```

**娑撳顣介悩鑸碘偓浣侯吀閻?*閿?```dart
// 娴ｈ法鏁ら崗銊ョ湰閻樿埖鈧?Constant.isLightThemeGlobal = true/false
```

**妫版粏澹婇懛顏堚偓鍌氱安**閿?- 閴?韫囧懘銆忔担璺ㄦ暏 `CustomAppColor.of(context)` 閼惧嘲褰囨０婊嗗
- 閴?閼奉亜濮╅柅鍌炲帳濞村懓澹?濞ｈ精澹婃稉濠氼暯

#### 閹嗗厴娴兼ê瀵茬憴鍕瘱

**閸ュ墽澧栭崝鐘烘祰**閿?- 娴ｈ法鏁?`gaplessPlayback: true` 闁灝鍘ら崶鍓у闂傤亞鍎?
- WebP 閺嶇厧绱℃导妯哄閺傚洣娆㈡径褍鐨?
- 娴ｈ法鏁?`CachedNetworkImage` 閸旂姾娴囩純鎴犵捕閸ュ墽澧?

**閸掓銆冩导妯哄**閿?- 娴ｈ法鏁?`ListView.builder` 閹稿娓堕弸鍕紦
- `physics: NeverScrollableScrollPhysics()` 瑜版挸绁垫總妤€婀姘З鐎圭懓娅掓稉?- `shrinkWrap: true` 瑜版捇娓剁憰浣藉殰闁倸绨叉妯哄

**閻樿埖鈧胶顓搁悶?*閿?- 娴ｈ法鏁?`setState` 缁狅紕鎮婄仦鈧柈銊уЦ閹?- 娴ｈ法鏁?Cubit 缁狅紕鎮婃い鐢告桨缁狙呭Ц閹?- 娴ｈ法鏁?HydratedCubit 缁狅紕鎮婇崗銊ョ湰閹镐椒绠欓崠鏍Ц閹?
**鐢悂鍣烘导妯哄**閿?- 娴ｈ法鏁?`const` 閺嬪嫰鈧姴鍤遍弫?- 闁灝鍘ゆ稉宥呯箑鐟曚胶娈?Widget 闁插秴缂?

#### 閸欘垵顔栭梻顔解偓?
**閺傚洤鐡х紓鈺傛杹**閿?- 閺堚偓婢堆勬瀮鐎涙缂夐弨鍓ч兇閺佷即妾洪崚璁圭窗1.2
- 娴ｈ法鏁?`MediaQuery.textScaler` 閼惧嘲褰囬悽銊﹀煕鐠佸墽鐤?

**妫版粏澹婄€佃鐦惔?*閿?- 娑撴槒顩﹂弬鍥ㄦ拱鐎佃鐦惔锔肩窗閳?4.5:1
- 婢堆冨娇閺傚洦婀扮€佃鐦惔锔肩窗閳?3:1
- 閸濅胶澧濋懝鑼紶閼?(#7165E3) 閸︺劎娅ч懝鑼跺剹閺咁垯绗傜€佃鐦惔锔肩窗4.79:1

### Form Handling Standards

#### FormBuilder 闂嗗棙鍨?
```dart
FormBuilder(
  key: ctrl.formKey,
  child: Column(
    children: [
      CommonTextFormField(
        name: 'phone',              // 韫囧懘銆忛敍姘摟濞堥潧鎮?
        hintText: '閹靛婧€閸?,
        leadingIcon: Image.asset(AssetsIcon.IC_PROFILE),
        validators: FormBuilderValidators.compose([
          FormBuilderValidators.required(errorText: '閹靛婧€閸欒渹绗夐懗鎴掕礋缁?),
          FormBuilderValidators.numeric(),
        ]),
      ),
    ],
  ),
)
```

#### 鐞涖劌宕熸宀冪槈閸滃本褰佹禍?```dart
// Controller 娑擃厾娈戦弽鍥у櫙濡€崇础
bool formPrecheck() {
  if (state.loading) return false;
  return formKey.currentState?.saveAndValidate() ?? false;
}

submit() async {
  if (!formPrecheck()) return;
  
  emit(state.copyWith(loading: true));
  
  final formData = formKey.currentState?.value ?? {};
  final phone = formData['phone'] ?? '';
  // 婢跺嫮鎮婃稉姘闁槒绶?
}
```

### Router Management

#### 鐠侯垳鏁辩€规矮绠熼敍鍧剅outer/routes.dart`閿?```dart
enum AppPage {
  loginPage('/login'),
  registerPage('/register'),
  mainLayoutPage('/'),
  
  const AppPage(this.path);
  final String path;
  
  static final routes = AppPage.values
      .map((page) => BaseRoute(
            path: page.path,
            builder: page.builder,
          ))
      .toList();
}
```

#### 鐠侯垳鏁辩€佃壈鍩?
```dart
// 閴?閹恒劏宕橀敍姘▏閻?BaseRouter
BaseRouter.push(url: AppPage.loginPage.path)
BaseRouter.push(url: AppPage.otpPage.path, extra: {'type': 'register'})
BaseRouter.replace(url: AppPage.mainLayoutPage.path)
BaseRouter.pop()

// 閹存牔濞囬悽?GoRouter
context.go('/login')
context.push('/register')
```

#### 妞ょ敻娼版潪顒€婧€閸斻劎鏁鹃敍鍫濆讲闁绱?
```dart
extension PageRoute on AppPage {
  GoRouterPageBuilder? get pageBuilder {
    if (this == AppPage.loginPage) {
      return (context, state) => bottomToTopPageTransition(
        context: context, 
        state: state, 
        child: const LoginPage()
      );
    }
    return null;
  }
}
```

### Testing Strategy
- 娑撶儤澧嶉張澶夌瑹閸旓繝鈧槒绶紓鏍у晸閸楁洖鍘撳ù瀣槸
- 娑?Widget 缂傛牕鍟撶紒鍕濞村鐦?
- 娑撴椽鍣哥憰浣圭ウ缁嬪绱崘娆撴肠閹存劖绁寸拠?- 娴ｈ法鏁?mockito 鏉╂稖顢戝Ο鈩冨珯

### Git Workflow
- **閸掑棙鏁粵鏍殣**: Git Flow
  - `main/master`: 閻㈢喍楠囬悳顖氼暔閸掑棙鏁?
  - `develop`: 瀵偓閸欐垳瀵岄崚鍡樻暜
  - `feature/*`: 閸旂喕鍏橀崚鍡樻暜
- **閹绘劒姘︾憴鍕瘱**: 濞撳懏娅氶幓蹇氬牚閸欐ɑ娲块崘鍛啇
- **娴狅絿鐖滅€光剝鐓?*: 閸氬牆鑻熼崜宥呯箑妞ゆ槒绻樼悰灞煎敩閻礁顓搁弻?- **Pre-commit**: 瀹告煡鍘ょ純?pre-commit hook (scripts/pre-commit.sh)

## Domain Context

### 閻劍鍩涚憴鎺曞
妞ゅ湱娲伴弨顖涘瘮娑撳顫掗悽銊﹀煕鐟欐帟澹婇敍灞炬綀闂勬劙鈧帒顤冮敍?1. **閺咁噣鈧艾鎲冲?*: 閸╄櫣顢呴崝鐔诲厴鐠佸潡妫堕敍灞肩瑝閸欘垰鍘栭崐鐓庢嫲鐎电厧鍤?
2. **缁狅紕鎮婇崨?*: 閸涙ê浼愰弶鍐 + 缁備胶鏁ら崨妯轰紣閺夊啴妾?
3. **閼颁焦婢?*: 鐎瑰本鏆ｉ弶鍐閿涘苯瀵橀幏顒€鎲冲銉ь吀閻炲棗鎷扮化鑽ょ埠闁板秶鐤?

### 閺嶇绺炬稉姘閸︾儤娅?
- 閻劍鍩涚拋銈堢槈閿涘牏娅ヨぐ鏇樷偓浣规暈閸愬被鈧副TP妤犲矁鐦夐敍?- 閸旂姵琛ョ粩娆戠拨鐎?- 閻櫕琛ラ柌鍥枠鐠併垹宕熺粻锛勬倞
- 鐠愶附鍩涚粻锛勬倞
- 閺佺増宓佺€电厧鍤敍鍫ユ付缁狅紕鎮婇崨?閼颁焦婢橀弶鍐閿?
### API 閺佺増宓佺憴鍕瘱
- **鐠囬攱鐪伴弽鐓庣础**: 閺嶅洤鍣?JSON (Content-Type: application/json;charset=UTF-8)
- **閸濆秴绨查弽鐓庣础**: 缂佺喍绔寸紒鎾寸€?`{ code: number, message: string, data: any }`
  - code=200 鐞涖劎銇氶幋鎰
- **鐠併倛鐦夐張鍝勫煑**: 閸?Token 閺堝搫鍩?
  - `access_token`: 閻厽婀℃禒銈囧閿涘瞼鏁ゆ禍?API 鐠佸潡妫?
  - `refresh_token`: 闂€鎸庢埂娴犮倗澧濋敍宀€鏁ゆ禍搴″煕閺?access_token
  - 閼奉亜濮╅崚閿嬫煀閺堝搫鍩楅崷?access_token 鏉╁洦婀￠弮鎯靶曢崣?- **Base URL**: 
  - 瀵偓閸?濞村鐦? https://test.maiyoubei.com/api/app
  - 閻㈢喍楠? 瀵板懘鍘ょ純?
## Important Constraints
- **婢舵碍绗柆鎾存暜閹?*: 閺€顖涘瘮 oppo閵嗕箍ivo閵嗕簛iaomi 缁涘顦挎稉顏呯闁挻澧﹂崠?- **閹嗗厴鐟曚焦鐪?*: 
  - 娴ｈ法鏁?const 閺嬪嫰鈧姴鍤遍弫鏉垮櫤鐏忔垿鍣稿?  - 闂€鍨灙鐞涖劋濞囬悽?ListView.builder
  - 缂冩垹绮堕崶鍓у娴ｈ法鏁?CachedNetworkImage
  - 闁灝鍘ゆ稉宥呯箑鐟曚胶娈?Widget 闁插秴缂?
- **鐎涙顑佺紓鏍垳**: 缂佺喍绔存担璺ㄦ暏 UTF-8
- **閻滎垰顣ㄩ崚鍥ㄥ床**: 閺€顖涘瘮瀵偓閸?qa)閸滃瞼鏁撴禍?pro)閻滎垰顣ㄩ崚鍥ㄥ床
- **鐠佹儳顦崗鐓庮啇**: 閺€顖涘瘮閹靛婧€閸滃苯閽╅弶鍖＄礄閺嶈宓佺仦蹇撶鐎硅棄瀹抽崚銈嗘焽閿?- **缁傝崵鍤庨弨顖涘瘮**: 闁劌鍨庨弫鐗堝祦闂団偓鐟曚焦婀伴崷鎵处鐎?
## External Dependencies
- **API 閺堝秴濮?*: 閸氬海顏?REST API (濞村鐦悳顖氼暔: test.maiyoubei.com)
- **鐠併倛鐦夐張宥呭**: 
  - POST /auths/login - 閻劍鍩涢惂璇茬秿
  - POST /auths/refresh - Token 閸掗攱鏌?
  - POST /auths/logout - 闁偓閸戣櫣娅ヨぐ?- **鐠佹儳顦穱鈩冧紖**: Device Info Plus (閼惧嘲褰囩拋鎯ь槵閺嶅洩鐦?
- **OSS**: 闂冨潡鍣锋禍?OSS (閻劋绨?APK 娑撳﹣绱堕敍灞藉棘鐟?scripts/upload_oss.sh)
- **閸栧懍淇婇幁?*: Package Info Plus (閼惧嘲褰囨惔鏃傛暏閻楀牊婀版穱鈩冧紖)

### Code Generation

#### 閺佺増宓佸Ο鈥崇€烽悽鐔稿灇閿涘湗reezed + JSON Serializable閿?```bash
# 閻㈢喐鍨氶幍鈧張?.g.dart 閸?.freezed.dart 閺傚洣娆?
pnpm gen_model

# 閹存牜娲块幒銉ㄧ箥鐞?flutter pub run build_runner build --delete-conflicting-outputs
```

**閺佺増宓佸Ο鈥崇€风€规矮绠熺憴鍕瘱**閿?```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_req_type.freezed.dart';
part 'auth_req_type.g.dart';

@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String phone,
    String? password,
    String? code,
  }) = _LoginRequest;
  
  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}
```

#### 闂堟瑦鈧浇绁┃鎰晸閹?```bash
# 閻㈢喐鍨?static/ 閻╊喖缍嶆稉瀣畱鐠у嫭绨敮鎼佸櫤缁?pnpm gen_assets

# 閹存牜娲块幒銉ㄧ箥鐞?dart ./scripts/gen_assets.dart
```

閼奉亜濮╅悽鐔稿灇 `AssetsImg`閵嗕梗AssetsIcon`閵嗕梗AssetsSvg` 缁涘娼ら幀浣鸿閵?
#### 妞ょ敻娼板Ο鈩冩緲閻㈢喐鍨?
```bash
# 娴ｈ法鏁ら懘姘閺嬪墎鏁撻幋鎰暚閺佹挳銆夐棃銏㈢波閺?pnpm gen_page

# 閹存牜娲块幒銉ㄧ箥鐞?dart ./scripts/create_page.dart
```

閻㈢喐鍨氶弽鍥у櫙閻?page閵嗕恭ontroller閵嗕够tate閵嗕箍iew 閸ユ稐娆㈡總妞尖偓?
### Logging Standards

#### 閺冦儱绻斿銉ュ徔閿涘潉utils/log.dart`閿?```dart
import 'package:oil_business_app/utils/log.dart';

// 鐠嬪啳鐦弮銉ョ箶
l.d('Login', '瀵偓婵娅ヨぐ? 閹靛婧€閸?$phone');

// 娣団剝浼呴弮銉ョ箶
l.i('Init', '######################## 妞ょ敻娼伴崚婵嗩潗閸?########################');

// 闁挎瑨顕ら弮銉ョ箶
l.e('Register', '濞夈劌鍞芥径杈Е: $e');

// 鐠€锕€鎲￠弮銉ョ箶
l.w('Network', '缂冩垹绮剁拠閿嬬湴鐡掑懏妞?);
```

**閺冦儱绻旂憴鍕瘱**閿?- 缁楊兛绔存稉顏勫棘閺佸府绱板Ο鈥虫健/閸旂喕鍏橀弽鍥槕
- 缁楊兛绨╂稉顏勫棘閺佸府绱伴崗铚傜秼閺冦儱绻旈崘鍛啇
- 闁灝鍘ら崷銊ф晸娴溠呭箚婢у啯澧﹂崡鐗堟櫛閹扮喍淇婇幁?- 閸忔娊鏁稉姘濞翠胶鈻艰箛鍛淬€忕拋鏉跨秿閺冦儱绻?

### Error Handling

#### 缂冩垹绮堕柨娆掝嚖婢跺嫮鎮?
```dart
try {
  final response = await authService.login(request);
  // 婢跺嫮鎮婇幋鎰閸濆秴绨?
} on DioException catch (e) {
  // Dio 缂冩垹绮堕柨娆掝嚖
  l.e('Login', 'DioException: ${e.message}');
  emit(state.copyWith(loading: false, errorMessage: e.message));
} catch (e) {
  // 閸忔湹绮柨娆掝嚖
  l.e('Login', '閻ц缍嶆径杈Е: $e');
  emit(state.copyWith(loading: false));
}
```

#### 缂佺喍绔撮柨娆掝嚖婢跺嫮鎮婇敍鍫熷閹搭亜娅掔仦鍌︾礆
缂冩垹绮堕柨娆掝嚖闁俺绻?`HttpRespInterceptor` 缂佺喍绔存径鍕倞閿?- 401: Token 婢惰鲸鏅ラ敍宀冨殰閸斻劌鍩涢弬鐗堝灗鐠哄疇娴嗛惂璇茬秿
- 403: 閺夊啴妾烘稉宥堝喕
- 500: 閺堝秴濮熼崳銊╂晩鐠?- 缂冩垹绮剁搾鍛/閺冪姷缍夌紒?
### Performance Optimization

#### 韫囧懘銆忛柆闈涚暓閻ㄥ嫪绱崠鏍у斧閸?1. **娴ｈ法鏁?const 閺嬪嫰鈧姴鍤遍弫?*
   ```dart
   // 閴?濮濓絿鈥?
   const Text('Hello')
   const SizedBox(height: 10)
   
   // 閴?闁挎瑨顕?
   Text('Hello')
   SizedBox(height: 10)
   ```

2. **闂€鍨灙鐞涖劋濞囬悽?Builder**
   ```dart
   // 閴?濮濓絿鈥?
   ListView.builder(
     itemCount: items.length,
     itemBuilder: (context, index) => ItemWidget(items[index]),
   )
   
   // 閴?闁挎瑨顕ら敍姘濞嗏剝鈧冨灡瀵ょ儤澧嶉張?Widget
   ListView(children: items.map((e) => ItemWidget(e)).toList())
   ```

3. **缂冩垹绮堕崶鍓у娴ｈ法鏁ょ紓鎾崇摠**
   ```dart
   // 閴?濮濓絿鈥?
   CachedNetworkImage(
     imageUrl: imageUrl,
     placeholder: (context, url) => CircularProgressIndicator(),
   )
   
   // 閴?闁挎瑨顕ら敍姘槨濞嗭繝鍣搁弬棰佺瑓鏉?   Image.network(imageUrl)
   ```

4. **闁灝鍘ゆ稉宥呯箑鐟曚胶娈戦柌宥呯紦**
   - 娴ｈ法鏁?`const` 閺嬪嫰鈧姴鍤遍弫?   - 閸氬牏鎮婃担璺ㄦ暏 `BlocBuilder` 閻?`buildWhen`
   - 娴ｈ法鏁?`RepaintBoundary` 闂呮梻顬囨径宥嗘絽缂佸嫪娆?

#### 鐠佹儳顦柅鍌炲帳
- 閺€顖涘瘮閹靛婧€閸滃苯閽╅弶鍖＄礄鐏炲繐绠风€硅棄瀹?> 600 娑撳搫閽╅弶鍖＄礆
- 閺€顖涘瘮閹舵ê褰旂仦蹇氼啎婢跺洦顥呭ù?- 鐎涙ぞ缍嬫径褍鐨梽鎰煑閺堚偓婢堆呯級閺€?1.2 閸?- 濡亞鐝仦蹇撳瀼閹广垼鍤滈崝銊╁櫢閺傛媽顓哥粻妤€鏄傜€?
### Best Practices

#### 娴狅絿鐖滅紒鍕矏
1. **鐎电厧鍙嗘い鍝勭碍**閿涙art SDK 閳?Flutter 閳?缁楊兛绗侀弬鐟板瘶 閳?妞ゅ湱娲伴崘鍛村劥
2. **閺傚洣娆㈤崨钘夋倳**閿涙艾鐨崘娆庣瑓閸掓帞鍤庨崚鍡涙閿涘潉login_controller.dart`閿?3. **缁鎳￠崥?*閿涙艾銇囨す鐓庡槻閿涘潉LoginController`閿?4. **閺傝纭?閸欐﹢鍣洪崨钘夋倳**閿涙艾鐨す鐓庡槻閿涘潉submitForm`閿?5. **鐢悂鍣洪崨钘夋倳**閿涙艾銇囬崘娆庣瑓閸掓帞鍤庨敍鍧凪AX_LENGTH`閿?
#### 缂佸嫪娆㈢拋鎹愵吀
1. **閸楁洑绔撮懕宀冪煑**閿涙碍鐦℃稉顏嗙矋娴犺泛褰ч崑姘娴犳湹绨?
2. **閸欘垰顦查悽銊︹偓?*閿涙岸鈧氨鏁ょ紒鍕閺€?`widgets/base/`
3. **閸欏倹鏆熺拋鎹愵吀**閿涙艾绻€闂団偓閸欏倹鏆熼悽?`required`閿涘苯褰查柅澶婂棘閺佺増褰佹笟娑㈢帛鐠併倕鈧?4. **閻㈢喎鎳￠崨銊︽埂**閿涙碍顒滅涵顔碱槱閻?`initState`閵嗕梗dispose`

#### 閻樿埖鈧胶顓搁悶?1. **妞ょ敻娼伴悩鑸碘偓?*閿涙矮濞囬悽?Cubit閿涘奔绻氶幐浣虹暆閸?2. **閸忋劌鐪悩鑸碘偓?*閿涙矮濞囬悽?HydratedCubit閿涘矁鍤滈崝銊﹀瘮娑斿懎瀵?
3. **娴滃娆㈤柅姘繆**閿涙矮濞囬悽?EventBus閿涘矁袙閼帮附膩閸?4. **閻樿埖鈧椒绗夐崣顖氬綁**閿涙艾顫愮紒鍫滃▏閻?`copyWith` 閺囧瓨鏌婇悩鑸碘偓?
#### 娴狅絿鐖滅拹銊╁櫤
1. **Linter 鐟欏嫬鍨?*閿涙矮寮楅弽濂镐紥鐎?`analysis_options.yaml` 闁板秶鐤?
2. **缁鐎风€瑰鍙?*閿涙岸浼╅崗宥勫▏閻?`dynamic`閿涘本妲戠涵顔捐閸?3. **缁屽搫鐣ㄩ崗?*閿涙碍顒滅涵顔诲▏閻?`?` 閸?`!`
4. **濞夈劑鍣撮弬鍥ㄣ€?*閿涙艾鍙曢崗?API 韫囧懘銆忛張澶嬫瀮濡楋絾鏁為柌?
## Build & Deployment

### 瀵偓閸欐垹骞嗘晶?```bash
# 鐎瑰顥婃笟婵婄
flutter pub get

# 閸氼垰濮╁鈧崣鎴炴箛閸斺槄绱欐径姘闁挻鏁幐渚婄礆
pnpm dev                      # 姒涙顓?oppo 濞撶娀浜?
flutter run --flavor oppo
flutter run --flavor vivo
flutter run --flavor xiaomi
```

### 娴狅絿鐖滈悽鐔稿灇
```bash
pnpm gen_model    # 閻㈢喐鍨氶弫鐗堝祦濡€崇€?
pnpm gen_assets   # 閻㈢喐鍨氶棃娆愨偓浣界カ濠ф劕鐖堕柌?pnpm gen_page     # 閻㈢喐鍨氭い鐢告桨濡剝婢?
```

### 閺嬪嫬缂撻幍鎾冲瘶
```bash
# Android APK
pnpm build_android

# iOS IPA
pnpm build_ios

# 娑撳﹣绱堕崚?OSS
pnpm upload_app
```

### 濞撳懐鎮婇崪宀勫櫢缂?```bash
pnpm reset        # flutter clean + pub get
flutter clean     # 濞撳懐鎮婇弸鍕紦缂傛挸鐡?
```

### 閻滎垰顣ㄩ崣姗€鍣?
- `HTTP_ENV`: 閻滎垰顣ㄩ崚鍥ㄥ床閿?=瀵偓閸欐埊绱?=閻㈢喍楠囬敍?- `BUILD_NUMBER`: 閺嬪嫬缂撻崣鍑ょ礄CI/CD 濞夈劌鍙嗛敍?
### Git Hooks
妞ゅ湱娲伴柊宥囩枂娴?pre-commit hook閿?```bash
# 鐎瑰顥?hook
pnpm install
# 閹?sh ./scripts/install.sh
```

Hook 娴兼艾婀幓鎰唉閸撳秷鍤滈崝顭掔窗
- 鏉╂劘顢?Linter 濡偓閺?- 閺嶇厧绱￠崠鏍﹀敩閻?- 閹笛嗩攽韫囶偊鈧喐绁寸拠?
