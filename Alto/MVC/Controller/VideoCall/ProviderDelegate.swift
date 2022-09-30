/*
	Copyright (C) 2016 Apple Inc. All Rights Reserved.
	See LICENSE.txt for this sample’s licensing information
	
	Abstract:
	CallKit provider delegate class, which conforms to CXProviderDelegate protocol
*/

import Foundation
import UIKit
import CallKit
import AVFoundation
import OpenTok

final class ProviderDelegate: NSObject, CXProviderDelegate {

    let callManager: SpeakerboxCallManager
    private let provider: CXProvider
    
    var Token : String = ""
    var Session_id : String = ""
    var Name : String = ""
    var Request_id = ""


    init(callManager: SpeakerboxCallManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: type(of: self).providerConfiguration)

        super.init()

        provider.setDelegate(self, queue: nil)
    }

    /// The app's provider configuration, representing its CallKit capabilities
    static var providerConfiguration: CXProviderConfiguration {
        let localizedName = NSLocalizedString("Alto", comment: "AltO.Cool")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)

        providerConfiguration.supportsVideo = true

        providerConfiguration.maximumCallsPerCallGroup = 1

        providerConfiguration.supportedHandleTypes = [.generic]

        providerConfiguration.iconTemplateImageData = #imageLiteral(resourceName: "logo").pngData()

        providerConfiguration.ringtoneSound = "Ringtone.caf"
        
        return providerConfiguration
    }

    func EndCall()  {
        guard let call = callManager.callWithUUID(uuid: c_uuid as UUID) else {
            return
        }
        callManager.end(call: call)
    }
    func OutGoingCall()  {
        
        
        callManager.startCall(handle: "Alto")
        
//        let uuid = NSUUID()
//
//        guard let call = callManager.callWithUUID(uuid: uuid as UUID) else {
//            return
//        }
//        provider.reportOutgoingCall(with: uuid as UUID, connectedAt: call.connectDate)
    }
    
    // MARK: Incoming Calls

    /// Use CXProvider to report the incoming call to the system
    func reportIncomingCall(uuid: UUID,name : String , request_id : String , token : String ,sessionID: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        let update = CXCallUpdate()
        c_uuid = uuid as NSUUID
        update.remoteHandle = CXHandle(type: .generic, value: name)
        update.hasVideo = hasVideo
        Name = name
        Request_id = request_id
        Token = token
        Session_id = sessionID

        // pre-heat the AVAudioSession
        //OTAudioDeviceManager.setAudioDevice(OTDefaultAudioDevice.sharedInstance())
        
        // Report the incoming call to the system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            /*
                Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
                since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                let call = SpeakerboxCall(uuid: uuid)
                call.handle = name

                self.callManager.addCall(call)
            }
            
            completion?(error as NSError?)
        }
    }

    // MARK: CXProviderDelegate

    func providerDidReset(_ provider: CXProvider) {
        print("Provider did reset")
        /*
            End any ongoing calls if the provider resets, and remove them from the app's list of calls,
            since they are no longer valid.
         */
    }

    var outgoingCall: SpeakerboxCall?
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        // Create & configure an instance of SpeakerboxCall, the app's model class representing the new outgoing call.
        let call = SpeakerboxCall(uuid: action.callUUID, isOutgoing: true)
        call.handle = action.handle.value
        
        
        /*
            Configure the audio session, but do not start call audio here, since it must be done once
            the audio session has been activated by the system after having its priority elevated.
         */
        // https://forums.developer.apple.com/thread/64544
        // we can't configure the audio session here for the case of launching it from locked screen
        // instead, we have to pre-heat the AVAudioSession by configuring as early as possible, didActivate do not get called otherwise
        // please look for  * pre-heat the AVAudioSession *
        configureAudioSession()
        
        /*
            Set callback blocks for significant events in the call's lifecycle, so that the CXProvider may be updated
            to reflect the updated state.
         */
        call.hasStartedConnectingDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, startedConnectingAt: call.connectingDate)
        }
        call.hasConnectedDidChange = { [weak self] in
            self?.provider.reportOutgoingCall(with: call.uuid, connectedAt: call.connectDate)
        }

        self.outgoingCall = call
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }

    var answerCall: SpeakerboxCall?
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideoCallViewController")  as! VideoCallViewController
        vc.isIncoming = true
        vc.Request_id = Int(Request_id) ?? 0
        vc.kToken = Token
            
        vc.kSessionId = Session_id
            
            let navi = UINavigationController.init(rootViewController: vc)
            navi.isNavigationBarHidden = true
            navi.modalPresentationStyle = .overCurrentContext
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(navi, animated: false)
            }

        /*
            Configure the audio session, but do not start call audio here, since it must be done once
            the audio session has been activated by the system after having its priority elevated.
         */
        
        // https://forums.developer.apple.com/thread/64544
        // we can't configure the audio session here for the case of launching it from locked screen
        // instead, we have to pre-heat the AVAudioSession by configuring as early as possible, didActivate do not get called otherwise
        // please look for  * pre-heat the AVAudioSession *
        configureAudioSession()

        
        
        self.answerCall = call
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }

    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        // Trigger the call to be ended via the underlying network service.
        call.endCall()

        // Signal to the system that the action has been successfully performed.
        action.fulfill()

        // Remove the ended call from the app's list of calls.
        callManager.removeCall(call)
    }

    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }

        // Update the SpeakerboxCall's underlying hold state.
        call.isOnHold = action.isOnHold

        // Stop or start audio in response to holding or unholding the call.
        call.isMuted = call.isOnHold

        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        // Retrieve the SpeakerboxCall instance corresponding to the action's call UUID
        guard let call = callManager.callWithUUID(uuid: action.callUUID) else {
            action.fail()
            return
        }
        
        call.isMuted = action.isMuted
        
        // Signal to the system that the action has been successfully performed.
        action.fulfill()
    }

    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("Timed out \(#function)")

        // React to the action timeout if necessary, such as showing an error UI.
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Received \(#function)")
        
        // If we are returning from a hold state
        if answerCall?.hasConnected ?? false {
            //configureAudioSession()
            // See more details on how this works in the OTDefaultAudioDevice.m method handleInterruptionEvent
            sendFakeAudioInterruptionNotificationToStartAudioResources();
            return
        }
        if outgoingCall?.hasConnected ?? false {
            //configureAudioSession()
            // See more details on how this works in the OTDefaultAudioDevice.m method handleInterruptionEvent
            sendFakeAudioInterruptionNotificationToStartAudioResources()
            return
        }
        
        // Start call audio media, now that the audio session has been activated after having its priority boosted.
        outgoingCall?.startCall(withAudioSession: audioSession) { [weak self] success in
            guard let outgoingCall = self?.outgoingCall else { return }
            if success {
                self?.callManager.addCall(outgoingCall)
                self?.outgoingCall?.startAudio()
            } else {
                self?.callManager.end(call: outgoingCall)
            }
        }
        
        answerCall?.answerCall(withAudioSession: audioSession) { success in
            if success {
                self.answerCall?.startAudio()
            }
        }
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Received \(#function)")

        /*
             Restart any non-call related audio now that the app's audio session has been
             de-activated after having its priority restored to normal.
         */
        if outgoingCall?.isOnHold ?? false || answerCall?.isOnHold ?? false {
            print("Call is on hold. Do not terminate any call")
            return
        }
        
        outgoingCall?.endCall()
        outgoingCall = nil
        answerCall?.endCall()
        answerCall = nil
        callManager.removeAllCalls()
    }
    
    func sendFakeAudioInterruptionNotificationToStartAudioResources() {
        var userInfo = Dictionary<AnyHashable, Any>()
        let interrupttioEndedRaw = AVAudioSession.InterruptionType.ended.rawValue
        userInfo[AVAudioSessionInterruptionTypeKey] = interrupttioEndedRaw
        NotificationCenter.default.post(name: AVAudioSession.interruptionNotification, object: self, userInfo: userInfo)
    }
    
    func configureAudioSession() {
        // See https://forums.developer.apple.com/thread/64544
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default)
            try session.setActive(true)
            try session.setMode(AVAudioSession.Mode.videoChat)
            try session.setPreferredSampleRate(44100.0)
            try session.setPreferredIOBufferDuration(0.005)
        } catch {
            print(error)
        }
    }
}
