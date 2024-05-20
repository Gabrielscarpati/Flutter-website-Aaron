import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/log.dart';
import 'package:flutter_website_aaron/app/models/task.dart';
import 'package:flutter_website_aaron/app/models/user.dart';
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
  List<Log> logList = List.empty(growable: true);
  bool sort = false;
  List<Task> filterData = [];
  bool _isLoading = true;
  bool _isAdmin = false;
  User _currentUser = User.empty();

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _logSearchController = TextEditingController();

  final key = GlobalKey<PaginatedDataTableState>();

  sortColumn(int columnIndex, bool ascending) {
    if (ascending) {
      taskList.sort((a, b) => a.id.compareTo(b.id));
    } else {
      taskList.sort((a, b) => b.id.compareTo(a.id));
    }
  }

  sortLogColumn(int columnIndex, bool ascending) {
    if (ascending) {
      logList.sort((a, b) => a.date.compareTo(b.date));
    } else {
      logList.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  _getOrders() async {
    final orders = await _controller.getTasks();
    final logs = await _controller.getLogs();
    final isAdmin = await _userController.currentUserIsAdmin();
    final currentUser = await _userController.getCurrentUser();

    setState(() {
      taskList = orders;
      _isAdmin = isAdmin;
      logList = logs;
      filterData = orders;
      _currentUser = currentUser;
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
                              taskList = filterData
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
                                        element.buyerName
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
                                        taskList = filterData;
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
                        sortColumnIndex: _isAdmin ? 1 : 0,
                        sortAscending: sort,
                        source: RowSource<Task>(
                            dataList: taskList,
                            count: taskList.length,
                            onTap: (task) {
                              _showDialogExpanded(task: task);
                            }),
                        rowsPerPage: taskList.length > 8
                            ? 8
                            : taskList.isEmpty
                                ? 1
                                : taskList.length,
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
    List<Log> logListToShow;

    if (taskId != null) {
      logListToShow =
          logList.where((element) => element.taskId == taskId).toList();
    } else if (_isAdmin) {
      logListToShow = logList;
    } else {
      logListToShow = logList
          .where((element) => element.sellerId == _currentUser.sellerId)
          .toList();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
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
                  hintText: "Search in logs",
                  prefixIcon: const Icon(Icons.search),
                  prefixIconColor: Colors.black,
                  suffixIcon: _logSearchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () async {
                            setState(() {
                              _logSearchController.clear();
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
                    showCheckboxColumn: false,
                    sortColumnIndex: 0,
                    sortAscending: sort,
                    source: RowSource<Log>(
                      dataList: logListToShow,
                      count: logListToShow.length,
                    ),
                    rowsPerPage: logListToShow.length > 8
                        ? 8
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
                            sort = !sort;
                            sortLogColumn(columnIndex, ascending);
                          });
                        }),
                      ),
                      const DataColumn(
                          label: Text(
                        'Task Description',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                      const DataColumn(
                          label: Text(
                        'ID',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                      const DataColumn(
                          label: Text(
                        'Client id',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                      const DataColumn(
                          label: Text(
                        'Client name',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      )),
                      const DataColumn(
                          label: Center(
                        child: Text(
                          'Error',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
        'Client id',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      )),
      const DataColumn(
          label: Text(
        'Client name',
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
