import 'package:flutter/material.dart';
import 'package:flutter_website_aaron/app/components/dialog_component.dart';
import 'package:flutter_website_aaron/app/components/loading_component.dart';
import 'package:flutter_website_aaron/app/models/dataTable/row_source.dart';
import 'package:flutter_website_aaron/app/models/seller.dart';
import 'package:flutter_website_aaron/app/pages/pages_controllers/tabs_controllers/members_page_controller.dart';
import 'package:flutter_website_aaron/app/pages/tabs/clients_page.dart';
import 'package:flutter_website_aaron/app/shared/app_design_system.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage> {
  final _controller = MembersPageController.instance;

  List<Seller> dataList = List.empty(growable: true);

  bool sort = true;
  List<Seller> filterData = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  final key = GlobalKey<PaginatedDataTableState>();

  sortColumn(int columnIndex, bool ascending) {
    if (ascending) {
      dataList.sort((a, b) => a.name.compareTo(b.name));
    } else {
      dataList.sort((a, b) => b.name.compareTo(a.name));
    }
  }

  @override
  void initState() {
    _getSellers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingComponent()
          : SingleChildScrollView(
              padding: const EdgeInsets.only(left: 10, right: 15, top: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          dataList = filterData
                              .where((element) =>
                                  element.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.state
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.phone
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.tradingPartners
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  element.removed
                                      .toString()
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
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
                        hintText: 'Search for a seller',
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
                                },
                              )
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
                          key: key,
                          showCheckboxColumn: false,
                          sortColumnIndex: 0,
                          sortAscending: sort,
                          source: RowSource<Seller>(
                            dataList: dataList,
                            count: dataList.length,
                            onTap: (data) {
                              _showSellerDetailsModal(data);
                            },
                          ),
                          rowsPerPage: dataList.length > 8
                              ? 8
                              : dataList.isEmpty
                                  ? 1
                                  : dataList.length,
                          columnSpacing: 8,
                          columns: [
                            DataColumn(
                                label: const Text(
                                  'Seller',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                ),
                                onSort: ((columnIndex, ascending) {
                                  setState(() {
                                    sort = !sort;
                                    sortColumn(columnIndex, ascending);
                                  });
                                })),
                            const DataColumn(
                                label: Text(
                              'Phone',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            )),
                            const DataColumn(
                                label: Text(
                              'State',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            )),
                            const DataColumn(
                                label: Center(
                              child: Text(
                                'Trading Partners',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                            )),
                            const DataColumn(
                                label: Center(
                              child: Text(
                                'Removed',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 14),
                              ),
                            )),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  _getSellers() {
    _controller.getSellersDetails().then((value) {
      setState(() {
        dataList = value;
        filterData = value;
        _isLoading = false;
      });
    });
  }

  _showSellerDetailsModal(Seller seller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DialogComponent(
          title: "${seller.name} clients",
          content: ClientsPage(sellerId: seller.id),
        );
      },
    );
  }
}
