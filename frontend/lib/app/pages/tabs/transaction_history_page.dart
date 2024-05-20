import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/log.dart';
import 'package:flutter_website_aaron/app/models/task.dart';
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

  List<Task> taskList = List.empty(growable: true);
  List<Task> filteredTaskList = List.empty(growable: true);
  List<Log> logList = List.empty(growable: true);

  bool sortAscending = false;
  bool sortLogAscending = false;
  bool _isLoading = true;
  bool _isAdmin = false;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _logSearchController = TextEditingController();

  final key = GlobalKey<PaginatedDataTableState>();
  final logKey = GlobalKey<PaginatedDataTableState>();

  _getOrders() async {
    final orders = await _controller.getTasks();
    final logs = await _controller.getLogs();
    final isAdmin = await _userController.currentUserIsAdmin();
    final currentUser = await _userController.getCurrentUser();

    setState(() {
      taskList = orders;
      filteredTaskList = orders;
      logList = isAdmin
          ? logs
          : logs.where((log) => currentUser.sellerId == log.sellerId).toList();
      _isAdmin = isAdmin;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _getOrders();
    super.initState();
  }

  _filterTasks(String value) {
    setState(() {
      filteredTaskList = taskList
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
                element.description
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.buyerId
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.buyerName.toLowerCase().contains(value.toLowerCase()),
          )
          .toList();
      key.currentState?.pageTo(0);
    });
  }

  void _sortColumn(int columnIndex, bool ascending) {
    setState(() {
      sortAscending = ascending;
      if (ascending) {
        filteredTaskList.sort((a, b) => a.id.compareTo(b.id));
      } else {
        filteredTaskList.sort((a, b) => b.id.compareTo(a.id));
      }
    });
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
                          onChanged: (value) => _filterTasks(value),
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
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        filteredTaskList = taskList;
                                      });
                                    },
                                  )
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
                        sortColumnIndex: _isAdmin ? 1 : 0,
                        sortAscending: sortAscending,
                        source: RowSource<Task>(
                          dataList: filteredTaskList,
                          count: filteredTaskList.length,
                          onTap: (task) {
                            _showDialogExpanded(task: task);
                          },
                        ),
                        rowsPerPage: filteredTaskList.length > 8
                            ? 8
                            : filteredTaskList.isEmpty
                                ? 1
                                : filteredTaskList.length,
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

  _dialogContent({int? taskId}) {
    List<Log> logListToShow = logList;

    if (taskId != null) {
      logListToShow =
          logList.where((element) => element.taskId == taskId).toList();
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _logSearchController,
                    onChanged: (value) {
                      setState(() {
                        logListToShow = logList
                            .where(
                              (element) =>
                                  element.date
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.taskDescription
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.id
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.buyerId
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.buyerName
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.error
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                            )
                            .toList();
                        logKey.currentState?.pageTo(0);
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
                      hintText: "Search in logs",
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.black,
                      suffixIcon: _logSearchController.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  _logSearchController.clear();
                                  if (taskId != null) {
                                    logListToShow = logList
                                        .where((element) =>
                                            element.taskId == taskId)
                                        .toList();
                                    return;
                                  }

                                  logListToShow = logList;
                                });
                              })
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Theme(
                      data: ThemeData.light()
                          .copyWith(cardColor: Theme.of(context).canvasColor),
                      child: PaginatedDataTable(
                        key: logKey,
                        showCheckboxColumn: false,
                        sortColumnIndex: 0,
                        sortAscending: sortLogAscending,
                        source: RowSource<Log>(
                          dataList: logListToShow,
                          count: logListToShow.length,
                        ),
                        rowsPerPage: logListToShow.length > 7
                            ? 7
                            : logListToShow.isEmpty
                                ? 1
                                : logListToShow.length,
                        columnSpacing: 8,
                        columns: [
                          DataColumn(
                            label: const Text(
                              'Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            onSort: ((columnIndex, ascending) {
                              setState(() {
                                sortLogAscending = ascending;
                                logListToShow.sort((a, b) => ascending
                                    ? a.date.compareTo(b.date)
                                    : b.date.compareTo(a.date));
                              });
                            }),
                          ),
                          const DataColumn(
                            label: Text(
                              'Task Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'Client id',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Text(
                              'Client name',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ),
                          const DataColumn(
                            label: Center(
                              child: Text(
                                'Error',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _showDialogExpanded({Task? task}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogComponent(
          title: task != null
              ? 'Warnings from ${task.id} - ${task.description}'
              : 'Warnings',
          content: _dialogContent(taskId: task?.id),
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
          _sortColumn(columnIndex, ascending);
        }),
      ),
      const DataColumn(
        label: Text(
          'Order number',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      const DataColumn(
        label: Text(
          'Document',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      const DataColumn(
        label: Text(
          'Client id',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      const DataColumn(
        label: Text(
          'Client name',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      const DataColumn(
        label: Text(
          'Sent/Received',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    ];

    if (_isAdmin) {
      columns.insert(
        0,
        const DataColumn(
          label: Text(
            'Seller',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ),
      );
    }

    return columns;
  }
}
