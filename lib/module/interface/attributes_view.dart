import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/attributes.dart';
import 'package:webdebugger_web_flutter/model/children.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

Widget _rowBorder(BuildContext context, Widget child) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border:
              Border(right: BorderSide(color: Theme.of(context).dividerColor))),
      child: child,
    );

class AttributesView extends StatefulWidget {
  Children children;
  List<Attributes> attributesList;

  AttributesView(
      {Key key, @required this.children, @required this.attributesList})
      : super(key: key);

  @override
  _AttributesState createState() => _AttributesState();
}

class _AttributesState extends State<AttributesView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.grey,
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor))),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: _rowBorder(
                      context,
                      Text(
                        "属性名称",
                        style: TextStyle(color: Colors.white),
                      ))),
              Expanded(
                  flex: 2,
                  child: _rowBorder(context,
                      Text("属性值", style: TextStyle(color: Colors.white)))),
              Expanded(
                  flex: 3,
                  child: _rowBorder(context,
                      Text("属性说明", style: TextStyle(color: Colors.white)))),
            ],
          ),
        ),
        Expanded(
            child: ListView(
          children: [
            Divider(height: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.attributesList
                  .map((e) => AttributesViewItem(
                      children: widget.children, attributes: e))
                  .toList(),
            )
          ],
        ))
      ],
    );
  }
}

class AttributesViewItem extends StatefulWidget {
  Children children;
  Attributes attributes;

  AttributesViewItem({Key key, this.children, this.attributes})
      : super(key: key);

  @override
  _AttributesViewItemState createState() => _AttributesViewItemState();
}

class _AttributesViewItemState extends State<AttributesViewItem> {
  TextEditingController _textEditingController;
  FocusNode _inputFocusNode;
  String _selectValue;

  /// 代表是个普通的属性
  final int _TYPE_NONE = 0;

  /// 代表是个标签
  final int _TYPE_LABEL = 1;

  // 输入类型为：字符串输入
  final int INPUT_TYPE_INPUT = 0;

  // 输入类型为：选择输入
  final int INPUT_TYPE_SELECT = 1;

  @override
  void initState() {
    _selectValue = widget.attributes.value;
    _inputFocusNode = FocusNode();
    _textEditingController =
        TextEditingController(text: widget.attributes.value);
    _textEditingController.addListener(() {
      if (_inputFocusNode.hasFocus) {
        _changeValue(_textEditingController.text);
      }
    });
    super.initState();
  }

  void _changeValue(String value) {
    ApiStore.instance
        .setAttributes(widget.children.id, widget.attributes.attributes, value);
  }

  @override
  Widget build(BuildContext context) {
    return widget.attributes.type == _TYPE_LABEL
        ? _buildAttributesTitle(context)
        : _buildAttributesItem(context);
  }

  Container _buildAttributesTitle(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      color: Theme.of(context).dividerColor.withAlpha(15),
      child: SelectableText(
        widget.attributes.attributes,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildAttributesItem(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: _rowBorder(
                  context, SelectableText(widget.attributes.attributes))),
          Expanded(
              flex: 2,
              child: _rowBorder(context, _buildAttributesValue(context))),
          Expanded(
              flex: 3,
              child: _rowBorder(
                  context, SelectableText(widget.attributes.description))),
        ],
      ),
    );
  }

  Widget _buildAttributesValue(BuildContext context) {
    if (widget.attributes.isEdit) {
      if (widget.attributes.inputType == INPUT_TYPE_INPUT) {
        return TextField(
          focusNode: _inputFocusNode,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          controller: _textEditingController,
          decoration: InputDecoration.collapsed(hintText: "").copyWith(
              contentPadding: EdgeInsets.all(8),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2))),
        );
      } else {
        return Row(
          children: [
            SelectableText(_selectValue),
            PopupMenuButton(
                onSelected: (select) {
                  _changeValue(select);
                  setState(() {
                    _selectValue = select;
                  });
                },
                offset: Offset(0, 40),
                padding: EdgeInsets.zero,
                itemBuilder: (context) => widget.attributes.selectOptions
                    .map((e) => PopupMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                    .toList())
          ],
        );
      }
    } else {
      return SelectableText(widget.attributes.value);
    }
  }
}
