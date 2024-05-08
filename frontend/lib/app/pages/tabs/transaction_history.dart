import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class TransactionHistory extends StatefulWidget {
  const TransactionHistory({super.key});

  @override
  State<TransactionHistory> createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> {
  List<DataTest> dataList = [
    DataTest(
        date: 'Date 1',
        numberOrder: 1,
        document: 1,
        sendReceived: 'Send Received 1',
        status: 'Status 1'),
    DataTest(
        date: 'Date 2',
        numberOrder: 2,
        document: 2,
        sendReceived: 'Send Received 2',
        status: 'Status 2'),
    DataTest(
        date: 'Date 3',
        numberOrder: 3,
        document: 3,
        sendReceived: 'Send Received 3',
        status: 'Status 3'),
    DataTest(
        date: 'Date 4',
        numberOrder: 4,
        document: 4,
        sendReceived: 'Send Received 4',
        status: 'Status 4'),
    DataTest(
        date: 'Date 5',
        numberOrder: 5,
        document: 5,
        sendReceived: 'Send Received 5',
        status: 'Status 5'),
  ];

  bool sort = true;
  List<DataTest>? filterData;

  final TextEditingController _searchController = TextEditingController();

  sortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.numberOrder.compareTo(b.numberOrder));
      } else {
        filterData!.sort((a, b) => b.numberOrder.compareTo(a.numberOrder));
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
                        .where((element) => element.numberOrder.toString().contains(value))
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
                                .where((element) => element.numberOrder.toString().contains(""))
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
                          RowSource(dataList: dataList, count: dataList.length),
                      rowsPerPage: dataList.isEmpty ? 1 : dataList.length,
                      columnSpacing: 8,
                      columns: [
                        DataColumn(
                            label: const Text(
                              'Date/Time',
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
                          'Order number',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        )),
                        const DataColumn(
                            label: Text(
                          'Document',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        )),
                        const DataColumn(
                            label: Text(
                          'Sent/Received',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        )),
                        const DataColumn(
                            label: Center(
                          child: Text(
                            '997',
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

class RowSource extends DataTableSource {
  var dataList;
  final count;
  RowSource({
    required this.dataList,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(dataList[index]);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  return DataRow(cells: [
    DataCell(Text(data.date)),
    DataCell(Text(data.numberOrder.toString())),
    DataCell(Text(data.document.toString())),
    DataCell(Text(data.sendReceived)),
    DataCell(Text(data.status)),
  ]);
}

class DataTest {
  final String date;
  final int numberOrder;
  final int document;
  final String sendReceived;
  final String status;

  DataTest({
    required this.date,
    required this.numberOrder,
    required this.document,
    required this.sendReceived,
    required this.status,
  });
}