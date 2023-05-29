import 'package:board_game_app/instruments/components/custom_button.dart';
import 'package:board_game_app/instruments/components/custom_form_field.dart';
import 'package:board_game_app/instruments/components/event_form_input_card.dart';
import 'package:board_game_app/models/event_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../instruments/helpers.dart';
import 'Create Event/map_screen.dart';
import '../../instruments/components/custom_search_field.dart';
import '../../instruments/constants.dart';
import 'choose_game_screen.dart';

class EventForm extends StatefulWidget {

  late String widgetText;

  late void Function(Event) onSuccess;

  Event? event;

  EventForm({required this.widgetText, required this.onSuccess, this.event});

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  @override

  var _gameController = TextEditingController();
  var _minPlayTimeController = TextEditingController();
  var _maxPlayTimeController = TextEditingController();
  var _minPlayersController = TextEditingController();
  var _maxPlayersController = TextEditingController();
  var _dateController = TextEditingController();
  var _timeController = TextEditingController();
  var _addressController = TextEditingController();
  var _addressAdditionInfoController = TextEditingController();
  var _descriptionController = TextEditingController();
  var _nameController = TextEditingController();

  String? gameErrorMsg;
  String? minPlayTimeErrorMsg;
  String? maxPlayTimeErrorMsg;
  String? minPlayersErrorMsg;
  String? maxPlayersErrorMsg;
  String? dateErrorMsg;
  String? timeErrorMsg;
  String? addressErrorMsg;
  String? nameErrorMsg;

  late String _dateToServer;
  late String _city;
  late int _gameId;
  late String _gameThumbnail;

  void goToChooseGamePage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChooseGamePage(),
        )
    );
    if(result!=null) {
      setState(() {
        _gameController.text = result.name;
        _gameId = result.id;
        _gameThumbnail = result.thumbnail;
        _minPlayTimeController.text = result.minPlayTime.toString();
        _maxPlayTimeController.text = result.maxPlayTime.toString();
        _minPlayersController.text = result.minPlayers.toString();
        _maxPlayersController.text = result.maxPlayers.toString();
      });
    }
  }

  void goToMapPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapPage(),
        ));
    if (result != null) {
      setState(() {
        _addressController.text = result['address'];
        _city = result['city'];
      });
    }
  }

  bool formIsValid(){
    bool isValid = true;
    const String valuesIsIncorrect = 'Некорректное значение';
    const String valueIsTooBig = 'Слишком большое значение';

    String? isNull(bool condition){
      if(condition) {
        isValid = false;
        return 'Поле обязательно для заполнения';
      }
      return null;
    }

    Map<String,String?> rangeParametersValidation(String value1, String value2, int min, int max){
      if(value1.isNotEmpty && value2.isNotEmpty) {
        if (int.parse(value1) > int.parse(value2)) {
          isValid = false;
          return {
            'minErrorMsg': valuesIsIncorrect,
            'maxErrorMsg': valuesIsIncorrect,
          };
        }
        if (int.parse(value1) < min) {
          isValid = false;
          return {
            'minErrorMsg': valuesIsIncorrect,
            'maxErrorMsg': null,
          };
        }
        if (int.parse(value2) > max) {
          isValid = false;
          return {
            'minErrorMsg': null,
            'maxErrorMsg': valueIsTooBig,
          };
        }
      }
      else{
        isValid = false;
        return {
          'minErrorMsg': isNull(value1.isEmpty),
          'maxErrorMsg': isNull(value2.isEmpty),
        };
      }
      return {
        'minErrorMsg': null,
        'maxErrorMsg': null,
      };
    }

    gameErrorMsg = null;
    minPlayTimeErrorMsg = null;
    maxPlayersErrorMsg = null;
    dateErrorMsg = null;
    timeErrorMsg = null;
    addressErrorMsg = null;
    nameErrorMsg = null;

    gameErrorMsg=isNull(_gameController.text.isEmpty);

    var playTimeErrorMessages = rangeParametersValidation(
      _minPlayTimeController.text,
      _maxPlayTimeController.text,
      1,
      1000,
    );
    minPlayTimeErrorMsg = playTimeErrorMessages['minErrorMsg'];
    maxPlayTimeErrorMsg = playTimeErrorMessages['maxErrorMsg'];

    var playersErrorMessages = rangeParametersValidation(
      _minPlayersController.text,
      _maxPlayersController.text,
      1,
      20,
    );
    minPlayersErrorMsg = playersErrorMessages['minErrorMsg'];
    maxPlayersErrorMsg = playersErrorMessages['maxErrorMsg'];

    dateErrorMsg = isNull(_dateController.text.isEmpty);
    timeErrorMsg = isNull(_timeController.text.isEmpty);
    addressErrorMsg = isNull(_addressController.text.isEmpty);
    nameErrorMsg = isNull(_nameController.text.isEmpty);

    return isValid;
  }

  void handleEvent(BuildContext context) async{
    if(formIsValid()){
      Event event= Event(
        gameId: _gameId,
        minPlayTime: int.parse(_minPlayTimeController.text),
        maxPlayTime: int.parse(_maxPlayTimeController.text),
        minPlayers: int.parse(_minPlayersController.text),
        maxPlayers: int.parse(_maxPlayersController.text),
        date: _dateToServer,
        time: _timeController.text.toString(),
        address: _addressController.text.toString(),
        addressAdditionalInfo: _addressAdditionInfoController.text.toString(),
        city: _city,
        description: _descriptionController.text.toString(),
        name: _nameController.text.toString(),
        // organizerId: id,
        gameName: _gameController.text,
        gameThumbnail: _gameThumbnail,
      );
      if(widget.event!=null){
        event.id=widget.event?.id;
        event.organizerId=widget.event?.organizerId;
        event.participators=widget.event?.participators;
      }
      widget.onSuccess(event);
    }
  }

  @override
  void initState(){
    super.initState();
    if(widget.event!=null){
      setState(() {
        Event event = widget.event!;
        _gameController.text = event.gameName;
        _gameId = event.gameId;
        _gameThumbnail = event.gameThumbnail;
        _minPlayTimeController.text = event.minPlayTime.toString();
        _maxPlayTimeController.text = event.maxPlayTime.toString();
        _minPlayersController.text = event.minPlayers.toString();
        _maxPlayersController.text = event.maxPlayers.toString();
        _dateController.text = event.getFormattedDate();
        _dateToServer = event.date;
        //TODO: PM/AM формат времени
        _timeController.text = event.time.substring(0, 5);
        _addressController.text = event.address;
        _city = event.city!;
        if(event.addressAdditionalInfo!=null){
          _addressAdditionInfoController.text = event.addressAdditionalInfo!;
        }
        if(event.description!=null){
          _descriptionController.text = event.description!;
        }
        _nameController.text = event.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          // 'Создать мероприятие',
          widget.widgetText,
          style: kAppBarTextStyle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: kDefaultPagePadding,
          child: CustomScrollView(
            scrollDirection: Axis.vertical,
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    EventFormInputCard(
                      number: 1,
                      text: 'Выберите игру',
                      childWidget: Hero(
                        tag: 'searchField',
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
                            suffixIcon: kArrowForwardIcon,
                            errorMsg: gameErrorMsg,
                          ),
                        ),
                      ),
                    ),
                    kDivider,
                    EventFormInputCard(
                      number: 2,
                      text: 'Введите ожидаемую длительность игры',
                      childWidget: Row(
                        children: [
                          Flexible(
                            child: CustomFormField(
                              controller: _minPlayTimeController,
                              textPlaceholder: 'Min',
                              keyboardType: TextInputType.number,
                              errorMsg: minPlayTimeErrorMsg,
                            ),
                          ),
                          TextInCard(text: ' – '),
                          Flexible(
                            child: CustomFormField(
                              controller: _maxPlayTimeController,
                              textPlaceholder: 'Max',
                              keyboardType: TextInputType.number,
                              errorMsg: maxPlayTimeErrorMsg,
                            ),
                          ),
                          TextInCard(text: ' минут'),
                        ],
                      ),
                    ),
                    kDivider,
                    EventFormInputCard(
                      number: 3,
                      text: 'Введите число участников',
                      childWidget: Row(
                        children: [
                          Flexible(
                            child: CustomFormField(
                              controller: _minPlayersController,
                              textPlaceholder: 'Min',
                              keyboardType: TextInputType.number,
                              errorMsg: minPlayersErrorMsg,
                            ),
                          ),
                          TextInCard(text: ' – '),
                          Flexible(
                            child: CustomFormField(
                              controller: _maxPlayersController,
                              textPlaceholder: 'Max',
                              keyboardType: TextInputType.number,
                              errorMsg: maxPlayersErrorMsg,
                            ),
                          ),
                        ],
                      ),
                    ),
                    kDivider,
                    EventFormInputCard(
                      number: 4,
                      text: 'Выберите дату и время',
                      childWidget: Column(
                        children: [
                          CustomFormField(
                            controller: _dateController,
                            textPlaceholder: 'Дата мероприятия',
                            isReadOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now().add(const Duration(days:1)),
                                  firstDate: DateTime.now().add(const Duration(days:1)),
                                  lastDate: DateTime.now().add(const Duration(days:365))
                              );
                              if (pickedDate!=null){
                                String date = DateFormat('yyyy-MM-dd')
                                    .format(pickedDate);
                                String formattedDate = DateFormat('dd.MM.yyyy')
                                    .format(pickedDate);
                                _dateToServer = date;
                                // String formattedDate = DateFormat('yyyy-MM-dd').
                                setState(() {
                                  _dateController.text = formattedDate;
                                });
                              }
                            },
                            errorMsg: dateErrorMsg,
                          ),
                          kHorizontalSizedBoxDivider,
                          CustomFormField(
                            controller: _timeController,
                            textPlaceholder: 'Время мероприятия',
                            isReadOnly: true,
                            onTap: () async {
                              final TimeOfDay? pickedTime = await showTimePicker(
                                context: context,
                                initialTime: const TimeOfDay(hour: 16, minute: 00),
                              );
                              if(pickedTime!=null){
                                setState(() {
                                  _timeController.text = pickedTime.format(context);
                                });
                              }
                            },
                            errorMsg: timeErrorMsg,
                          ),
                        ],
                      ),
                    ),
                    kDivider,
                    EventFormInputCard(
                      number: 5,
                      text: 'Укажите место проведения',
                      childWidget: Material(
                        type: MaterialType.transparency,
                        child: Column(
                          children: [
                            CustomSearchField(
                              onTextChanged: (){},
                              hint: 'Укажите адрес',
                              readOnly: true,
                              controller: _addressController,
                              onTap: (){
                                goToMapPage(context);
                              },
                              suffixIcon: kArrowForwardIcon,
                              errorMsg: addressErrorMsg,
                            ),
                            kHorizontalSizedBoxDivider,
                            CustomFormField(
                              controller: _addressAdditionInfoController,
                              textPlaceholder: 'Дополнительная информация о месте проведения(опционально)',
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    kDivider,
                    EventFormInputCard(
                      number: 6,
                      text: 'Введите описание мероприятия',
                      childWidget: CustomFormField(
                        controller: _descriptionController,
                        textPlaceholder: 'Описание(опционально)',
                        maxLines: 3,
                      ),
                    ),
                    kDivider,
                    EventFormInputCard(
                      number: 7,
                      text: 'Введите название мероприятия',
                      childWidget: CustomFormField(
                        controller: _nameController,
                        textPlaceholder: 'Название',
                        errorMsg: nameErrorMsg,
                      ),
                    ),
                    kWideHorizontalSizedBoxDivider,
                    CustomButton(
                      onPressed: (){
                        setState(() {
                          handleEvent(context);
                        });
                      },
                      // text: 'Создать мероприятие',
                      text: widget.widgetText,
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    kWideHorizontalSizedBoxDivider,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






