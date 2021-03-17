import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:webdebugger_web_flutter/model/attributes.dart';
import 'package:webdebugger_web_flutter/model/children.dart';
import 'package:webdebugger_web_flutter/net/api_store.dart';

/// 构建每行属性Widget的边框
Widget _buildRowBorderWidget(BuildContext context, Widget child) => Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border:
              Border(right: BorderSide(color: Theme.of(context).dividerColor))),
      child: child,
    );

/// 展示属性列表的widget
class AttributesView extends StatefulWidget {
  /// 当前选中的节点
  final Children children;

  /// 节点的属性列表
  final List<Attributes> attributesList;

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
        // 属性表格的标题
        DecoratedBox(
          decoration: BoxDecoration(
              color: Colors.grey,
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor))),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: _buildRowBorderWidget(
                      context,
                      Text(
                        "属性名称",
                        style: TextStyle(color: Colors.white),
                      ))),
              Expanded(
                  flex: 2,
                  child: _buildRowBorderWidget(context,
                      Text("属性值", style: TextStyle(color: Colors.white)))),
              Expanded(
                  flex: 3,
                  child: _buildRowBorderWidget(context,
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

/// 每个属性的widget
class AttributesViewItem extends StatefulWidget {
  /// 选中的节点
  final Children children;

  /// 属性信息
  final Attributes attributes;

  AttributesViewItem({Key key, this.children, this.attributes})
      : super(key: key);

  @override
  _AttributesViewItemState createState() => _AttributesViewItemState();
}

class _AttributesViewItemState extends State<AttributesViewItem> {
  /// 当属性的输入类型为输入框时，属性编辑框的控制器
  TextEditingController _textEditingController;

  /// 当属性的输入类型为输入框时，属性编辑框的焦点
  FocusNode _inputFocusNode;

  /// 当属性的输入类型为选择输入的时候，此刻选择的值
  String _selectValue;

  /// 属性类型：代表是个普通的属性
  final int _TYPE_NONE = 0;

  /// 属性类型：代表是个标签
  final int _TYPE_LABEL = 1;

  // 属性的输入类型为：字符串输入
  final int INPUT_TYPE_INPUT = 0;

  // 属性的输入类型为：选择输入
  final int INPUT_TYPE_SELECT = 1;

  @override
  void initState() {
    _selectValue = widget.attributes.value;
    _inputFocusNode = FocusNode();
    _textEditingController =
        TextEditingController(text: widget.attributes.value);
    _textEditingController.addListener(() {
      // 当属性的输入类型为输入框时，输入框脱离焦点就去提交改变
      if (_inputFocusNode.hasFocus) {
        _changeValue(_textEditingController.text);
      }
    });
    super.initState();
  }

  /// 掉接口改变属性的值
  void _changeValue(String value) {
    ApiStore.instance
        .setAttributes(widget.children.id, widget.attributes.attributes, value);
  }

  @override
  Widget build(BuildContext context) {
    return widget.attributes.type == _TYPE_LABEL
        ? _buildAttributesTitleWidget(context)
        : _buildAttributesItemWidget(context);
  }

  /// 属性表格中的分割组
  Container _buildAttributesTitleWidget(BuildContext context) {
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

  /// 属性表格中的属性列表
  Widget _buildAttributesItemWidget(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(color: Theme.of(context).dividerColor))),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: _buildRowBorderWidget(
                  context, SelectableText(widget.attributes.attributes))),
          Expanded(
              flex: 2,
              child: _buildRowBorderWidget(
                  context, _buildAttributesValueWidget(context))),
          Expanded(
              flex: 3,
              child: _buildRowBorderWidget(
                  context, SelectableText(widget.attributes.description))),
        ],
      ),
    );
  }

  /// 查看、编辑属性value的widget
  Widget _buildAttributesValueWidget(BuildContext context) {
    // isEdit：true为可以编辑的属性value，false：为不可编辑的属性value
    // 当isEdit=true时，inputType：0为输入框编辑，1为选择框编辑
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
        return DropdownButton<String>(
          value: _selectValue ?? "",
          items: widget.attributes.selectOptions
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (value) {
            _changeValue(value);
            setState(() {
              _selectValue = value;
            });
          },
        );
      }
    } else {
      return SelectableText(widget.attributes.value);
    }
  }
}
