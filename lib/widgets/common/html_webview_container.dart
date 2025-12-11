import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:oil_business_app/resources/colors.dart';
import 'package:oil_business_app/utils/sizer_utils.dart';
import 'package:oil_business_app/widgets/base/text/common_text.dart';

class HtmlWebViewContainer extends StatefulWidget {
  final String? htmlAssetPath;
  final String? url;
  final String? title;

  const HtmlWebViewContainer({
    Key? key,
    this.htmlAssetPath,
    this.url,
    this.title,
  }) : super(key: key);

  @override
  State<HtmlWebViewContainer> createState() => _HtmlWebViewContainerState();
}

class _HtmlWebViewContainerState extends State<HtmlWebViewContainer> {
  WebViewController? _controller;
  bool _isLoading = true;
  String? _errorMessage;
  String? _htmlContent;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _initializeController();
      if (widget.url != null) {
        _loadUrl();
      } else if (widget.htmlAssetPath != null) {
        _loadHtmlContent();
      }
    });
  }

  void _initializeController() {
    if (!mounted || _controller != null) return;
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(CustomAppColor.of(context).bgScaffold)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
            }
          },
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
          },
          onWebResourceError: (WebResourceError error) {
            if (mounted) {
              setState(() {
                _errorMessage = '加载失败：${error.description}';
                _isLoading = false;
              });
            }
          },
        ),
      );
  }

  Future<void> _loadHtmlContent() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final String htmlString =
          await rootBundle.loadString(widget.htmlAssetPath!);

      setState(() {
        _htmlContent = htmlString;
        _isLoading = false;
      });

      if (_controller != null && _htmlContent != null) {
        await _controller!.loadHtmlString(_htmlContent!);
      }
    } catch (e) {
      setState(() {
        _errorMessage = '加载失败：${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _loadUrl() {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    if (_controller != null && widget.url != null) {
      // 添加时间戳参数来禁用缓存，确保每次加载都是最新内容
      final uri = Uri.parse(widget.url!);
      final uriWithTimestamp = uri.replace(
        queryParameters: {
          ...uri.queryParameters,
          '_t': DateTime.now().millisecondsSinceEpoch.toString(),
        },
      );

      // 加载 URL，时间戳参数会强制浏览器不使用缓存
      _controller!.loadRequest(uriWithTimestamp);
    } else {
      setState(() {
        _errorMessage = 'WebView未初始化';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        appBar: AppBar(
          backgroundColor: CustomAppColor.of(context).bgTopBar,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: CustomAppColor.of(context).txtBlack),
          title: widget.title != null
              ? CommonText(
                  text: widget.title!,
                  fontSize: AppSizes.setFontSize(18),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtBlack,
                )
              : null,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: CustomAppColor.of(context).btnPurple,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: CustomAppColor.of(context).bgScaffold,
        appBar: AppBar(
          backgroundColor: CustomAppColor.of(context).bgTopBar,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: CustomAppColor.of(context).txtBlack),
          title: widget.title != null
              ? CommonText(
                  text: widget.title!,
                  fontSize: AppSizes.setFontSize(18),
                  fontWeight: FontWeight.w600,
                  textColor: CustomAppColor.of(context).txtBlack,
                )
              : null,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CommonText(
                text: _errorMessage!,
                fontSize: AppSizes.setFontSize(14),
                textColor: CustomAppColor.of(context).txtGrey,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSizes.setHeight(20)),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomAppColor.of(context).btnPurple,
                ),
                child: CommonText(
                  text: '返回',
                  fontSize: AppSizes.setFontSize(14),
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_controller == null) {
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: CustomAppColor.of(context).white,
      appBar: AppBar(
        backgroundColor: CustomAppColor.of(context).bgTopBar,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: CustomAppColor.of(context).txtBlack),
        title: widget.title != null
            ? CommonText(
                text: widget.title!,
                fontSize: AppSizes.setFontSize(18),
                fontWeight: FontWeight.w600,
                textColor: CustomAppColor.of(context).txtBlack,
              )
            : null,
      ),
      body: WebViewWidget(controller: _controller!),
    );
  }
}
