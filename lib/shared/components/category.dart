import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:kuemele/shared/components/size.dart';
import 'package:kuemele/core/extensions/context_extensions.dart';

import 'app_colors.dart';
import 'icons.dart';

class RACategory extends StatefulWidget {
  final List<String> categories;
  final String selectedCategory;
  final Color? bgColor;
  final Color? textColor;
  final Function(String) onChanged;
  final Size size;
  final String? hintText;
  final Color? borderColors;
  final GlobalKey globalKey;
  final TextAlign? textAlignt;

  const RACategory({
    super.key,
    required this.categories,
    required this.selectedCategory,
    this.bgColor,
    this.textColor,
    required this.onChanged,
    this.size = const Size(100, 50),
    this.hintText,
    this.borderColors,
    required this.globalKey,
    this.textAlignt,
  });

  @override
  _RACategoryState createState() => _RACategoryState();
}

class _RACategoryState extends State<RACategory> {
  double categoryPositionY = 0.0;
  double containerHeight = 0.0;
  late RenderBox renderBox;
  late final ValueNotifier<String> _valueListenable;

  @override
  void initState() {
    super.initState();
    _valueListenable = ValueNotifier(widget.selectedCategory);
  }

  @override
  void didUpdateWidget(RACategory oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _valueListenable.value = widget.selectedCategory;
    }
  }

  @override
  void dispose() {
    _valueListenable.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    widget.hintText ?? '',
                    style: context.textTheme.bodyLarge.copyWith(fontSize: 15, color: widget.textColor ?? ColorSet.txtFieldFontColor),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            items: widget.categories.map((String category) {
              return DropdownItem<String>(
                value: category,
                height: size(40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        category,
                        style: context.textTheme.bodyLarge.copyWith(fontSize: 15, color: widget.textColor ?? ColorSet.txtFieldFontColor),
                        textAlign: widget.textAlignt ?? TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            valueListenable: _valueListenable,
            onChanged: (String? newValue) {
              if (newValue != null) {
                _valueListenable.value = newValue;
                widget.onChanged(newValue);
              }
            },
            buttonStyleData: ButtonStyleData(
              height: widget.size.height,
              width: widget.size.width,
              overlayColor:
                  WidgetStateProperty.all<Color>(ColorSet.revertBgColor),
              padding: EdgeInsets.only(left: 10, right: sizeW(0)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size(8)),
                border: Border.all(
                  color: widget.borderColors ?? Colors.transparent,
                ),
                color: widget.bgColor ?? ColorSet.txtFieldFillColor,
              ),
              elevation: 0,
            ),
            iconStyleData: IconStyleData(
              icon: Image.asset(
                IconSet.dropDownIcon,
                width: sizeW(13),
                height: size(40),
              ),
              iconEnabledColor: Colors.yellow,
              iconDisabledColor: Colors.grey,
            ),
            dropdownStyleData: DropdownStyleData(
              isOverButton: false,
              maxHeight: heightGen(),
              width: widthGen(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size(15)),
                color:
                    Colors.white, // Set dropdown menu background color to white
              ),
              offset: Offset(size(0.0), size(0.0)),
              scrollbarTheme: ScrollbarThemeData(
                radius: Radius.circular(size(8.68)),
                thickness: WidgetStateProperty.all<double>(size(0)),
                thumbVisibility: WidgetStateProperty.all<bool>(false),
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              overlayColor:
                  WidgetStateProperty.all<Color>(ColorSet.revertBgColor),
              padding: EdgeInsets.only(
                left: sizeW(14),
                right: sizeW(10),
              ),
            ),
          ),
        );
      },
    );
  }

  double heightGen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          RenderBox renderBox =
              widget.globalKey.currentContext!.findRenderObject() as RenderBox;
          categoryPositionY = renderBox.localToGlobal(Offset.zero).dy;
          containerHeight = renderBox.size.height;
        });
      }
    });
    double screenHeight = MediaQuery.of(context).size.height;
    return screenHeight - (categoryPositionY + containerHeight);
  }

  double widthGen() {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            renderBox = widget.globalKey.currentContext!.findRenderObject()
                as RenderBox;
          });
        }
      });
      return renderBox.size.width;
    } catch (e) {
      return size(100);
    }
  }
}
