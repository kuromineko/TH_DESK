// main window right pane

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hbb/common/widgets/connection_page_title.dart';
import 'package:flutter_hbb/consts.dart';
import 'package:flutter_hbb/desktop/widgets/popup_menu.dart';
import 'package:flutter_hbb/models/state_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_hbb/models/peer_model.dart';

import '../../common.dart';
import '../../common/formatter/id_formatter.dart';
import '../../common/widgets/peer_tab_page.dart';
import '../../common/widgets/autocomplete.dart';
import '../../models/platform_model.dart';
import '../../desktop/widgets/material_mod_popup_menu.dart' as mod_menu;

class OnlineStatusWidget extends StatefulWidget {
  const OnlineStatusWidget({Key? key, this.onSvcStatusChanged})
      : super(key: key);

  final VoidCallback? onSvcStatusChanged;

  @override
  State<OnlineStatusWidget> createState() => _OnlineStatusWidgetState();
}

/// State for the connection page.
class _OnlineStatusWidgetState extends State<OnlineStatusWidget> {
  final _svcStopped = Get.find<RxBool>(tag: 'stop-service');
  final _svcIsUsingPublicServer = true.obs;
  Timer? _updateTimer;

  double get em => 13.0;
  double? get height => bind.isIncomingOnly() ? null : 46.0;

  void onUsePublicServerGuide() {
    const url = "https://github.com/kuromineko/TH_DESK";
    canLaunchUrlString(url).then((can) {
      if (can) {
        launchUrlString(url);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _updateTimer = periodic_immediate(Duration(seconds: 1), () async {
      updateStatus();
    });
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isIncomingOnly = bind.isIncomingOnly();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    startServiceWidget() => Offstage(
          offstage: !_svcStopped.value,
          child: InkWell(
                  onTap: () async {
                    await start_service(true);
                  },
                  child: Text(translate("Start service"),
                      style: TextStyle(
                          color: const Color(0xFF38BDF8),
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          fontSize: em)))
              .marginOnly(left: em),
        );

    basicWidget() {
      final isReady = !_svcStopped.value &&
          stateGlobal.svcStatus.value == SvcStatus.ready;
      final isConnecting = _svcStopped.value ||
          stateGlobal.svcStatus.value == SvcStatus.connecting;

      final Color dotColor = isConnecting
          ? const Color(0xFFF59E0B)
          : (isReady ? const Color(0xFF10B981) : const Color(0xFFEF4444));

      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF171B26) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: dotColor.withOpacity(0.35),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: isIncomingOnly ? 200 : null,
                  child: _buildConnStatusMsg(dotColor),
                ),
              ],
            ),
          ).marginOnly(left: 14),
          if (!isIncomingOnly) startServiceWidget(),
          const Spacer(),
          if (!isIncomingOnly)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                "TH_DESK Network",
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ),
        ],
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131722) : const Color(0xFFF8FAFC),
      ),
      child: Obx(() => isIncomingOnly
          ? Column(
              children: [
                basicWidget(),
                Align(
                        child: startServiceWidget(),
                        alignment: Alignment.centerLeft)
                    .marginOnly(top: 2.0, left: 22.0),
              ],
            )
          : basicWidget()),
    ).paddingOnly(right: isIncomingOnly ? 8 : 0);
  }

  _buildConnStatusMsg(Color statusColor) {
    widget.onSvcStatusChanged?.call();
    return Text(
      _svcStopped.value
          ? translate("Service is not running")
          : stateGlobal.svcStatus.value == SvcStatus.connecting
              ? translate("connecting_status")
              : stateGlobal.svcStatus.value == SvcStatus.notReady
                  ? translate("not_ready_status")
                  : translate('Ready'),
      style: TextStyle(
        fontSize: em,
        fontWeight: FontWeight.w600,
        color: stateGlobal.svcStatus.value == SvcStatus.ready
            ? const Color(0xFF10B981)
            : null,
      ),
    );
  }

  updateStatus() async {
    final status =
        jsonDecode(await bind.mainGetConnectStatus()) as Map<String, dynamic>;
    final statusNum = status['status_num'] as int;
    if (statusNum == 0) {
      stateGlobal.svcStatus.value = SvcStatus.connecting;
    } else if (statusNum == -1) {
      stateGlobal.svcStatus.value = SvcStatus.notReady;
    } else if (statusNum == 1) {
      stateGlobal.svcStatus.value = SvcStatus.ready;
    } else {
      stateGlobal.svcStatus.value = SvcStatus.notReady;
    }
    _svcIsUsingPublicServer.value = await bind.mainIsUsingPublicServer();
    try {
      stateGlobal.videoConnCount.value = status['video_conn_count'] as int;
    } catch (_) {}
  }
}

/// Connection page for connecting to a remote peer.
class ConnectionPage extends StatefulWidget {
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

/// State for the connection page.
class _ConnectionPageState extends State<ConnectionPage>
    with SingleTickerProviderStateMixin, WindowListener {
  /// Controller for the id input bar.
  final _idController = IDTextEditingController();

  final RxBool _idInputFocused = false.obs;
  final FocusNode _idFocusNode = FocusNode();
  final TextEditingController _idEditingController = TextEditingController();

  String selectedConnectionType = 'Connect';

  bool isWindowMinimized = false;

  final AllPeersLoader _allPeersLoader = AllPeersLoader();

  Iterable<Peer> _autocompleteOpts = [];

  final _menuOpen = false.obs;

  @override
  void initState() {
    super.initState();
    _allPeersLoader.init(setState);
    _idFocusNode.addListener(onFocusChanged);
    if (_idController.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final lastRemoteId = await bind.mainGetLastRemoteId();
        if (lastRemoteId != _idController.id) {
          setState(() {
            _idController.id = lastRemoteId;
          });
        }
      });
    }
    Get.put<TextEditingController>(_idEditingController);
    Get.put<IDTextEditingController>(_idController);
    windowManager.addListener(this);
  }

  @override
  void dispose() {
    _idController.dispose();
    windowManager.removeListener(this);
    _allPeersLoader.clear();
    _idFocusNode.removeListener(onFocusChanged);
    _idFocusNode.dispose();
    _idEditingController.dispose();
    if (Get.isRegistered<IDTextEditingController>()) {
      Get.delete<IDTextEditingController>();
    }
    if (Get.isRegistered<TextEditingController>()) {
      Get.delete<TextEditingController>();
    }
    super.dispose();
  }

  @override
  void onWindowEvent(String eventName) {
    super.onWindowEvent(eventName);
    if (eventName == 'minimize') {
      isWindowMinimized = true;
    } else if (eventName == 'maximize' || eventName == 'restore') {
      if (isWindowMinimized && isWindows) {
        Get.forceAppUpdate();
      }
      isWindowMinimized = false;
    }
  }

  @override
  void onWindowEnterFullScreen() {
    stateGlobal.resizeEdgeSize.value = 0;
  }

  @override
  void onWindowLeaveFullScreen() {
    stateGlobal.resizeEdgeSize.value = stateGlobal.isMaximized.isTrue
        ? kMaximizeEdgeSize
        : windowResizeEdgeSize;
  }

  @override
  void onWindowClose() {
    super.onWindowClose();
    bind.mainOnMainWindowClose();
  }

  void onFocusChanged() {
    _idInputFocused.value = _idFocusNode.hasFocus;
    if (_idFocusNode.hasFocus) {
      if (_allPeersLoader.needLoad) {
        _allPeersLoader.getAllPeers();
      }

      final textLength = _idEditingController.value.text.length;
      _idEditingController.selection =
          TextSelection(baseOffset: 0, extentOffset: textLength);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOutgoingOnly = bind.isOutgoingOnly();
    return Column(
      children: [
        Expanded(
            child: Column(
          children: [
            Row(
              children: [
                Flexible(child: _buildRemoteIDTextField(context)),
              ],
            ).marginOnly(top: 18, right: 16),
            const SizedBox(height: 14),
            Divider(color: Theme.of(context).dividerColor, height: 1)
                .paddingOnly(right: 16),
            Expanded(child: PeerTabPage()),
          ],
        ).paddingOnly(left: 16.0)),
        if (!isOutgoingOnly)
          Divider(color: Theme.of(context).dividerColor, height: 1),
        if (!isOutgoingOnly) const OnlineStatusWidget()
      ],
    );
  }

  void onConnect(
      {bool isFileTransfer = false,
      bool isViewCamera = false,
      bool isTerminal = false,
      bool isTcpTunneling = false}) {
    var id = _idController.id;
    connect(context, id,
        isFileTransfer: isFileTransfer,
        isViewCamera: isViewCamera,
        isTerminal: isTerminal,
        isTcpTunneling: isTcpTunneling);
  }

  /// UI for the remote ID TextField (TH_DESK Modern Card Style).
  Widget _buildRemoteIDTextField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    var w = Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 420,
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF171B26) : Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(
              color: _idInputFocused.value
                  ? const Color(0xFF0071FF)
                  : (isDark
                      ? const Color(0xFF252B3B)
                      : const Color(0xFFE2E8F0)),
              width: _idInputFocused.value ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: _idInputFocused.value
                    ? const Color(0xFF0071FF).withOpacity(0.15)
                    : Colors.black.withOpacity(isDark ? 0.35 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Ink(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0071FF).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.desktop_windows_rounded,
                        size: 18,
                        color: Color(0xFF38BDF8),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: getConnectionPageTitle(context, false)),
                  ],
                ).marginOnly(bottom: 14),
                Row(
                  children: [
                    Expanded(
                        child: RawAutocomplete<Peer>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          _autocompleteOpts = const Iterable<Peer>.empty();
                        } else if (_allPeersLoader.peers.isEmpty &&
                            !_allPeersLoader.isPeersLoaded) {
                          Peer emptyPeer = Peer(
                            id: '',
                            username: '',
                            hostname: '',
                            alias: '',
                            platform: '',
                            tags: [],
                            hash: '',
                            password: '',
                            forceAlwaysRelay: false,
                            rdpPort: '',
                            rdpUsername: '',
                            loginName: '',
                            device_group_name: '',
                            note: '',
                          );
                          _autocompleteOpts = [emptyPeer];
                        } else {
                          String textWithoutSpaces =
                              textEditingValue.text.replaceAll(" ", "");
                          if (int.tryParse(textWithoutSpaces) != null) {
                            textEditingValue = TextEditingValue(
                              text: textWithoutSpaces,
                              selection: textEditingValue.selection,
                            );
                          }
                          String textToFind =
                              textEditingValue.text.toLowerCase();
                          _autocompleteOpts = _allPeersLoader.peers
                              .where((peer) =>
                                  peer.id.toLowerCase().contains(textToFind) ||
                                  peer.username
                                      .toLowerCase()
                                      .contains(textToFind) ||
                                  peer.hostname
                                      .toLowerCase()
                                      .contains(textToFind) ||
                                  peer.alias.toLowerCase().contains(textToFind))
                              .toList();
                          _allPeersLoader.queryOnlines(_autocompleteOpts);
                        }
                        return _autocompleteOpts;
                      },
                      focusNode: _idFocusNode,
                      textEditingController: _idEditingController,
                      fieldViewBuilder: (
                        BuildContext context,
                        TextEditingController fieldTextEditingController,
                        FocusNode fieldFocusNode,
                        VoidCallback onFieldSubmitted,
                      ) {
                        updateTextAndPreserveSelection(
                            fieldTextEditingController, _idController.text);
                        return Obx(() => TextField(
                              autocorrect: false,
                              enableSuggestions: false,
                              keyboardType: TextInputType.visiblePassword,
                              focusNode: fieldFocusNode,
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                                color: isDark
                                    ? const Color(0xFFF8FAFC)
                                    : const Color(0xFF0F172A),
                                height: 1.35,
                              ),
                              maxLines: 1,
                              cursorColor: const Color(0xFF38BDF8),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: isDark
                                      ? const Color(0xFF10131C)
                                      : const Color(0xFFF8FAFC),
                                  counterText: '',
                                  prefixIcon: Icon(
                                    Icons.tag_rounded,
                                    size: 20,
                                    color: _idInputFocused.value
                                        ? const Color(0xFF38BDF8)
                                        : const Color(0xFF64748B),
                                  ),
                                  hintText: _idInputFocused.value
                                      ? null
                                      : translate('Enter Remote ID'),
                                  hintStyle: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0.2,
                                    color: Color(0xFF64748B),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14)),
                              controller: fieldTextEditingController,
                              inputFormatters: [IDTextInputFormatter()],
                              onChanged: (v) {
                                _idController.id = v;
                              },
                              onSubmitted: (_) {
                                onConnect();
                              },
                            ).workaroundFreezeLinuxMint());
                      },
                      onSelected: (option) {
                        setState(() {
                          _idController.id = option.id;
                          FocusScope.of(context).unfocus();
                        });
                      },
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<Peer> onSelected,
                          Iterable<Peer> options) {
                        options = _autocompleteOpts;
                        double maxHeight = options.length * 50;
                        if (options.length == 1) {
                          maxHeight = 52;
                        } else if (options.length == 3) {
                          maxHeight = 146;
                        } else if (options.length == 4) {
                          maxHeight = 193;
                        }
                        maxHeight = maxHeight.clamp(0, 200);

                        return Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 10,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Material(
                                    elevation: 6,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxHeight: maxHeight,
                                        maxWidth: 374,
                                      ),
                                      child: _allPeersLoader.peers.isEmpty &&
                                              !_allPeersLoader.isPeersLoaded
                                          ? Container(
                                              height: 80,
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                ),
                                              ))
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: ListView(
                                                children: options
                                                    .map((peer) =>
                                                        AutocompletePeerTile(
                                                            onSelect: () =>
                                                                onSelected(
                                                                    peer),
                                                            peer: peer))
                                                    .toList(),
                                              ),
                                            ),
                                    ),
                                  ))),
                        );
                      },
                    )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    SizedBox(
                      height: 36.0,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0071FF),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: const Icon(Icons.bolt_rounded, size: 18),
                        onPressed: () {
                          onConnect();
                        },
                        label: Text(
                          translate("Connect"),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 36.0,
                      width: 36.0,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E2536)
                            : const Color(0xFFF1F5F9),
                        border: Border.all(
                            color: isDark
                                ? const Color(0xFF2A3042)
                                : const Color(0xFFCBD5E1)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: StatefulBuilder(
                          builder: (context, setState) {
                            var offset = Offset(0, 0);
                            return Obx(() => InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  child: _menuOpen.value
                                      ? Transform.rotate(
                                          angle: pi,
                                          child: Icon(IconFont.more, size: 15),
                                        )
                                      : Icon(IconFont.more, size: 15),
                                  onTapDown: (e) {
                                    offset = e.globalPosition;
                                  },
                                  onTap: () async {
                                    _menuOpen.value = true;
                                    final x = offset.dx;
                                    final y = offset.dy;
                                    await mod_menu
                                        .showMenu(
                                      context: context,
                                      position:
                                          RelativeRect.fromLTRB(x, y, x, y),
                                      items: [
                                        (
                                          'Transfer file',
                                          () => onConnect(isFileTransfer: true)
                                        ),
                                        (
                                          'View camera',
                                          () => onConnect(isViewCamera: true)
                                        ),
                                        (
                                          '${translate('Terminal')} (beta)',
                                          () => onConnect(isTerminal: true)
                                        ),
                                        if (isDesktop)
                                          (
                                            'TCP tunneling',
                                            () =>
                                                onConnect(isTcpTunneling: true)
                                          ),
                                      ]
                                          .map((e) => MenuEntryButton<String>(
                                                childBuilder:
                                                    (TextStyle? style) => Text(
                                                  translate(e.$1),
                                                  style: style,
                                                ),
                                                proc: () => e.$2(),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        kDesktopMenuPadding
                                                            .left),
                                                dismissOnClicked: true,
                                              ))
                                          .map((e) => e.build(
                                              context,
                                              const MenuConfig(
                                                  commonColor:
                                                      CustomPopupMenuTheme
                                                          .commonColor,
                                                  height: CustomPopupMenuTheme
                                                      .height,
                                                  dividerHeight:
                                                      CustomPopupMenuTheme
                                                          .dividerHeight)))
                                          .expand((i) => i)
                                          .toList(),
                                      elevation: 8,
                                    )
                                        .then((_) {
                                      _menuOpen.value = false;
                                    });
                                  },
                                ));
                          },
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ));
    return Container(
        constraints: const BoxConstraints(maxWidth: 620), child: w);
  }
}