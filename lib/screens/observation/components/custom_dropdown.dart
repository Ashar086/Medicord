import 'package:brainmri/screens/user/user_reducer.dart';
import 'package:brainmri/store/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';


class CustomDropdownWithSearch extends StatefulWidget {
  final List<Map<String, String>> items;
  final String itemName;
  final int dState;

  const CustomDropdownWithSearch({
    Key? key,
    required this.items,
    required this.itemName,
    required this.dState,
  }) : super(key: key);

  @override
  _CustomDropdownWithSearchState createState() => _CustomDropdownWithSearchState();
}

class _CustomDropdownWithSearchState extends State<CustomDropdownWithSearch> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  
  Map<String, String> selected = {};

  @override
  Widget build(BuildContext context) {
    return StoreConnector<GlobalState, UserState>(
      converter: (appState) => appState.state.appState.userState,
      builder: (context, userState) {
        return GestureDetector(
          onTap: () => _showItemsList(context),
          child: AbsorbPointer(
            child: Padding(padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                controller: TextEditingController(text: selected['name'] ?? ''),
                decoration: InputDecoration(
                  labelText: widget.itemName,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showItemsList(BuildContext context) {
    List<String> filteredItems = widget.items.map((e) => e['name']!).toList();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchController.text.isNotEmpty 
                        ? IconButton(
                            onPressed: () {
                              searchController.clear();
                              filteredItems = widget.items.map((e) => e['name']!).toList();
                              (context as Element).markNeedsBuild();

                              setState(() {
                                selected = {};
                              });
                            },
                            icon: Icon(Icons.clear) 
                          )
                        : null,
                    ),
                    onChanged: (String value) {
                      filteredItems = (widget.items.map((e) => e['name']!).toList() ?? []).where((item) {
                        final itemLower = item.toLowerCase();
                        final searchLower = value.toLowerCase();
                        return itemLower.contains(searchLower);
                      }).toList();
                      (context as Element).markNeedsBuild();
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            searchController.text = item;
                            selected = {'id': widget.items.firstWhere((element) => element['name'] == item)['id']!, 'name': item};
                            print('selected: $selected');
                            StoreProvider.of<GlobalState>(context).dispatch(SelectPatientAction({'id': widget.items.firstWhere((element) => element['name'] == item)['id']!, 'name': item}));
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}