import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../core/exceptions.dart';
import '../../config/app_env.dart';

/// WebSocket 连接状态
enum WebSocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

/// WebSocket 客户端，管理连接、重连、心跳
@lazySingleton
final class WebSocketClient {
  WebSocketClient(this._talker, AppEnv appEnv) : _wsUrl = appEnv.wsUrl;

  final Talker _talker;
  final String _wsUrl;

  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  Timer? _reconnectTimer;
  StreamSubscription<dynamic>? _subscription;

  int _reconnectAttempt = 0;
  static const int _maxReconnectAttempt = 5;
  static const Duration _heartbeatInterval = Duration(seconds: 30);

  final _stateController = StreamController<WebSocketConnectionState>.broadcast();
  final _messageController = StreamController<dynamic>.broadcast();

  WebSocketConnectionState _state = WebSocketConnectionState.disconnected;

  /// 当前连接状态
  WebSocketConnectionState get state => _state;

  /// 连接状态变化流
  Stream<WebSocketConnectionState> get stateStream => _stateController.stream;

  /// 接收消息流
  Stream<dynamic> get messageStream => _messageController.stream;

  /// 建立 WebSocket 连接
  Future<void> connect({String? path, Map<String, String>? headers}) async {
    if (_state == WebSocketConnectionState.connected ||
        _state == WebSocketConnectionState.connecting) {
      return;
    }

    _updateState(WebSocketConnectionState.connecting);

    try {
      final uri = Uri.parse('$_wsUrl${path ?? ''}');
      _channel = WebSocketChannel.connect(uri, protocols: null);
      await _channel!.ready;

      _updateState(WebSocketConnectionState.connected);
      _reconnectAttempt = 0;
      _talker.info('WebSocket 已连接: $uri');

      _startHeartbeat();
      _listenMessages();
    } on Exception catch (e, s) {
      _talker.error('WebSocket 连接失败', e, s);
      _updateState(WebSocketConnectionState.disconnected);
      _scheduleReconnect(path: path, headers: headers);
    }
  }

  /// 发送消息（String 或 Map 自动 JSON 编码）
  void send(dynamic data) {
    if (_state != WebSocketConnectionState.connected || _channel == null) {
      throw const NetworkException(message: 'WebSocket 未连接');
    }

    final payload = data is Map || data is List ? jsonEncode(data) : data;
    _channel!.sink.add(payload);
    _talker.debug('WebSocket 发送: $payload');
  }

  /// 主动断开连接
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _reconnectAttempt = 0;
    _updateState(WebSocketConnectionState.disconnected);
    _talker.info('WebSocket 已断开');
  }

  /// 监听消息
  void _listenMessages() {
    _subscription?.cancel();
    _subscription = _channel?.stream.listen(
      (data) {
        _talker.debug('WebSocket 收到: $data');
        _messageController.add(data);
      },
      onError: (Object error, StackTrace stackTrace) {
        _talker.error('WebSocket 错误', error, stackTrace);
        _handleDisconnect();
      },
      onDone: () {
        _talker.warning('WebSocket 连接关闭 (code=${_channel?.closeCode})');
        _handleDisconnect();
      },
    );
  }

  /// 心跳保活
  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      if (_state == WebSocketConnectionState.connected) {
        try {
          send('ping');
        } on Exception catch (_) {
          _handleDisconnect();
        }
      }
    });
  }

  /// 处理意外断开
  void _handleDisconnect() {
    _heartbeatTimer?.cancel();
    _subscription?.cancel();
    _channel = null;
    _updateState(WebSocketConnectionState.disconnected);
    _scheduleReconnect();
  }

  /// 指数退避重连
  void _scheduleReconnect({String? path, Map<String, String>? headers}) {
    if (_reconnectAttempt >= _maxReconnectAttempt) {
      _talker.error('WebSocket 重连失败，已达最大尝试次数 $_maxReconnectAttempt');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = Duration(seconds: 1 << _reconnectAttempt); // 1, 2, 4, 8, 16s
    _reconnectAttempt++;

    _talker.info('WebSocket 将在 ${delay.inSeconds}s 后重连 (第 $_reconnectAttempt 次)');
    _updateState(WebSocketConnectionState.reconnecting);

    _reconnectTimer = Timer(delay, () {
      connect(path: path, headers: headers);
    });
  }

  void _updateState(WebSocketConnectionState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  /// 销毁资源
  @disposeMethod
  Future<void> dispose() async {
    await disconnect();
    await _stateController.close();
    await _messageController.close();
  }
}
