import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  List<DataTest>? filterData;
  List<DataTest> dataList = [];
  bool sort = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataList = _getData();
    filterData = dataList;
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
                    dataList = filterData!
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
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () async {
                          _searchController.clear();
                          setState(() {
                            dataList = filterData!
                                .where((element) => element.name.contains(""))
                                .toList();
                          });
                        })),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: Theme(
                    data: ThemeData.light()
                        .copyWith(cardColor: Theme.of(context).canvasColor),
                    child: PaginatedDataTable(
                      sortColumnIndex: 0,
                      sortAscending: sort,
                      source:
                          RowSource(dataList: dataList, count: dataList.length),
                      rowsPerPage: dataList.isEmpty ? 1 : dataList.length,
                      columnSpacing: 8,
                      columns: const [
                        DataColumn(
                          label: Text(
                            'ID',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
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
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        )),
                        DataColumn(
                            label: Center(
                          child: Text(
                            'Zip Code',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        )),
                        DataColumn(
                            label: Center(
                          child: Text(
                            'Current',
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
      ),
    );
  }

  // _updatedList(String value) async {
  //   List<DataTest> mainList = _getData();
  //   _dataList = mainList
  //     .where((element) =>
  //       element.name.toLowerCase().contains(value.toLowerCase()))
  //       .toList();
  // }

  // _createSubtitle(String field, String attribute) {
  //   return RichText(
  //     text: TextSpan(
  //       children: [
  //         TextSpan(
  //           text: field,
  //           style: const TextStyle(
  //               fontWeight: FontWeight.bold,
  //               fontSize: 14,
  //               color: AppColors.blackColor),
  //         ),
  //         TextSpan(
  //           text: attribute,
  //           style: const TextStyle(fontSize: 14, color: AppColors.blackColor),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  List<DataTest> _getData() {
    return [
      DataTest(
          name: 'Aaron',
          id: '1',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      DataTest(
          name: 'John',
          id: '2',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      DataTest(
          name: 'Mary',
          id: '3',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      DataTest(
          name: 'Jane',
          id: '4',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      DataTest(
          name: 'Aaron',
          id: '1',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      DataTest(
          name: 'John',
          id: '2',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      DataTest(
          name: 'Mary',
          id: '3',
          phone: '123456789',
          city: 'São Paulo',
          state: 'SP',
          zip: 123456,
          current: true),
      DataTest(
          name: 'Jane',
          id: '4',
          phone: '987654321',
          city: 'Rio de Janeiro',
          state: 'RJ',
          zip: 654321,
          current: false),
      DataTest(
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

class DataTest {
  final String name;
  final String id;
  final String phone;
  final String city;
  final String state;
  final int zip;
  final bool current;

  DataTest(
      {required this.name,
      required this.id,
      required this.phone,
      required this.city,
      required this.state,
      required this.zip,
      required this.current});
}

class RowSource extends DataTableSource {
  var dataList;
  final count;
  RowSource({
    required this.dataList,
    required this.count,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(dataList[index]);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data) {
  DataCell dataCell = (data.current)
      ? const DataCell(Icon(Icons.check))
      : const DataCell(Icon(Icons.close));

  return DataRow(cells: [
    DataCell(Text(data.id)),
    DataCell(Text(data.name)),
    DataCell(Text(data.phone)),
    DataCell(Text(data.city)),
    DataCell(Text(data.state)),
    DataCell(Text(data.zip.toString())),
    dataCell
  ]);
}
