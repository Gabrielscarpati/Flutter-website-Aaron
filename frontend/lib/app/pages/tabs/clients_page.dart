import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/dialog_component.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/buyer.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/warning.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

import '../pages_controllers/tabs_controllers/clients_page_controller.dart';

class ClientsPage extends StatefulWidget {
  final int? sellerId;

  const ClientsPage({
    Key? key,
    this.sellerId,
  }) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  final _controller = ClientsPageController.instance;

  List<Buyer> clients = List.empty(growable: true);

  bool sort = true;
  List<Buyer> filterData = [];
  final TextEditingController _searchController = TextEditingController();

  List<Warning> warnings = List.empty(growable: true);

  bool _isLoading = true;

  final key = GlobalKey<PaginatedDataTableState>();

  _initRequests() async {
    final buyers = await _controller.getBuyers(widget.sellerId);

    final warningsApi = await _controller.getWarnings();

    if (mounted) {
      setState(() {
        clients = buyers;
        warnings = warningsApi;
        filterData = clients;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _initRequests();
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
                              clients = filterData
                                  .where((element) =>
                                      element.id
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.name
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.phone
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.city
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.state
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.zip
                                          .toLowerCase()
                                          .contains(value.toLowerCase()) ||
                                      element.current
                                          .toString()
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                  .toList();
                              key.currentState?.pageTo(0);
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
                            hintText: "Search for a client",
                            prefixIcon: const Icon(Icons.search),
                            prefixIconColor: Colors.black,
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close,
                                        color: Colors.black),
                                    onPressed: () async {
                                      setState(() {
                                        _searchController.clear();
                                        clients = filterData;
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
                      data: ThemeData.light().copyWith(
                        cardColor: Theme.of(context).canvasColor,
                      ),
                      child: PaginatedDataTable(
                        key: key,
                        showCheckboxColumn: false,
                        initialFirstRowIndex: 0,
                        sortColumnIndex: 0,
                        sortAscending: sort,
                        source: RowSource<Buyer>(
                          dataList: clients,
                          count: clients.length,
                        ),
                        rowsPerPage: widget.sellerId != null
                            ? (clients.length > 7
                                ? 7
                                : (clients.isNotEmpty ? clients.length : 1))
                            : clients.length > 8
                                ? 8
                                : clients.isEmpty
                                    ? 1
                                    : clients.length,
                        columnSpacing: 8,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'ID',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Phone',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'City',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          DataColumn(
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
                          DataColumn(
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
                          DataColumn(
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
                        ],
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
              data: ThemeData.light().copyWith(
                cardColor: Theme.of(context).canvasColor,
              ),
              child: PaginatedDataTable(
                showCheckboxColumn: false,
                sortColumnIndex: 0,
                sortAscending: sort,
                source: RowSource<Warning>(
                  dataList: warnings,
                  count: warnings.length,
                  onTap: (data) {},
                ),
                rowsPerPage: warnings.length > 10
                    ? 10
                    : warnings.isEmpty
                        ? 1
                        : warnings.length,
                columnSpacing: 8,
                columns: const [
                  DataColumn(
                    label: Text(
                      'Date',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Customer',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'ID',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
