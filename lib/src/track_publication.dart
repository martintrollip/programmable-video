part of twilio_unofficial_programmable_video;

abstract class TrackPublication {
  /// The SID of a track.
  ///
  /// This value uniquely identifies the track within the scope of a [Room].
  String get trackSid;

  /// The name of the published track.
  String get trackName;

  /// Returns `true` if the track is enabled or `false` otherwise.
  bool get isTrackEnabled;
}
