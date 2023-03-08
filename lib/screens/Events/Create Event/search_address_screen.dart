import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../instruments/components/close_popup_button.dart';
import '../../../instruments/components/custom_search_field.dart';
import '../../../instruments/constants.dart';
import '../../../instruments/helpers.dart';


//TODO: адаптировать под SearchPageLayout
class SearchAddressPage extends StatefulWidget {

  Point myLocation;

  SearchAddressPage({required this.myLocation});

  @override
  State<SearchAddressPage> createState() => _SearchAddressPageState();
}

class _SearchAddressPageState extends State<SearchAddressPage> {

  Future<SearchSessionResult>? futureAddresses;

  bool isSearching = false;
  void _search(text) async{
    setState(() {
      if(!text.isEmpty) {
        isSearching = true;
        // futureGames = _apiService.searchGames(text);
        futureAddresses = search(text);
      }
      else{
        isSearching = false;
      }
    });
  }

  Future<SearchSessionResult> search(query) async {
    final resultWithSession = YandexSearch.searchByText(
      searchText: query,
      geometry: Geometry.fromPoint(widget.myLocation),
      searchOptions: const SearchOptions(
        searchType: SearchType.geo,
        geometry: false,
      ),
    );
    var result = await resultWithSession.result;
    return result;
  }

  // Widget buildItem(data, int index){
  //   var address = data.toponymMetadata!.address;
  //
  //   String formattedAddress = getFormattedAddress(address);
  //   String cityAndRegion='';
  //   if(address.addressComponents[SearchComponentKind.locality]!=null){
  //     cityAndRegion+=address.addressComponents[SearchComponentKind.locality];
  //     cityAndRegion+=', ';
  //   }
  //   if(address.addressComponents[SearchComponentKind.province]!=null){
  //     cityAndRegion+=address.addressComponents[SearchComponentKind.province];
  //   }
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       GestureDetector(
  //         behavior: HitTestBehavior.translucent,
  //         onTap: (){
  //           Navigator.pop(context, data.geometry[0].point);
  //           // print(snapshot.data.items![index].geometry[0].point);
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               Text(
  //                 formattedAddress,
  //                 style: kTextStyle,
  //               ),
  //               Text(
  //                 cityAndRegion,
  //                 style: const TextStyle(
  //                   color: Colors.grey,
  //                   fontSize: 17.0,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    // return SearchPageLayout(
    //   future: futureAddresses,
    //   isSearching: isSearching,
    //   searchField: Hero(
    //     tag: 'gameSearchField',
    //     child: CustomSearchField(
    //       onTextChanged: _search,
    //       hint: 'Введите адрес',
    //     ),
    //   ),
    //   searchResults: buildItem,
    //   isPopup: true,
    // );
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ClosePopupButton(onTap: (){Navigator.pop(context);}),
            CustomSearchField(
              onTextChanged: _search,
              hint: 'Введите адрес',
            ),
            if(isSearching)
              Expanded(
                child: FutureBuilder(
                  future: futureAddresses,
                  initialData: const [],
                  builder: (BuildContext ctx, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data==null){
                      return const Center(
                        child: Text(
                          'По вашему запросу ничего не найдено',
                          style: kTextStyle,
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.items!.length,
                        itemBuilder: (ctx, index)
                        {
                          // print(snapshot.data.items![index].geometry[0].point);
                          var address = snapshot.data.items![index].toponymMetadata!.address;
                          String formattedAddress = getFormattedAddress(address);
                          String cityAndRegion='';
                          if(address.addressComponents[SearchComponentKind.locality]!=null){
                            cityAndRegion+=address.addressComponents[SearchComponentKind.locality];
                            cityAndRegion+=', ';
                          }
                          if(address.addressComponents[SearchComponentKind.province]!=null){
                            cityAndRegion+=address.addressComponents[SearchComponentKind.province];
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  Navigator.pop(context, snapshot.data.items![index].geometry[0].point);
                                  // print(snapshot.data.items![index].geometry[0].point);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        formattedAddress,
                                        style: kTextStyle,
                                      ),
                                      Text(
                                        cityAndRegion,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
