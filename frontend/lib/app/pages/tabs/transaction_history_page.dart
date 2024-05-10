import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/log.dart';
import 'package:flutter_website_aaron/app/models/order.dart';
import 'package:flutter_website_aaron/app/pages/pages_controllers/tabs_controllers/transaction_history_page_controller.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final _controller = TransactionHistoryPageController.instance;

  List<Order> orderList = List.empty(growable: true);
  List<Log> logList = List.empty(growable: true);
  bool sort = true;
  List<Order>? filterData;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  final key = GlobalKey<PaginatedDataTableState>();

  sortColumn(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        filterData!.sort((a, b) => a.id.compareTo(b.id));
      } else {
        filterData!.sort((a, b) => b.id.compareTo(a.id));
      }
    }
  }

  _getOrders() {
    _controller.getOrders().then((value) {
      setState(() {
        orderList = value;
        filterData = value;
        _isLoading = false;
      });
    });
  }

  _getLogs() {
    _controller.getLogs().then((value) {
      setState(() {
        logList = value;
      });
    });
  }

  @override
  void initState() {
    _getLogs();
    _getOrders();
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
      body: _isLoading
          ? const LoadingComponent()
          : SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                orderList = filterData!
                                    .where((element) =>
                                        element.id.toString().contains(value))
                                    .toList();
                                key.currentState!.pageTo(0);
                              });
                            },
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                filled: true,
                                fillColor:
                                    AppColors.secondaryColor.withOpacity(0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "Search for a Order number",
                                prefixIcon: const Icon(Icons.search),
                                prefixIconColor: Colors.black,
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.black),
                                    onPressed: () async {
                                      _searchController.clear();
                                      setState(() {
                                        _getOrders();
                                      });
                                    })),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: Theme(
                                data: ThemeData.light().copyWith(
                                    cardColor: Theme.of(context).canvasColor),
                                child: PaginatedDataTable(
                                  key: key,
                                  sortColumnIndex: 0,
                                  sortAscending: sort,
                                  source: RowSource(
                                      dataList: orderList,
                                      count: orderList.length),
                                  rowsPerPage: orderList.length > 10
                                      ? 10
                                      : orderList.isEmpty
                                          ? 1
                                          : orderList.length,
                                  columnSpacing: 8,
                                  columns: [
                                    DataColumn(
                                        label: const Text(
                                          'Date/Time',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
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
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )),
                                    const DataColumn(
                                        label: Text(
                                      'Document',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )),
                                    const DataColumn(
                                        label: Text(
                                      'Sent/Received',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )),
                                    const DataColumn(
                                        label: Center(
                                      child: Text(
                                        '997',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    )),
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: const Text(
                              'WARNINGS',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Theme(
                                data: ThemeData.light().copyWith(
                                    cardColor: Theme.of(context).canvasColor),
                                child: PaginatedDataTable(
                                  sortColumnIndex: 0,
                                  sortAscending: sort,
                                  source: RowSource<Log>(
                                      dataList: logList, count: logList.length),
                                  rowsPerPage: logList.length > 10
                                      ? 10
                                      : logList.isEmpty
                                          ? 1
                                          : logList.length,
                                  columnSpacing: 8,
                                  columns: const [
                                    DataColumn(
                                      label: Text(
                                        'Date',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
                                    DataColumn(
                                        label: Text(
                                      'Task Description',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'ID',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )),
                                    DataColumn(
                                        label: Center(
                                      child: Text(
                                        'Error',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    )),
                                  ],
                                )),
                          )
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
