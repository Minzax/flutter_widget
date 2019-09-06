
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class MopTextField extends StatefulWidget {
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

  /// 键盘输入框颜色
  final Color bgColor;

  // 键盘输入框 标题
  final String label;

  final InputDecoration decoration;

  /// 聚焦事件
  final void Function() onFocus;

  /// 失焦事件
  final void Function() onBlur;

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
    this.label,
    this.bgColor,
  });

  @override
  _State createState() => _State();
}

class _State extends State<MopTextField> {
  bool obscureText = false;
  bool focusEn = false;
  bool showText = true;

  TextEditingController _controller = TextEditingController();

  Widget _buildMaterialDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

  void inputDialog(){
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: new GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: new Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: widget.bgColor,
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: <Widget>[
                          widget.label == null ? Container(height: 0.0)
                          : Container(
                            width: widget.label.length * 15.0,
                            child: Text(widget.label),
                          ),
                          Expanded(
                            flex: 1,
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
                            ),
                          )
                        ],
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        inputDialog();
      },
      child: Container(
        color: Colors.transparent,
        child: TextField(
          key: widget.key,
          obscureText: widget.obscureText,
          enabled: false,
          keyboardType: widget.keyboardType,
          textAlign: widget.textAlign,
          style: widget.style,
          autofocus: widget.autofocus,
          readOnly: widget.readOnly,
          maxLength: widget.maxLines,
          minLines: widget.minLines,
          decoration: widget.decoration,
          controller: _controller,
        ),
      )
    );
  }
}