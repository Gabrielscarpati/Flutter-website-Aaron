import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/seller.dart';
import 'package:flutter_website_aaron/app/pages/tabs/tabs_controllers/member_page_controller.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  final _controller = MemberPageController.instance;

  List<Seller> dataList = List.empty(growable: true);

  bool sort = true;
  List<Seller>? filterData;

  final TextEditingController _searchController = TextEditingController();

  final key = GlobalKey<PaginatedDataTableState>();

  sortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.seller.compareTo(b.seller));
      } else {
        filterData!.sort((a, b) => b.seller.compareTo(a.seller));
      }
    }
  }

  @override
  void initState() {
    _getSelers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppComponents.appBar(const Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            AppNames.appName,
            style: TextStyle(
                fontSize: Fonts.titleShortcuts, color: AppColors.whiteColor),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.dashboard,
              color: AppColors.whiteColor,
            ),
          )
        ],
      )),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    dataList = filterData!
                        .where((element) => element.seller
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                    key.currentState!.pageTo(0);
                  });
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.secondaryColor.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Search for a Seller",
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.black,
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () async {
                          _searchController.clear();
                          setState(() {
                            _getSelers();
                          });
                        })),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Theme(
                    data: ThemeData.light()
                        .copyWith(cardColor: Theme.of(context).canvasColor),
                    child: PaginatedDataTable(
                      key: key,
                      sortColumnIndex: 0,
                      sortAscending: sort,
                      source: RowSource<Seller>(
                          dataList: dataList, count: dataList.length),
                      rowsPerPage: dataList.length > 10
                          ? 10
                          : dataList.isEmpty
                              ? 1
                              : dataList.length,
                      columnSpacing: 8,
                      columns: [
                        DataColumn(
                            label: const Text(
                              'Seller',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            onSort: ((columnIndex, ascending) {
                              setState(() {
                                sort = !sort;
                                sortColumn(columnIndex, ascending);
                              });
                            })),
                        const DataColumn(
                            label: Text(
                          'Contact Name',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        )),
                        const DataColumn(
                            label: Text(
                          'Phone',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        )),
                        const DataColumn(
                            label: Text(
                          'State',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        )),
                        const DataColumn(
                            label: Center(
                          child: Text(
                            'Trading Partners',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        )),
                        const DataColumn(
                            label: Center(
                          child: Text(
                            'Removed',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        )),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getSelers() {
    _controller.getSellers().then((value) {
      setState(() {
        dataList = value;
        filterData = value;
      });
    });
  }
}
