
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
  });

  @override
  _State createState() => _State();
}

class _State extends State<MopTextField> {
  bool obscureText = false;
  bool focusEn = false;
  bool showText = true;
  FocusNode focusNode = FocusNode();

  bool showMask = false;

  @override
  void initState() {
    /// 焦点侦听事件
    focusNode.addListener(() {
      /// 聚焦状态
      if(focusNode.hasFocus) {
        if(widget.onFocus != null) widget.onFocus();
        setState(() {
          showMask = true;
        });
      } else {
        if(widget.onBlur != null) widget.onBlur();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    focusNode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // MediaQueryData m = MediaQuery.of(context);
    RenderBox renderBox = context.findRenderObject();
    Offset offset = renderBox?.localToGlobal(Offset.zero);
    print(showMask);

    return new Stack(
      alignment: FractionalOffset(0.0, 0.0),
      // fit: StackFit.expand,
      overflow: Overflow.visible,
      children: <Widget>[
        TextField(
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
          focusNode: focusNode,

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
          onChanged: (value) {
            if(widget.onChanged != null) widget.onChanged(value);
          },
        ),

        showMask
        ? Positioned(
          left: (offset?.dx ?? 0) * -1,
          top: (offset?.dy ?? 0) * -1,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              setState(() {
                showMask = false;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.red,
            ),
          ),
        ) : Container()
      ],
    );
  }
}