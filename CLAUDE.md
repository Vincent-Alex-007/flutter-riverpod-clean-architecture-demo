# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

基于 Clean Architecture 的 Flutter 应用模板，使用 Riverpod 做状态管理，get_it + injectable 做依赖注入。通过 FVM 管理 Flutter 版本（当前 3.41.5）。

## 常用命令

```bash
# 运行应用（按环境区分入口）
fvm flutter run -t lib/main_dev.dart
fvm flutter run -t lib/main_uat.dart
fvm flutter run -t lib/main_prod.dart

# 代码生成（freezed、json_serializable、riverpod_generator、injectable、go_router_builder、flutter_gen）
fvm dart run build_runner build --delete-conflicting-outputs
fvm dart run build_runner watch --delete-conflicting-outputs

# 国际化生成
fvm flutter gen-l10n

# 静态分析
fvm flutter analyze

# 测试
fvm flutter test
fvm flutter test test/widget_test.dart   # 单个测试
```

## 架构

### Clean Architecture 分层（按 feature 组织）

每个 feature 位于 `lib/features/<name>/`，内部分三层，依赖方向严格单向：

- **presentation/** → UI（pages、routes）和状态管理（Riverpod providers）。只依赖 domain 层。
- **domain/** → 业务逻辑：entities（freezed 模型）、repository 接口、use cases。不依赖 data 层。
- **data/** → 实现层：repository 实现、data sources（local/remote）、DTOs。实现 domain 层接口。

### Barrel File 约定

每个 feature 有一个桶文件（`lib/features/<name>/<name>.dart`），是该 feature 的**唯一对外入口**。外部代码必须通过此桶文件导入，未 export 的类型视为模块私有。feature 内部子目录之间按分层引用。

### 依赖注入：双系统

- **get_it + injectable** — 服务层 DI。类上标注 `@LazySingleton`、`@Injectable` 等，代码生成产出 `injection.config.dart`。通过 `configureDependencies(env)` 按环境（dev/uat/prod）配置。
- **Riverpod（riverpod_annotation + riverpod_generator）** — UI 状态管理。Provider 使用 `@riverpod` 注解，代码生成产出 `*.g.dart`。Provider 内通过 `getIt<UseCase>()` 获取用例实例。

### 核心抽象（`lib/core/`）

- **`Result<T>`** — sealed class，封装成功/失败结果。Use case 返回 `Result` 而非直接抛异常。提供 `when`/`map`/`link`/`flatLink` 扩展方法。
- **`UseCase<Params, T>` / `NoParamsUseCase<T>`** — 用例基类。子类实现 `execute()`，`call()` 包装器捕获 `AppException` 并包装为 `Result.error`。
- **`AppException`** — 异常基类，子类型：`BusinessException`、`NetworkException`、`JsonException`。

### 基础设施（`lib/infrastructure/`）

- **di/** — get_it 配置，injectable 模块（config、log、storage、router）
- **network/** — Dio HTTP 客户端及拦截器（auth、response 解析）
- **router/** — GoRouter 路由配置，使用 go_router_builder 实现类型安全路由
- **config/** — 环境配置（envied）、时区处理

### 入口文件

三个环境入口（`main_dev.dart`、`main_uat.dart`、`main_prod.dart`）均调用 `bootstrap()`，依次初始化 Flutter bindings、DI、Talker 日志、Riverpod `ProviderContainer`。

### 国际化

ARB 文件位于 `lib/assets/arbs/`（en、zh、es、ja、ko）。生成类 `L10n` 位于 `lib/l10n/l10n.g.dart`。

### 生成文件

`*.g.dart`、`*.freezed.dart`、`injection.config.dart` 均为代码生成产物。修改带注解的类后需运行 build_runner。这些文件已在 `analysis_options.yaml` 中排除分析。

### 资源生成

flutter_gen 生成 `lib/assets/gen/assets.gen.dart`，提供类型安全的资源引用。资源文件放在 `assets/images/` 和 `assets/icons/`。

## 代码风格

- 项目内优先使用相对导入
- 优先使用单引号
- 多行参数列表必须使用尾随逗号
- 使用 Dart 3 类修饰符：`final class` / `sealed class` / `abstract interface class`
- 注释使用中文
