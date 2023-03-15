import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:board_game_app/instruments/components/custom_search_field.dart';
import 'package:board_game_app/instruments/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../instruments/components/custom_form_field.dart';
import '../../../instruments/components/event_form_input_card.dart';
import '../../choose_city_screen.dart';
import '../choose_game_screen.dart';

class FiltersPopupPage extends StatefulWidget {

  Map<String, dynamic>? appliedFilters;

  FiltersPopupPage({this.appliedFilters});

  @override
  State<FiltersPopupPage> createState() => _FiltersPopupPageState();
}

class _FiltersPopupPageState extends State<FiltersPopupPage> {
  var _gameController = TextEditingController();
  var _cityController = TextEditingController();
  var _minDateController = TextEditingController();
  var _maxDateController = TextEditingController();

  int? _gameId;
  int? _cityId;

  void goToChooseGamePage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseGamePage(),
        )
    );
    if(result!=null) {
      setState(() {
        _gameController.text = result.name;
        _gameId = result.id;
      });
    }
  }

  void goToChooseCityPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChooseCityPage(),
        )
    );
    if(result!=null) {
      setState(() {
        _cityController.text = result['city'];
        _cityId = result['id'];
      });
    }
  }


  void applyFilters(BuildContext context){
    if(_gameId!=null
        || _cityController.text.isNotEmpty
        || _minDateController.text.isNotEmpty
        || _maxDateController.text.isNotEmpty
    ){
      widget.appliedFilters = {
        'game': _gameId ?? '',
        'gameName': _gameController.text,
        'city': _cityController.text,
        'cityId': _cityId,
        'minDate': _minDateController.text,
        'maxDate': _maxDateController.text,
        'is_active': true,
      };
      Navigator.pop(context, widget.appliedFilters);
    }
    else{
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if(widget.appliedFilters!=null){
      _gameId = widget.appliedFilters!['game']=='' ? null : widget.appliedFilters!['game'];
      _cityController.text = widget.appliedFilters!['city'];
      _cityId = widget.appliedFilters!['cityId']=='' ? null : widget.appliedFilters!['cityId'];
      _gameController.text = widget.appliedFilters!['gameName'];
      _minDateController.text = widget.appliedFilters!['minDate'];
      _maxDateController.text = widget.appliedFilters!['maxDate'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Фильтры',
                style: kAppBarTextStyle,
              ),
              kWideHorizontalSizedBoxDivider,
              const Text(
                'Город',
                style: kTextStyle,
              ),
              kHorizontalSizedBoxDivider,
              Hero(
                tag: 'citySearchField',
                child: Material(
                  type: MaterialType.transparency,
                  child: CustomSearchField(
                    onTextChanged: (){},
                    hint: 'Город',
                    readOnly: true,
                    controller: _cityController,
                    onTap: (){
                      goToChooseCityPage(context);
                    },
                    suffixIcon: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    height: 46,
                  ),
                ),
              ),
              const SizedBox(height: 9,),
              const Text(
                'Игра',
                style: kTextStyle,
              ),
              kHorizontalSizedBoxDivider,
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Hero(
                      tag: 'gameSearchField',
                      child: Material(
                        type: MaterialType.transparency,
                        child: CustomSearchField(
                          onTextChanged: (){},
                          hint: 'Введите название игры',
                          readOnly: true,
                          controller: _gameController,
                          onTap: (){
                            goToChooseGamePage(context);
                          },
                          suffixIcon: const Icon(
                            Icons.arrow_forward_ios,
                          ),
                          height: 46,
                        ),
                      ),
                    ),
                  ),
                  if(_gameController.text.isNotEmpty)
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: (){
                          setState(() {
                            _gameController.clear();
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: kDefaultButtonColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.close,
                              size: 20.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              kWideHorizontalSizedBoxDivider,
              const Text(
                'Дата проведения',
                style: kTextStyle,
              ),
              kHorizontalSizedBoxDivider,
              Row(
                children: [
                  Flexible(
                    child: CustomFormField(
                      controller: _minDateController,
                      textPlaceholder: 'С',
                      isReadOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days:1)),
                          firstDate: DateTime.now().add(const Duration(days:1)),
                          lastDate: DateTime.now().add(const Duration(days:365))
                        );
                        if (pickedDate!=null){
                          String formattedDate = DateFormat('dd.MM.yyyy')
                              .format(pickedDate);
                          setState(() {
                            _minDateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                  ),
                  TextInCard(text: ' – '),
                  Flexible(
                    child: CustomFormField(
                      controller: _maxDateController,
                      textPlaceholder: 'По',
                      isReadOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(const Duration(days:1)),
                            firstDate: DateTime.now().add(const Duration(days:1)),
                            lastDate: DateTime.now().add(const Duration(days:365))
                        );
                        if (pickedDate!=null){
                          String formattedDate = DateFormat('dd.MM.yyyy')
                              .format(pickedDate);
                          setState(() {
                            _maxDateController.text = formattedDate;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              kHorizontalSizedBoxDivider,
              CustomButton(
                onPressed: (){
                  applyFilters(context);
                },
                text: 'Показать результаты',
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
