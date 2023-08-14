package twilio.flutter.twilio_programmable_video

import android.content.Context
import android.view.Gravity
import android.widget.FrameLayout
import com.twilio.video.VideoScaleType
import com.twilio.video.VideoTrack
import com.twilio.video.VideoView
import io.flutter.plugin.common.MessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory

class ParticipantViewFactory(createArgsCodec: MessageCodec<Any>, private val plugin: PluginHandler) : PlatformViewFactory(createArgsCodec) {
    private val TAG = "RoomListener"

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        var videoTrack: VideoTrack? = null
        val params = args as? Map<*, *> ?: throw IllegalStateException("args cannot be null")

        if (params["isLocal"] == true) {
            debug("create => constructing local view with params: '${params.values.joinToString(", ")}'")
            val localVideoTrackName = params["name"] as? String ?: ""
            if (localVideoTrackName != "" && localVideoTrackName in TwilioProgrammableVideoPlugin.localVideoTracks) {
                videoTrack = TwilioProgrammableVideoPlugin.localVideoTracks[localVideoTrackName]
            } else {
                val localParticipant = plugin.getLocalParticipant()
                if (localParticipant?.localVideoTracks?.isNotEmpty() == true) {
                    videoTrack = localParticipant.localVideoTracks.firstOrNull()?.localVideoTrack
                }
            }
        } else {
            debug("create => constructing view with params: '${params.values.joinToString(", ")}'")
            if ("remoteParticipantSid" in params && "remoteVideoTrackSid" in params) {
                val remoteParticipant = plugin.getRemoteParticipant(params["remoteParticipantSid"] as String)
                val remoteVideoTrack = remoteParticipant?.remoteVideoTracks?.find { it.trackSid == params["remoteVideoTrackSid"] }
                if (remoteParticipant != null && remoteVideoTrack != null) {
                    videoTrack = remoteVideoTrack.remoteVideoTrack
                }
            }
        }

        if (videoTrack == null) {
            throw IllegalStateException("Could not create VideoTrack")
        }
        val videoView = VideoView(context as Context)
        val layoutParams = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.WRAP_CONTENT,
            FrameLayout.LayoutParams.WRAP_CONTENT
        ).apply {
            gravity = Gravity.CENTER
        }
        videoView.setLayoutParams(layoutParams)

        val scaleType = this.getScaleTypeFromInt(params["renderMode"] as Int)
        videoView.mirror = params["mirror"] as Boolean
        videoView.videoScaleType = scaleType

        return ParticipantView(videoView, videoTrack)
    }

    internal fun debug(msg: String) {
        TwilioProgrammableVideoPlugin.debug("$TAG::$msg")
    }

    private fun getScaleTypeFromInt(typeInt: Int): VideoScaleType {
        if (typeInt == 2) {
            return VideoScaleType.ASPECT_FILL
        } else if (typeInt == 1) {
            return VideoScaleType.ASPECT_FIT
        } else {
            return VideoScaleType.ASPECT_BALANCED
        }
    }
}
