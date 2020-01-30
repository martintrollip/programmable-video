part of twilio_unofficial_programmable_video;

class RemoteParticipantEvent {
  final RemoteParticipant remoteParticipant;

  final RemoteVideoTrackPublication remoteVideoTrackPublication;

  final RemoteVideoTrack remoteVideoTrack;

  RemoteParticipantEvent(this.remoteParticipant, this.remoteVideoTrackPublication, this.remoteVideoTrack) : assert(remoteParticipant != null);
}

class RemoteParticipant implements Participant {
  // TODO: give it purpose!
  // ignore: unused_field
  Stream<dynamic> _participantStream;

  final String _identity;

  final String _sid;

  final List<RemoteAudioTrackPublication> _remoteAudioTrackPublications = <RemoteAudioTrackPublication>[];

//  List<RemoteDataTrackPublication> _remoteDataTrackPublications = <RemoteDataTrackPublication>[];

  final List<RemoteVideoTrackPublication> _remoteVideoTrackPublications = <RemoteVideoTrackPublication>[];

  /// The SID of this [RemoteParticipant].
  @override
  String get sid {
    return _sid;
  }

  /// The identity of this [RemoteParticipant].
  @override
  String get identity {
    return _identity;
  }

  /// Read-only list of remote audio track publications.
  List<RemoteAudioTrackPublication> get remoteAudioTracks {
    return [..._remoteAudioTrackPublications];
  }

//  /// Read-only list of remote data track publications.
//  List<RemoteDataTrackPublication> get remoteDataTracks {
//    return [..._remoteDataTrackPublications];
//  }

  /// Read-only list of remote video track publications.
  List<RemoteVideoTrackPublication> get remoteVideoTracks {
    return [..._remoteVideoTrackPublications];
  }

  /// Read-only list of audio track publications.
  @override
  List<AudioTrackPublication> get audioTracks {
    return [..._remoteAudioTrackPublications];
  }

//  /// Read-only list of data track publications.
//  List<DataTrackPublication> get dataTracks {
//    return [..._remoteDataTrackPublications];
//  }

  /// Read-only list of video track publications.
  @override
  List<VideoTrackPublication> get videoTracks {
    return [..._remoteVideoTrackPublications];
  }

  final StreamController<RemoteParticipantEvent> _onVideoTrackSubscribed = StreamController<RemoteParticipantEvent>();
  Stream<RemoteParticipantEvent> onVideoTrackSubscribed;

  final StreamController<RemoteParticipantEvent> _onVideoTrackUnsubscribed = StreamController<RemoteParticipantEvent>();
  Stream<RemoteParticipantEvent> onVideoTrackUnsubscribed;

  RemoteParticipant(this._identity, this._sid)
      : assert(_identity != null),
        assert(_sid != null) {
    onVideoTrackSubscribed = _onVideoTrackSubscribed.stream;
    onVideoTrackUnsubscribed = _onVideoTrackUnsubscribed.stream;
  }

  factory RemoteParticipant.fromMap(Map<String, dynamic> map) {
    final remoteParticipant = RemoteParticipant(map['identity'], map['sid']);
    remoteParticipant.updateFromMap(map);
    return remoteParticipant;
  }

  void updateFromMap(Map<String, dynamic> map) {
    if (map['remoteVideoTrackPublications'] != null) {
      final List<Map<String, dynamic>> remoteVideoTrackPublicationsList = map['remoteVideoTrackPublications'].map<Map<String, dynamic>>((r) => Map<String, dynamic>.from(r)).toList();
      for (final remoteVideoTrackPublicationMap in remoteVideoTrackPublicationsList) {
        final remoteVideoTrackPublication = _remoteVideoTrackPublications.firstWhere(
          (p) => p.trackSid == remoteVideoTrackPublicationMap['sid'],
          orElse: () => RemoteVideoTrackPublication.fromMap(remoteVideoTrackPublicationMap, this),
        );
        if (!_remoteVideoTrackPublications.contains(remoteVideoTrackPublication)) {
          _remoteVideoTrackPublications.add(remoteVideoTrackPublication);
        }
        remoteVideoTrackPublication.updateFromMap(remoteVideoTrackPublicationMap);
      }
    }
  }

  void _parseEvents(dynamic event) {
    final String eventName = event['name'];
    final data = Map<String, dynamic>.from(event['data']);

    RemoteVideoTrackPublication remoteVideoTrackPublication;
    if (data['remoteVideoTrackPublication'] != null) {
      final remoteVideoTrackPublicationMap = Map<String, dynamic>.from(data['remoteVideoTrackPublication']);
      remoteVideoTrackPublication = _remoteVideoTrackPublications.firstWhere(
        (RemoteVideoTrackPublication p) => p.trackSid == remoteVideoTrackPublicationMap['sid'],
        orElse: () => RemoteVideoTrackPublication.fromMap(remoteVideoTrackPublicationMap, this),
      );
      if (!_remoteVideoTrackPublications.contains(remoteVideoTrackPublication)) {
        _remoteVideoTrackPublications.add(remoteVideoTrackPublication);
      }
      remoteVideoTrackPublication.updateFromMap(remoteVideoTrackPublicationMap);
    }

    RemoteVideoTrack remoteVideoTrack;
    if (['videoTrackSubscribed', 'videoTrackUnsubscribed'].contains(eventName)) {
      assert(remoteVideoTrackPublication != null);
      remoteVideoTrack = remoteVideoTrackPublication.remoteVideoTrack;
      if (remoteVideoTrack == null) {
        final remoteVideoTrackMap = Map<String, dynamic>.from(data['remoteVideoTrack']);
        remoteVideoTrack = RemoteVideoTrack.fromMap(remoteVideoTrackMap, this);
      }
    }

    final remoteParticipantEvent = RemoteParticipantEvent(this, remoteVideoTrackPublication, remoteVideoTrack);

    switch (eventName) {
      case 'videoTrackSubscribed':
        assert(remoteVideoTrack != null);
        _onVideoTrackSubscribed.add(remoteParticipantEvent);
        break;
      case 'videoTrackUnsubscribed':
        assert(remoteVideoTrack != null);
        _remoteVideoTrackPublications.remove(remoteVideoTrackPublication);
        _onVideoTrackUnsubscribed.add(remoteParticipantEvent);
        break;
    }
  }
}
