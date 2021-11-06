//
//  FacetimeView.swift
//  MockProject
//
//  Created by Jared Davidson on 11/6/21.
//

import Foundation
import SwiftUI
import HMSSDK

struct FacetimeView: View {
	var hmsSDK = HMSSDK.build()
	@State var localTrack = HMSVideoTrack()
	@State var friendTrack = HMSVideoTrack()
	let tokenProvider = TokenProvider()
	@StateObject var viewModel: ViewModel
	
	
	
	var body: some View {
		ZStack(alignment: .bottomTrailing) {
			VideoView(track: friendTrack)
			VideoView(track: localTrack)
				.frame(width: 150, height: 250, alignment: .center)
				.padding()
		}
		.onAppear(perform: {
			joinRoom()
			listen()
		})
		.onDisappear(perform: {
			
		})
	}
	
	func endRoom() {
		self.viewModel
	}
	
	func listen() {
		self.viewModel.addVideoView = {
			track in
			hmsSDK.localPeer?.localAudioTrack()?.setMute(true)
			hmsSDK.localPeer?.localVideoTrack()?.stopCapturing()
			self.localTrack = hmsSDK.localPeer?.localVideoTrack() as! HMSVideoTrack
			self.friendTrack = track
		}
		
		self.viewModel.removeVideoView = {
			track in
			self.friendTrack = track
		}
	}
	
	
	func joinRoom() {
		tokenProvider.getToken(for: "6186d0e8be6c3c0b3514ff6b", role: "host", completion: {
			token, error in
			let config = HMSConfig(authToken: token ?? "")
			hmsSDK.join(config: config, delegate: self.viewModel)
		})
	}
}

extension FacetimeView {
	class ViewModel: ObservableObject, HMSUpdateListener {
		
		@Published var addVideoView: ((_ videoView: HMSVideoTrack) -> ())?
		@Published var removeVideoView: ((_ videoView: HMSVideoTrack) -> ())?
		
		func on(join room: HMSRoom) {
			
		}
		
		func on(room: HMSRoom, update: HMSRoomUpdate) {
			
		}
		
		func on(peer: HMSPeer, update: HMSPeerUpdate) {
			
		}
		
		func on(track: HMSTrack, update: HMSTrackUpdate, for peer: HMSPeer) {
			switch update {
			case .trackAdded:
				if let videoTrack = track as? HMSVideoTrack {
					addVideoView?(videoTrack)
				}
			case .trackRemoved:
				if let videoTrack = track as? HMSVideoTrack {
					removeVideoView?(videoTrack)
				}
			default:
				break
			}
		}
		
		func on(error: HMSError) {
			
		}
		
		func on(message: HMSMessage) {
			
		}
		
		func on(updated speakers: [HMSSpeaker]) {
			
		}
		
		func onReconnecting() {
			
		}
		
		func onReconnected() {
			
		}
		
	}
}
