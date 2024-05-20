import 'package:twilio_programmable_video_example/models/twilio_list_room_request.dart';
import 'package:twilio_programmable_video_example/models/twilio_list_room_response.dart';
import 'package:twilio_programmable_video_example/models/twilio_page_meta.dart';
import 'package:twilio_programmable_video_example/models/twilio_room_by_sid_request.dart';
import 'package:twilio_programmable_video_example/models/twilio_room_by_unique_name_request.dart';
import 'package:twilio_programmable_video_example/models/twilio_room_request.dart';
import 'package:twilio_programmable_video_example/models/twilio_room_response.dart';
import 'package:twilio_programmable_video_example/models/twilio_room_token_request.dart';
import 'package:twilio_programmable_video_example/models/twilio_room_token_response.dart';

abstract class BackendService {
  Future<TwilioRoomResponse> completeRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest);
  Future<TwilioRoomResponse> createRoom(TwilioRoomRequest twilioRoomRequest);
  Future<TwilioRoomTokenResponse> createToken(TwilioRoomTokenRequest twilioRoomTokenRequest);
  Future<TwilioRoomResponse> getRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest);
  Future<TwilioRoomResponse> getRoomByUniqueName(TwilioRoomByUniqueNameRequest twilioRoomByUniqueNameRequest);
  Future<TwilioListRoomResponse> listRooms(TwilioListRoomRequest twilioListRoomRequest);
}

class NoOpBackendService implements BackendService {
  @override
  Future<TwilioRoomResponse> completeRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest) async {
    return TwilioRoomResponse();
  }

  @override
  Future<TwilioRoomResponse> createRoom(TwilioRoomRequest twilioRoomRequest) async {
    return TwilioRoomResponse();
  }

  @override
  Future<TwilioRoomTokenResponse> createToken(TwilioRoomTokenRequest twilioRoomTokenRequest) async {
    return TwilioRoomTokenResponse(
      identity: 'identity',
      token: '<<< YOUR TWILIO TOKEN GOES HERE >>>',
    );
  }

  @override
  Future<TwilioRoomResponse> getRoomBySid(TwilioRoomBySidRequest twilioRoomBySidRequest) async {
    return TwilioRoomResponse();
  }

  @override
  Future<TwilioRoomResponse> getRoomByUniqueName(TwilioRoomByUniqueNameRequest twilioRoomByUniqueNameRequest) async {
    return TwilioRoomResponse();
  }

  @override
  Future<TwilioListRoomResponse> listRooms(TwilioListRoomRequest twilioListRoomRequest) async {
    return TwilioListRoomResponse(
      rooms: [],
      meta: TwilioPageMeta(
        page: 0,
        pageSize: 0,
        firstPageUrl: '',
        previousPageUrl: '',
        url: '',
        nextPageUrl: '',
        key: '',
      ),
    );
  }
}
