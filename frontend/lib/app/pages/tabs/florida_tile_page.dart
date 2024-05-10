import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/buyer.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/warning.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

import '../pages_controllers/tabs_controllers/florida_tile_page_controller.dart';

class FloridaTilePage extends StatefulWidget {
  const FloridaTilePage({super.key});

  @override
  State<FloridaTilePage> createState() => _FloridaTilePageState();
}

class _FloridaTilePageState extends State<FloridaTilePage> {
  final _controller = FloridaTilePageController.instance;

  List<Buyer> dataList = List.empty(growable: true);

  bool sort = true;
  List<Buyer> filterData = [];
  final TextEditingController _searchController = TextEditingController();

  List<Warning> warnings = List.empty(growable: true);

  bool _isLoading = true;

  final key = GlobalKey<PaginatedDataTableState>();

  _initRequests() async {
    final buyers = await _controller.getBuyers();
    final warningsApi = await _controller.getWarnings();
    setState(() {
      dataList = buyers;
      warnings = warningsApi;
      filterData = dataList;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    _initRequests();
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
                                    dataList = filterData
                                        .where((element) => element.name
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
                                  hintText: "Search for a Name",
                                  prefixIcon: const Icon(Icons.search),
                                  prefixIconColor: Colors.black,
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.black),
                                          onPressed: () async {
                                            setState(() {
                                              _searchController.clear();
                                              dataList = filterData;
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
                                      initialFirstRowIndex: 0,
                                      sortColumnIndex: 0,
                                      sortAscending: sort,
                                      source: RowSource<Buyer>(
                                          dataList: dataList,
                                          count: dataList.length),
                                      rowsPerPage: dataList.length > 10
                                          ? 10
                                          : dataList.isEmpty
                                              ? 1
                                              : dataList.length,
                                      columnSpacing: 8,
                                      columns: const [
                                        DataColumn(
                                          label: Text(
                                            'ID',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        ),
                                        DataColumn(
                                            label: Text(
                                          'Name',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'Phone',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        )),
                                        DataColumn(
                                            label: Text(
                                          'city',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14),
                                        )),
                                        DataColumn(
                                            label: Center(
                                          child: Text(
                                            'State',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        )),
                                        DataColumn(
                                            label: Center(
                                          child: Text(
                                            'Zip Code',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14),
                                          ),
                                        )),
                                        DataColumn(
                                            label: Center(
                                          child: Text(
                                            'Current',
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
              padding: const EdgeInsets.only(bottom: 15),
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
                    source: RowSource<Warning>(
                        dataList: warnings, count: warnings.length),
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
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      DataColumn(
                          label: Text(
                        'Customer',
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
                          label: Text(
                        'Description',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
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
