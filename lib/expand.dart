import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'main.dart';
import 'module.dart';

class Expand extends StatelessWidget {
  final isExpand;
  Module selectModule;
  ValueChanged<Module> onSelectModule;

  Expand(
      {Key key,
      @required this.selectModule,
      this.isExpand = false,
      @required this.onSelectModule})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);
    return AnimatedContainer(
      duration: duration,
      width: isExpand ? 250 : 60,
      child: ListView(
        children: moduleList
            .map((e) => ListTile(
                  leading: Tooltip(
                    message: e.title,
                    child: Icon(e.iconData),
                  ),
                  title: AnimatedCrossFade(
                    firstChild: Text(
                      e.title,
                      maxLines: 1,
                    ),
                    secondChild: Container(),
                    duration: duration,
                    crossFadeState: isExpand
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                  ),
                  selected: e == selectModule,
                  onTap: () {
                    onSelectModule(e);
                  },
                ))
            .toList(),
      ),
    );
  }
}
