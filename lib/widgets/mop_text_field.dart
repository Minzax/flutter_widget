import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

/// 输入框组件
class MopTextField extends StatefulWidget {
  /// 可全局配置默认悬浮输入框样式
  static Decoration defalutInputDialogDecoration;

  /// 值
  final String value;

  /// 值改变事件
  final void Function(String value) onChanged;

  /// 是否密文
  final bool obscureText;

  /// 是否启用
  final bool enabled;

  /// 键值
  final Key key;

  /// 键盘类型
  final TextInputType keyboardType;

  final TextAlign textAlign;

  final TextStyle style;

  /// 自动聚焦
  final bool autofocus;

  final bool readOnly;

  final int maxLines;

  final int minLines;

  final InputDecoration decoration;

  /// 聚焦事件
  final void Function() onFocus;

  /// 失焦事件
  final void Function() onBlur;

  /// 悬浮输入框样式
  final Decoration inputDialogDecoration;

  MopTextField({
    this.key,
    this.value = '',
    this.onChanged,
    this.obscureText = false,
    this.enabled,
    this.keyboardType,
    this.textAlign = TextAlign.start,
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.decoration,
    this.onFocus,
    this.onBlur,
    this.inputDialogDecoration
  });

  @override
  _State createState() => _State();
}

class _State extends State<MopTextField> {

  FocusNode _focusNode = FocusNode();

  TextEditingController _controller = TextEditingController();

  bool _dialogVisible;

  @override
  void initState() {
    /// 焦点侦听事件
    _focusNode.addListener(() {
      /// 聚焦状态
      if(_focusNode.hasFocus) {
        if(widget.onFocus != null) widget.onFocus();
        /// 获取焦点时，弹窗悬浮输入框
        showInputDialog();
      } else {
        if(widget.onBlur != null) widget.onBlur();
      }
    });

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        if(!visible && _dialogVisible) {
          closeInputDialog();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _focusNode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: widget.key,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      textAlign: widget.textAlign,
      style: widget.style,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      maxLength: widget.maxLines,
      minLines: widget.minLines,
      decoration: widget.decoration,
      focusNode: _focusNode,
      controller: _controller,
    );
  }

  /// 关闭对话框
  void closeInputDialog() {
    Navigator.pop(context);
    _dialogVisible = false;
  }

  /// 展示对话框里头的输入框
  void showInputDialog() {
    _dialogVisible = true;
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: new GestureDetector(
                  onTap: closeInputDialog,
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: widget.inputDialogDecoration ?? MopTextField.defalutInputDialogDecoration ?? BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.black12
                        )
                      ),
                      child: TextField(
                        obscureText: widget.obscureText,
                        keyboardType: widget.keyboardType,
                        textAlign: widget.textAlign,
                        maxLength: widget.maxLines,
                        minLines: widget.minLines,
                        decoration: InputDecoration(
                          border: InputBorder.none
                        ),
                        autofocus: true,
                        onChanged: (value) {
                          if(widget.onChanged != null) widget.onChanged(value);
                          _controller.text = value;
                        },
                        /// 处理输入过程中光标不后移的情况
                        controller: TextEditingController.fromValue(
                          TextEditingValue(
                            text: widget.value,
                            selection: TextSelection.fromPosition(
                              TextPosition(
                                affinity: TextAffinity.downstream,
                                offset: widget.value.length
                              )
                            )
                          )
                        ),
                      )
                    )
                  ),
                ),
              );
            }
          ),
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: null,
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }
}

Widget _buildMaterialDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}