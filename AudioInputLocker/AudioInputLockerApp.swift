import SwiftUI
import CoreAudio
import SimplyCoreAudio
import ServiceManagement
import LaunchAtLogin

@available(macOS 13.0, *)
@main
struct AudioInputLockApp: App {
    @StateObject private var deviceManager = AudioDeviceManager()

    var body: some Scene {
        // Hide the app from the Dock
        let _ = NSApplication.shared.setActivationPolicy(.accessory)

        // Create menu bar extra
        MenuBarExtra("Audio Input Lock", systemImage: "mic") {
            Text("Audio Input Lock")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top, 8)

            Divider()

            if deviceManager.audioDevices.isEmpty {
                Text("No input devices found")
                    .padding(.horizontal)
                    .padding(.vertical, 4)
            } else {
                ForEach(deviceManager.audioDevices) { device in
                    Button(action: {
                        if device.isLocked {
                            deviceManager.unlockDevice()
                        } else {
                            deviceManager.lockDevice(deviceID: device.id)
                        }
                    }) {
                        HStack {
                            // Default indicator
                            if device.isDefault {
                                Image(systemName: "checkmark")
                            } else {
                                Text("").frame(width: 16)
                            }
                            
                            Text(device.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Locked indicator
                            if device.isLocked {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 2)
                }
            }

            Divider()

            LaunchAtLogin.Toggle()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .padding(.bottom, 8)
            .keyboardShortcut("q", modifiers: .command)
        }
        .menuBarExtraStyle(.window)
    }
}
