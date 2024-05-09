import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/framwork/imodel.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class MemberPage extends StatefulWidget {
  const MemberPage({super.key});

  @override
  State<MemberPage> createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  List<DataTest> dataList = [
    DataTest(
        seller: 'Seller 1',
        contactName: 'Contact Name 1',
        phone: 'Phone 1',
        state: 'State 1',
        tradingPartners: 'Trading Partners 1',
        removed: 0),
    DataTest(
        seller: 'Seller 2',
        contactName: 'Contact Name 2',
        phone: 'Phone 2',
        state: 'State 2',
        tradingPartners: 'Trading Partners 2',
        removed: 0),
    DataTest(
        seller: 'Seller 3',
        contactName: 'Contact Name 3',
        phone: 'Phone 3',
        state: 'State 3',
        tradingPartners: 'Trading Partners 3',
        removed: 0),
    DataTest(
        seller: 'Seller 4',
        contactName: 'Contact Name 4',
        phone: 'Phone 4',
        state: 'State 4',
        tradingPartners: 'Trading Partners 4',
        removed: 0),
    DataTest(
        seller: 'Seller 5',
        contactName: 'Contact Name 5',
        phone: 'Phone 5',
        state: 'State 5',
        tradingPartners: 'Trading Partners 5',
        removed: 0),
  ];

  bool sort = true;
  List<DataTest>? filterData;

  final TextEditingController _searchController = TextEditingController();

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
    filterData = dataList;
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
                        .where((element) => element.seller.contains(value))
                        .toList();
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
                            dataList = filterData!
                                .where((element) => element.seller.contains(""))
                                .toList();
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
                      sortColumnIndex: 0,
                      sortAscending: sort,
                      source:
                          RowSource<DataTest>(dataList: dataList, count: dataList.length),
                      rowsPerPage: dataList.isEmpty ? 1 : dataList.length,
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
}

class DataTest implements IModel {
  final String seller;
  final String contactName;
  final String phone;
  final String state;
  final String tradingPartners;
  final int removed;

  DataTest(
      {required this.seller,
      required this.contactName,
      required this.phone,
      required this.state,
      required this.tradingPartners,
      required this.removed});

  @override
  Map<String, dynamic> toJson() {
    return {
      'seller': seller,
      'contactName': contactName,
      'phone': phone,
      'state': state,
      'tradingPartners': tradingPartners,
      'removed': removed,
    };
  }
}
