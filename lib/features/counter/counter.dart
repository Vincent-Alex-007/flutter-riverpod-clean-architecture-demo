/// Counter 功能模块的**唯一对外入口**。
///
/// **约定**
/// - `lib` 下除本功能内部实现、以及 `lib/infrastructure/di` 里 Injectable **生成**的注册代码外，
///   任何文件需要用到本功能时，只能：
///   `import '.../features/counter/counter.dart';`
/// - 对外暴露的成员一律在本文件通过 `export ... show ...` 列出；未 export 的类型、实现类视为模块私有。
/// - 子目录之间仍按分层引用：`presentation` → `application` → `domain`；
///   `infrastructure` 实现 `domain` 端口，避免 `presentation` 直接依赖 `infrastructure`。
///
/// **Injectable 说明**：`injection.config.dart` 会生成对 `application` / `infrastructure` 等路径的 import，
/// 这是依赖注入装配所需，不算「业务侧」引用；手写代码请勿模仿。
library;

export 'presentation/routes/counter_routes.dart'
    show CounterDemoRoute, counterRoutes;
