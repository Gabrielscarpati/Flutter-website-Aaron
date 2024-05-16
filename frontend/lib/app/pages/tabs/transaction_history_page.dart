import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/log.dart';
import 'package:flutter_website_aaron/app/models/order.dart';
import 'package:flutter_website_aaron/app/pages/pages_controllers/tabs_controllers/transaction_history_page_controller.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';
import 'package:flutter_website_aaron/app/shared/user_controller.dart';

import '../../components/dialog_component.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  final _controller = TransactionHistoryPageController.instance;
  final _userController = UserController.instance;

  List<Order> orderList = List.empty(growable: true);
  List<Log> logList = List.empty(growable: true);
  bool sort = true;
  List<Order> filterData = [];
  bool _isLoading = true;
  bool _isAdmin = false;

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
    final isAdmin = await _userController.currentUserIsAdmin();

    setState(() {
      orderList = orders;
      _isAdmin = isAdmin;
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
      body: _isLoading
          ? const LoadingComponent()
          : SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 15, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              orderList = filterData
                                  .where(
                                    (element) =>
                                        element.id
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        element.expDte
                                            .toString()
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        element.sellerName
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) ||
                                        element.task
                                            .toLowerCase()
                                            .contains(value.toLowerCase()),
                                  )
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
                            hintText: "Search for a transaction",
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
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        padding: const EdgeInsets.all(12),
                        tooltip: 'Warnings',
                        onPressed: () {
                          _showDialogExpanded();
                        },
                        icon: const Icon(Icons.warning),
                        color: Colors.grey.shade600,
                        iconSize: 32,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.amber.shade100,
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Theme(
                      data: ThemeData.light()
                          .copyWith(cardColor: Theme.of(context).canvasColor),
                      child: PaginatedDataTable(
                        key: key,
                        showCheckboxColumn: false,
                        sortColumnIndex: 0,
                        sortAscending: sort,
                        source: RowSource<Order>(
                          dataList: orderList,
                          count: orderList.length,
                        ),
                        rowsPerPage: orderList.length > 8
                            ? 8
                            : orderList.isEmpty
                                ? 1
                                : orderList.length,
                        columnSpacing: 8,
                        columns: _getColumns(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  _dialogContent() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: SizedBox(
            width: double.infinity,
            child: Theme(
                data: ThemeData.light()
                    .copyWith(cardColor: Theme.of(context).canvasColor),
                child: PaginatedDataTable(
                  showCheckboxColumn: false,
                  sortColumnIndex: 0,
                  sortAscending: sort,
                  source: RowSource<Log>(
                    dataList: logList,
                    count: logList.length,
                    onTap: (data) {},
                  ),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    )),
                    DataColumn(
                        label: Text(
                      'ID',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
          ),
        ),
      ),
    );
  }

  _showDialogExpanded() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogComponent(
          title: 'Warnings',
          content: _dialogContent(),
        );
      },
    );
  }

  _getColumns() {
    final columns = [
      DataColumn(
        label: const Text(
          'Date/Time',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        onSort: ((columnIndex, ascending) {
          setState(() {
            sort = !sort;
            sortColumn(columnIndex, ascending);
          });
        }),
      ),
      const DataColumn(
          label: Text(
        'Order number',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      )),
      const DataColumn(
          label: Text(
        'Document',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      )),
      const DataColumn(
          label: Text(
        'Sent/Received',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      )),
    ];

    if (_isAdmin) {
      columns.insert(
        0,
        const DataColumn(
            label: Text(
          'Seller',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        )),
      );
      return columns;
    }

    return columns;
  }
}
