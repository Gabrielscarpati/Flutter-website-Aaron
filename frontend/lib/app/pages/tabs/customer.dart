import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/framwork/imodel.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<CustomerTest>? filterData;
  List<CustomerTest> customerList = [];
  bool sort = true;
  final TextEditingController _searchController = TextEditingController();

  List<WarningsTest> warningsTest = [];

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
                            source: RowSource<CustomerTest>(
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
                            source: RowSource<WarningsTest>(
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

  List<CustomerTest> _getData() {
    return [
      CustomerTest(
          name: 'Aaron',
          id: '1',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      CustomerTest(
          name: 'John',
          id: '2',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      CustomerTest(
          name: 'Mary',
          id: '3',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      CustomerTest(
          name: 'Jane',
          id: '4',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      CustomerTest(
          name: 'Aaron',
          id: '1',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      CustomerTest(
          name: 'John',
          id: '2',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      CustomerTest(
          name: 'Mary',
          id: '3',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      CustomerTest(
          name: 'Jane',
          id: '4',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      CustomerTest(
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

class CustomerTest implements IModel {
  final String name;
  final String id;
  final String phone;
  final String city;
  final String state;
  final int zip;
  final bool current;

  CustomerTest(
      {required this.name,
      required this.id,
      required this.phone,
      required this.city,
      required this.state,
      required this.zip,
      required this.current});

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'phone': phone,
      'city': city,
      'state': state,
      'zip': zip,
      'current': current,
    };
  }
}

class WarningsTest extends IModel {
  final String date;
  final String customer;
  final String id;
  final String description;

  WarningsTest(
      {required this.date,
      required this.customer,
      required this.id,
      required this.description});

  @override
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'customer': customer,
      'id': id,
      'description': description,
    };
  }
}
