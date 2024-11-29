//
//  ContentView.swift
//  iOSCameraViewerObjectiveC
//
//  Created by MIEUN KO on 11/19/24.
//

import SwiftUI

struct ContentView: View {
	var testObj = CameraExport()
	//var testObj = CameraController()
	var body: some View {
		ZStack {
			VStack {
				//CameraView(image: $viewModel.currentFrame)
				//	.ignoresSafeArea()
				Spacer()
				
				HStack {
					Button(action: {
						testObj.connect()
					}, label: {
						Text("Connect Device")
					})
					Spacer()
					
					Button(action: {
						testObj.disconnect()
					}, label: {
						Text("Disconnect Device")
					})
					Spacer()
					
					Button(action: {
						testObj.startStreaming()
					}, label: {
						Text("Start Capture")
					})
					Spacer()
					
					Button(action: {
						testObj.stopStreaming()
					}, label: {
						Text("Stop Capture")
					})
				}
			}
		}.padding()
    }
}

#Preview {
    ContentView()
}
