import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/dialog_component.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/buyer.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/warning.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';
import 'package:flutter_website_aaron/app/shared/user_controller.dart';

import '../pages_controllers/tabs_controllers/clients_page_controller.dart';

class ClientsPage extends StatefulWidget {
  final int? sellerId;

  const ClientsPage({
    super.key,
    this.sellerId,
  });

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final _controller = ClientsPageController.instance;
  final _userController = UserController.instance;

  List<Buyer> clients = List.empty(growable: true);
  List<Buyer> filteredClients = List.empty(growable: true);
  List<Warning> warnings = List.empty(growable: true);
  List<Warning> filteredWarnings = List.empty(growable: true);

  bool sortClientsAscending = false;
  bool sortWarningsAscending = false;
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _warningSearchController =
      TextEditingController();

  final key = GlobalKey<PaginatedDataTableState>();
  final warningKey = GlobalKey<PaginatedDataTableState>();

  _initRequests() async {
    final buyers = await _controller.getBuyers(widget.sellerId);
    final warningsApi = await _controller.getWarnings();
    final currentUser = await _userController.getCurrentUser();
    final isAdmin = await _userController.currentUserIsAdmin();

    setState(() {
      clients = buyers;
      filteredClients = buyers;
      warnings = isAdmin
          ? warningsApi
          : warningsApi
              .where((element) => element.sellerId == currentUser.sellerId)
              .toList();
      filteredWarnings = warnings;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _initRequests();
    super.initState();
  }

  void _filterClients(String value) {
    setState(() {
      filteredClients = clients
          .where(
            (element) =>
                element.id
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.name.toLowerCase().contains(value.toLowerCase()) ||
                element.phone.toLowerCase().contains(value.toLowerCase()) ||
                element.city.toLowerCase().contains(value.toLowerCase()) ||
                element.state.toLowerCase().contains(value.toLowerCase()) ||
                element.zip.toLowerCase().contains(value.toLowerCase()) ||
                element.current
                    .toString()
                    .toLowerCase()
                    .contains(value.toLowerCase()),
          )
          .toList();
      key.currentState?.pageTo(0);
    });
  }

  void _sortClientsColumn(int columnIndex, bool ascending) {
    setState(() {
      sortClientsAscending = ascending;
      if (ascending) {
        filteredClients.sort((a, b) => a.id.compareTo(b.id));
      } else {
        filteredClients.sort((a, b) => b.id.compareTo(a.id));
      }
    });
  }

  void _sortWarningsColumn(int columnIndex, bool ascending) {
    setState(() {
      sortWarningsAscending = ascending;
      if (ascending) {
        filteredWarnings.sort((a, b) => a.date.compareTo(b.date));
      } else {
        filteredWarnings.sort((a, b) => b.date.compareTo(a.date));
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
                          onChanged: (value) => _filterClients(value),
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                AppColors.secondaryColor.withOpacity(0.3),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide.none,
                            ),
                            hintText: "Search for a client",
                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: Colors.black,
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.black),
                                    onPressed: () {
                                      setState(() {
                                        _searchController.clear();
                                        filteredClients = clients;
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
                      data: ThemeData.light().copyWith(
                        cardColor: Theme.of(context).canvasColor,
                      ),
                      child: PaginatedDataTable(
                        key: key,
                        showCheckboxColumn: false,
                        initialFirstRowIndex: 0,
                        sortColumnIndex: 0,
                        sortAscending: sortClientsAscending,
                        source: RowSource<Buyer>(
                          dataList: filteredClients,
                          count: filteredClients.length,
                        ),
                        rowsPerPage: widget.sellerId != null
                            ? (filteredClients.length > 7
                                ? 7
                                : (filteredClients.isNotEmpty
                                    ? filteredClients.length
                                    : 1))
                            : filteredClients.length > 8
                                ? 8
                                : filteredClients.isEmpty
                                    ? 1
                                    : filteredClients.length,
                        columnSpacing: 8,
                        columns: _getClientColumns(),
                      ),
                    ),
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
        return DialogComponent(
          title: 'Warnings',
          content: _dialogContent(),
        );
      },
    );
  }

  _dialogContent() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 15),
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _warningSearchController,
                    onChanged: (value) {
                      setState(() {
                        filteredWarnings = warnings
                            .where(
                              (element) =>
                                  element.date
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.customer
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.id
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.description
                                      .toLowerCase()
                                      .contains(value.toLowerCase()),
                            )
                            .toList();
                        warningKey.currentState?.pageTo(0);
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
                      hintText: "Search in warnings",
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor: Colors.black,
                      suffixIcon: _warningSearchController.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  _warningSearchController.clear();
                                  filteredWarnings = warnings;
                                });
                              },
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: Theme(
                      data: ThemeData.light().copyWith(
                        cardColor: Theme.of(context).canvasColor,
                      ),
                      child: PaginatedDataTable(
                        key: warningKey,
                        showCheckboxColumn: false,
                        sortColumnIndex: 0,
                        sortAscending: sortWarningsAscending,
                        source: RowSource<Warning>(
                          dataList: filteredWarnings,
                          count: filteredWarnings.length,
                        ),
                        rowsPerPage: filteredWarnings.length > 8
                            ? 8
                            : filteredWarnings.isEmpty
                                ? 1
                                : filteredWarnings.length,
                        columnSpacing: 8,
                        columns: _getWarningColumns(setState),
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

  List<DataColumn> _getClientColumns() {
    return [
      DataColumn(
        label: const Text(
          'ID',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortClientsColumn(columnIndex, ascending);
          });
        },
      ),
      const DataColumn(
        label: Text(
          'Name',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'Phone',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'City',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      const DataColumn(
        label: Center(
          child: Text(
            'State',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
      const DataColumn(
        label: Center(
          child: Text(
            'Zip Code',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
      const DataColumn(
        label: Center(
          child: Text(
            'Current',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    ];
  }

  List<DataColumn> _getWarningColumns(StateSetter setState) {
    return [
      DataColumn(
        label: const Text(
          'Date',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        onSort: (columnIndex, ascending) {
          setState(() {
            _sortWarningsColumn(columnIndex, ascending);
          });
        },
      ),
      const DataColumn(
        label: Text(
          'Customer',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'ID',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    ];
  }
}
