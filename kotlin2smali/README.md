# Kotlin 源码 → 手写 smali 对照笔记

## 能写，但要知道编译器到底生成了什么

| Kotlin 特性 | 产物特征（手写时必须还原） |
|---|---|
| data class | `componentN()` / `copy()` / `copy$default()`(static synthetic，int flags) / `equals` + `Intrinsics.areEqual` / `hashCode`(`*31` 累加) / `toString`(StringBuilder) |
| 默认参数 | `foo()` 以外多一个 `foo$default(..., int mask, Object marker)` static synthetic |
| 顶层函数 / 顶层属性 | 包进 `XxxKt` 类，全部是 `static` |
| 扩展函数 | static 方法，**接收者作为第一个参数**（`p0`） |
| 非空参数 | 方法开头 `Intrinsics.checkNotNullParameter(pX, "名字")` |
| `lateinit` | 字段无初始化 + getter 里 `throw UninitializedPropertyAccessException` |
| 属性 | 私有 backing field + `getX()/setX()`，`val` 只有 getter |
| object 单例 | `public static final INSTANCE:LXxx;` + `<clinit>` 里 new |
| companion object | `public static final Companion` + 宿主类里的 `Companion` 转发方法（`@JvmStatic` 才有真 static） |
| sealed class | 抽象类 + 私有构造，子类同文件 |
| inline / reified | **调用点被内联展开**，smali 里根本看不到函数调用；手写要自己把逻辑摊开 |
| suspend 函数 | 多一个 `Continuation` 尾参，返回 `Object`；内部是 `label` + `switch` 状态机，检查 `== COROUTINE_SUSPENDED` |
| value class | 方法名被 mangle：`xxx-impl(...)`、`box-impl`、`unbox-impl` |
| 委托属性 | `getValue/setValue` + `$$delegatedProperties` 数组 |
| lambda | 默认生成 `Xxx$foo$1` 合成类（实现 `Function0..N` + 捕获字段 + `invoke`）；只有加 `-Xlambdas=indy` 才走 `invokedynamic` / `LambdaMetafactory` |
| 字符串模板 | `new StringBuilder()` 一串 append（**不是** makeConcatWithConstants） |
| 内部类 | 类名是 `Outer$Inner`，`$` 在 smali 描述符里是合法字符，不用转义 |

## 手写时最容易翻车的地方

1. **寄存器数**：`.locals` 只算 v 寄存器；p 寄存器数量 = 参数个数（实例方法要 +1 给 p0），写错直接 VerifyError。
2. **类型验证**：`invoke-virtual` 的对象必须是声明类型，`check-cast` 不能省。
3. **dex 上限**：手写 lambda 会爆炸式增加合成类，方法数一旦过 64K 就得处理 multidex。
4. **`synthetic`/`bridge` 标志**：Kotlin 编译器的 `$default`、泛型桥接方法带 `ACC_SYNTHETIC`，漏标会让反射/编译器行为不一致。
5. **注解**：`@Metadata` 是 Kotlin 反射的命根子，手写基本没法精确还原；纯改行为可以不管，但一旦有第三方库用 KClass 反射就会炸。

## 实践建议

- 能用工具链就别手写：`kotlinc` → `d8` → `baksmali`，产物 100% 正确。
- 反编译 APK 时优先用 **Jadx 出 Java**，看 Kotlin 特征；要改就直接改 smali，别想着"翻译回 Kotlin 再编回去"。
- 手写只适合三种情况：补一个极短的 hook 方法、改常量/条件、写 Xposed 里必须内联进目标类的逻辑。
- hook 场景下通常更划算的做法：写一个 Java/Kotlin 辅助类编译出 smali，再把方法体搬进目标类。
