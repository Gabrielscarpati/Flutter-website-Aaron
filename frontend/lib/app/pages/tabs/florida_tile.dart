import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/models/buyer.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/warning.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class FloridaTilePage extends StatefulWidget {
  const FloridaTilePage({super.key});

  @override
  State<FloridaTilePage> createState() => _FloridaTilePageState();
}

class _FloridaTilePageState extends State<FloridaTilePage> {
  List<Buyer>? filterData;
  List<Buyer> customerList = [];
  bool sort = true;
  final TextEditingController _searchController = TextEditingController();

  List<Warning> warningsTest = [];

  @override
  void initState() {
    super.initState();
    customerList = _getData();
    filterData = customerList;
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
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
                          customerList = filterData!
                              .where((element) => element.name.contains(value))
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
                          hintText: "Search for a Name",
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: Colors.black,
                          suffixIcon: IconButton(
                              icon:
                                  const Icon(Icons.close, color: Colors.black),
                              onPressed: () async {
                                _searchController.clear();
                                setState(() {
                                  customerList = filterData!
                                      .where((element) =>
                                          element.name.contains(""))
                                      .toList();
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
                            sortColumnIndex: 0,
                            sortAscending: sort,
                            source: RowSource<Buyer>(
                                dataList: customerList,
                                count: customerList.length),
                            rowsPerPage:
                                customerList.isEmpty ? 1 : customerList.length,
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
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              )),
                              DataColumn(
                                  label: Text(
                                'Phone',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              )),
                              DataColumn(
                                  label: Text(
                                'city',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
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
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                            source: RowSource<Warning>(
                                dataList: warningsTest,
                                count: warningsTest.length),
                            rowsPerPage:
                                warningsTest.isEmpty ? 1 : warningsTest.length,
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
            )
          ],
        ),
      ),
    );
  }

  List<Buyer> _getData() {
    return [
      Buyer(
          name: 'Aaron',
          id: '1',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      Buyer(
          name: 'John',
          id: '2',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      Buyer(
          name: 'Mary',
          id: '3',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      Buyer(
          name: 'Jane',
          id: '4',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      Buyer(
          name: 'Aaron',
          id: '1',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      Buyer(
          name: 'John',
          id: '2',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      Buyer(
          name: 'Mary',
          id: '3',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      Buyer(
          name: 'Jane',
          id: '4',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      Buyer(
          name: 'Aaron',
          id: '1',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
    ];
  }
}