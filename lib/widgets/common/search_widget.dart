import 'package:flutter/material.dart';
import 'package:lottery_app/utils/hex_color.dart';
import 'package:lottery_app/utils/pt.dart';

class SearchWidget extends StatefulWidget {
  final bool showCategory;
  final bool showInput;
  final List<String>? categories;
  final String defaultCategory;
  final String defaultSearch;
  final Function(String, String) onSearch;

  const SearchWidget({
    super.key,
    this.showCategory = true,
    this.showInput = true,
    this.categories,
    this.defaultCategory = 'All',
    this.defaultSearch = '',
    required this.onSearch,
  });

  @override
  State<StatefulWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  late List<String> _categories;
  late String _categoryValue;
  late String _searchValue;

  @override
  void initState() {
    List<String> list = ['All'];
    list.addAll(widget.categories ?? []);

    setState(() {
      _categories = list;
      _categoryValue = widget.defaultCategory;
      _searchValue = widget.defaultSearch;
    });
    super.initState();
  }

  void onChangeCategory(categoryValue) {
    setState(() {
      _categoryValue = categoryValue;
    });

    onSearch(categoryValue, _searchValue);
  }

  void onChangeSearch(searchValue) {
    setState(() {
      _searchValue = searchValue;
    });
  }

  void onSearch(categoryValue, searchValue) {
    String cValue = categoryValue ?? _categoryValue;
    String sValue = searchValue ?? _searchValue;
    widget.onSearch(cValue == 'All' ? '' : cValue, sValue);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SizedBox(
        height: pt(36),
        width: double.infinity,
        child: Row(
          children: [
            if (widget.showCategory)
              SizedBox(
                width: pt(100),
                child: PopupMenuButton(
                  position: PopupMenuPosition.under,
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  onSelected: (value) {
                    onChangeCategory(value);
                  },
                  itemBuilder: (context) {
                    return _categories.map((text) {
                      int index = _categories.indexOf(text);
                      return PopupMenuItem(
                        value: text,
                        height: pt(33),
                        padding: EdgeInsets.symmetric(horizontal: pt(10)),
                        child: Center(
                          child: Container(
                            width: pt(105),
                            height: pt(33),
                            decoration: index >= _categories.length - 1
                                ? null
                                : const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(color: Colors.white),
                                    ),
                                  ),
                            child: Center(
                                child: Text(
                              text,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: pt(13),
                              ),
                            )),
                          ),
                        ),
                      );
                    }).toList();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _categoryValue == '' ? 'All' : _categoryValue,
                        style: TextStyle(
                          fontSize: pt(14),
                          color: HexColor('##151515'),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (widget.showInput)
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: HexColor('#ffffff'),
                    borderRadius: BorderRadius.circular(pt(8)),
                    border: Border.all(color: HexColor('#ededed')),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlign: TextAlign.left,
                          cursorColor: HexColor('#0082ff'),
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: pt(14),
                            color: HexColor('#333333'),
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: pt(14)),
                            hintText: 'Search',
                            hintStyle: TextStyle(color: HexColor('##ededed')),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(pt(8)),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: HexColor('#ffffff'),
                          ),
                          onChanged: (value) {
                            onChangeSearch(value);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
