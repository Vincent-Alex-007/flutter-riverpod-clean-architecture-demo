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

### 依赖注入：双系统（get_it + injectable ｜ Riverpod）

#### 职责划分

| 层 | 管理方式 | 说明 |
|---|---|---|
| 基础设施服务 | **get_it + injectable** | Talker、SharedPreferences、AppDatabase、DioClient、GoRouter 等全局单例 |
| Data 层 | **get_it + injectable** | DataSource 实现、Repository 实现，通过 `@LazySingleton(as: Interface)` 绑定接口 |
| Domain 层 | **get_it + injectable** | UseCase，通过 `@LazySingleton` 注册，构造函数自动注入 Repository |
| Feature 组合 | **get_it + injectable** | 上述三层的接线均由 injectable 代码生成自动完成 |
| UI 状态 | **Riverpod** | `@riverpod` 注解的 Notifier/Provider，管理页面状态与交互逻辑 |

#### 边界规则

1. **get_it 管对象图，Riverpod 管 UI 状态** — 所有非 UI 的依赖（服务、数据源、仓库、用例）一律注册到 get_it。Riverpod Provider 只出现在 `presentation/providers/` 目录下。
2. **Riverpod Provider 通过 `getIt<T>()` 获取用例** — Provider 内部不使用 `ref.watch` 获取业务依赖，而是直接从 get_it 取。`ref.watch` / `ref.read` 仅用于 Provider 之间的状态依赖。
3. **禁止在 data/domain 层引用 Riverpod** — data 和 domain 层代码不得导入任何 Riverpod 包，保持纯 Dart。
4. **禁止在 UI 层直接使用 `getIt<T>()`** — Widget 中只通过 `ref.watch(xxxProvider)` 获取状态，不直接调用 get_it。唯一允许调用 `getIt` 的 UI 层代码是 Riverpod Provider 定义内部。
5. **环境切换** — `configureDependencies(env)` 在 `bootstrap()` 中按 `AppEnvEnum` 调用，injectable 通过 `@Environment` 注解区分环境实现。

#### get_it 配置

- 入口：`lib/infrastructure/di/injection.dart` — 暴露 `getIt` 实例和 `configureDependencies()` 函数
- 生成文件：`lib/infrastructure/di/injection.config.dart`
- 模块：`lib/infrastructure/di/modules/` — 按职责拆分（config、database、log、network、storage、router）

#### Riverpod 使用范围

- 仅在 `lib/features/<name>/presentation/providers/` 中定义
- 使用 `@riverpod` 注解 + riverpod_generator 代码生成
- Notifier 内通过 `getIt<UseCase>()` 获取用例，不在 Provider 中重建业务对象

### Core 层（`lib/core/`）

Core 是**跨 feature 共享的纯 Dart 层**，提供基础抽象和通用工具。它不属于任何 feature，也不依赖 Flutter framework。

#### 依赖规则

- **只能使用 Dart SDK 和 Flutter SDK 自带的库**（`dart:*`、`package:flutter/*`）
- **禁止使用任何第三方 pub 包**（如 dio、drift、injectable 等）
- 若某个 core 抽象的**实现**需要第三方库，在 core 中定义 `abstract interface class`，由 `infrastructure/` 提供实现

#### 职责边界

| 允许放入 core 的 | 禁止放入 core 的 |
|---|---|
| 基础抽象（Result、UseCase 基类、AppException） | 具体 feature 的实体、DTO |
| 需要第三方库实现的抽象接口（core 定义接口，infrastructure 实现） | 直接依赖第三方库的实现代码 |
| 通用纯 Dart 工具函数（金额格式化、日期格式化等） | 任何依赖 Riverpod 的代码 |
| 全局常量、枚举（环境枚举、日期格式枚举、语言常量） | Repository 接口或实现（属于 feature 或 infrastructure） |
| 真正领域无关的跨 feature 共享逻辑 | 具体业务规则（属于 feature 的 Domain Service） |

#### 目录结构

```
lib/core/
├── result.dart          # Result<T> — sealed class，封装成功/失败
├── usecase.dart         # UseCase<Params, T> / NoParamsUseCase<T> 基类
├── exceptions.dart      # AppException 及子类型（Business/Network/Json）
├── errors.dart          # 全局错误处理相关
├── config/              # 全局配置值对象
├── constants/           # 全局常量（locale 等）
├── enums/               # 全局枚举（AppEnvEnum、DateTimePatternEnum 等）
└── utils/               # 通用工具函数（currency_format 等）
```

#### 核心抽象

- **`Result<T>`** — sealed class，封装成功/失败结果。UseCase 返回 `Result` 而非直接抛异常。提供 `when`/`map`/`link`/`flatLink` 扩展方法。
- **`UseCase<Params, T>` / `NoParamsUseCase<T>`** — 用例基类。子类实现 `execute()`，`call()` 包装器捕获 `AppException` 并包装为 `Result.error`。
- **`AppException`** — 异常基类，子类型：`BusinessException`、`NetworkException`、`JsonException`。

#### Domain Service（`features/<name>/domain/services/`）

Domain Service 是从 UseCase 中提取出的**可复用纯业务计算逻辑**，放在所属 feature 的 `domain/services/` 下。与 UseCase 的关系：

| | UseCase | Domain Service |
|---|---|---|
| 职责 | 编排一个完整用户动作 | 封装一段可复用的业务规则/计算 |
| 粒度 | 粗粒度，对应用户操作 | 细粒度，对应规则片段 |
| IO | 可调用 Repository 做读写 | **纯计算，无 IO**，不依赖 Repository |
| 调用方 | Riverpod Provider（通过 get_it） | UseCase 内部（通过构造函数注入） |
| 复用性 | 通常一对一 | 可被多个 UseCase 复用 |

**使用规则：**

1. Domain Service 放在 `features/<name>/domain/services/` 下，用 `@lazySingleton` 注册到 get_it
2. UseCase 通过构造函数注入 Domain Service
3. Domain Service **纯计算、无 IO**，不依赖 Repository
4. 不需要时不拆 — 逻辑简单直接写在 UseCase 的 `execute()` 中即可
5. 需要拆分的信号：① 同 feature 内多个 UseCase 需要同一段规则 ② 规则本身复杂需要独立测试
6. **不放 core** — 具体业务规则属于 feature，core 只放领域无关的基础抽象和通用工具

#### 跨 feature 共享逻辑的放置决策

当业务逻辑需要被多个 feature 使用时：

| 逻辑性质 | 放置位置 | 示例 |
|---|---|---|
| feature 内多个 UseCase 共享的纯计算规则 | 该 feature 的 `domain/services/` | 定价计算、折扣规则 |
| 跨 feature 共享且领域无关的工具函数 | `core/utils/` | 金额格式化、日期格式化 |
| 有自己的数据表和实体的独立能力 | 独立 feature（`features/shared_xxx/`） | 通知模块、审计日志 |
| 通用数据存取能力 | `infrastructure/services/` | 文件操作、加密、缓存策略 |

### Infrastructure 层（`lib/infrastructure/`）

Infrastructure 是**第三方库的隔离层**，封装所有外部依赖，向 core 和 feature 提供具体实现。

#### 职责边界

| 允许放入 infrastructure 的 | 禁止放入 infrastructure 的 |
|---|---|
| 第三方库的封装与适配（Dio、Drift、GoRouter 等） | 业务逻辑（属于 feature 的 domain 层） |
| core 层抽象接口的实现 | UI 组件、页面（属于 feature 的 presentation 层） |
| 全局单例服务（数据库、网络、日志、存储、WebSocket） | feature 特有的 data source 实现（属于 feature 的 data 层） |
| DI 容器配置（get_it + injectable 模块） | Riverpod Provider 定义（属于 feature 的 presentation 层） |
| 路由配置、拦截器、错误处理 | feature 的 entity 或 repository 接口 |

#### 核心原则

1. **隔离第三方库** — 第三方库的 import 只出现在 infrastructure 内部（和 feature 的 data 层），core 和 domain 层不直接依赖
2. **实现 core 抽象** — core 定义 `abstract interface class`，infrastructure 提供实现并通过 get_it 注册
3. **可替换性** — 更换第三方库（如 Dio → http）只需修改 infrastructure，不影响 feature 的 domain/presentation 层
4. **injectable 注解例外** — `@lazySingleton` / `@injectable` 等 DI 注解允许出现在 feature 的 data/domain 层，因为它们是编译期元数据，不引入运行时依赖

#### 目录结构

```
lib/infrastructure/
├── config/          # 环境配置（envied）、时区处理
├── database/        # Drift SQLite 数据库（AppDatabase、表定义、迁移）
├── di/              # get_it 配置
│   ├── injection.dart          # 入口：暴露 getIt 和 configureDependencies()
│   ├── injection.config.dart   # 生成文件
│   └── modules/                # injectable 模块（按职责拆分）
├── errors/          # 全局错误处理（ErrorHandler）
├── network/         # Dio HTTP 客户端
│   ├── dio_client.dart
│   ├── response_model.dart
│   └── interceptors/           # 拦截器（auth、response 解析）
├── router/          # GoRouter 路由配置（go_router_builder 类型安全路由）
└── websocket/       # WebSocket 客户端
```

#### core ↔ infrastructure 协作模式

当 core 需要某个能力但实现依赖第三方库时：

```
lib/core/
└── interfaces/
    └── xxx_service.dart         ← abstract interface class（纯 Dart）

lib/infrastructure/
└── services/
    └── xxx_service_impl.dart    ← 实现类，依赖第三方库，@LazySingleton(as: XxxService)
```

feature 的 domain 层只依赖 core 中的接口，通过 get_it 注入 infrastructure 的实现。

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
