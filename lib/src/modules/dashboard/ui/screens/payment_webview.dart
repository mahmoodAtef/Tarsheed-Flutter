import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;

  const PaymentWebView({
    super.key,
    required this.url,
  });

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => _setLoadingState(true),
          onPageFinished: (_) => _setLoadingState(false),
          onWebResourceError: (error) => _handleWebViewError(error),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  void _setLoadingState(bool loading) {
    if (mounted) {
      setState(() => _isLoading = loading);
    }
  }

  void _handleWebViewError(WebResourceError error) {
    if (mounted) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildBody(theme),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      title: Text(
        S.of(context).payBills,
        style: theme.appBarTheme.titleTextStyle,
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      centerTitle: theme.appBarTheme.centerTitle,
      leading: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.arrow_back,
          color: theme.appBarTheme.iconTheme?.color,
          size: theme.appBarTheme.iconTheme?.size ?? 24.sp,
        ),
      ),
      actions: [
        IconButton(
          onPressed: _refreshWebView,
          icon: Icon(
            Icons.refresh,
            color: theme.appBarTheme.iconTheme?.color,
            size: theme.appBarTheme.iconTheme?.size ?? 24.sp,
          ),
          tooltip: S.of(context).refresh,
        ),
      ],
    );
  }

  Widget _buildBody(ThemeData theme) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading) _buildLoadingIndicator(theme),
      ],
    );
  }

  Widget _buildLoadingIndicator(ThemeData theme) {
    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: theme.progressIndicatorTheme.color,
            ),
          ],
        ),
      ),
    );
  }

  void _refreshWebView() {
    _controller.reload();
  }
}
