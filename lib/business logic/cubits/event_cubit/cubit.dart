import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:http/http.dart'as http;
import 'package:untitled11/business%20logic/cubits/event_cubit/states.dart';

import '../../../data/models/add_event_model.dart';
import '../../../data/models/add_event_response_model.dart';
import '../../../data/models/delete_event_model.dart';
import '../../../data/models/event_model.dart';
import '../../../presentation/classes/event.dart';
import '../../../presentation/components and constants/constants.dart';

class EventWebCubit extends Cubit<EventWebStates> {
  EventWebCubit() : super(EventWebInitState());

  static EventWebCubit get(context) => BlocProvider.of(context);
  
  List<Event> events = [
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
    Event(title: 'Quiz', date: '20/2/2023', time: '10:01', description: 'Math'),
  ];

  AddEventResponseModel? addEventResponseModel;
  Future postEvent({required AddEventModel data,required String title,required String body})async
  {
   emit(AddEventWebLoadingState());
    var request = http.post( Uri.parse('https://new-school-management-system.onrender.com/web/add_event'),
        headers:{
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(data.toJson(data))
    );

    var response = await request;

    if (response.statusCode == 201) {
      print(response.statusCode);
      addEventResponseModel=AddEventResponseModel.fromJson(jsonDecode(await response.body));
      print(addEventResponseModel?.message.toString());
      emit(AddEventWebSuccessState(addEventResponseModel!));
      sendNotification(title,body);

    }
  else {
      print(response.statusCode);
      print(response.body);
      // print(jsonDecode(await response.body)['message']);
      emit(AddEventWebErrorState(error: jsonDecode(await response.body)['message']));
  }

  }

  EventModel? eventModel;
  Future showEvents()async
  {
    emit(ShowEventWebLoadingState());
    var headers = {
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('GET', Uri.parse('https://new-school-management-system.onrender.com/web/show_events'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      eventModel=EventModel.fromJson(jsonDecode(await response.stream.bytesToString()));
      print(eventModel?.toJson().toString());
      emit(ShowEventWebSuccessState(eventModel!));
  }
  else {
      String error=jsonDecode(await response.stream.bytesToString())['message'];
      print(error);
      emit(ShowEventWebErrorState(error: error));
  }

  }

  DeleteEventModel? deleteEventModel;
  Future<DeleteEventModel?>?deleteEvent({id})async
  {

    var headers = {
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('DELETE', Uri.parse('https://new-school-management-system.onrender.com/web/delete_event/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      deleteEventModel=DeleteEventModel.fromJson(jsonDecode(await response.stream.bytesToString()));
      print(deleteEventModel?.toJson().toString());
      emit(DeleteEventWebSuccessState(deleteEventModel!));
    }
  else {
      {
        String error=jsonDecode(await response.stream.bytesToString())['message'];
        print(error);
        emit(DeleteEventWebErrorState(error: error));
      }
      return deleteEventModel;
  }

  }
  Future<void> sendNotification(String title,String body)
  async {
    var request=http.MultipartRequest('POST',Uri.parse('https://new-school-management-system.onrender.com/send_notifications'));
    request.headers.addAll({
      'Accept': '*/*',
      'Authorization': 'Bearer $token',
      'Content-type': 'multipart/form-data'
    });
    request.fields.addAll({
      'title':title,
      'body':body,
      'topic':'all',
    });
    final response = await request.send();
    var responseString = await response.stream.bytesToString();
    final myResponse = http.Response(responseString, response.statusCode);
    final json = jsonDecode(myResponse.body);
    print(json);
    print(response.statusCode);


  }
}
