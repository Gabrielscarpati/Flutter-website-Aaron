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
  List<Order> filterData = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  final key = GlobalKey<PaginatedDataTableState>();

  sortColumn(int columnIndex, bool ascending) {
    if (ascending) {
      orderList.sort((a, b) => a.id.compareTo(b.id));
    } else {
      orderList.sort((a, b) => b.id.compareTo(a.id));
    }
  }

  _getOrders() async {
    final orders = await _controller.getOrders();
    final logs = await _controller.getLogs();

    setState(() {
      orderList = orders;
      logList = logs;
      filterData = orders;
      _isLoading = false;
    });
  }

  @override
  void initState() {
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
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(right: 15, top: 15),
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            _showDialogExpanded();
                          },
                          child: Tooltip(
                            message: 'Warnings',
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                color: AppColors.tertiaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: const Icon(
                                Icons.warning,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.only(
                              right: 15.0, left: 15, top: 5),
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
                                    orderList = filterData
                                        .where((element) => element.id
                                            .toString()
                                            .contains(value))
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
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.black),
                                          onPressed: () async {
                                            setState(() {
                                              _searchController.clear();
                                              orderList = filterData;
                                            });
                                          })
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: Theme(
                                    data: ThemeData.light().copyWith(
                                        cardColor:
                                            Theme.of(context).canvasColor),
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
                                                sortColumn(
                                                    columnIndex, ascending);
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
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }

  _dialogContent() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
                onPressed: Navigator.of(context).pop,
                icon: const Icon(Icons.close)),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                  data: ThemeData.light()
                      .copyWith(cardColor: Theme.of(context).canvasColor),
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
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                          label: Text(
                        'Task Description',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                      DataColumn(
                          label: Text(
                        'ID',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                      DataColumn(
                          label: Center(
                        child: Text(
                          'Error',
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
    );
  }

  _showDialogExpanded() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _dialogContent(),
              ],
            ),
          ),
        );
      },
    );
  }
}
