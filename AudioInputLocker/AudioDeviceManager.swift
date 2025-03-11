import SimplyCoreAudio
import SwiftUI

// MARK: - Models & Managers
@available(macOS 13.0, *)
class AudioDeviceManager: ObservableObject {
    private var audio = SimplyCoreAudio()
    @Published var audioDevices: [AudioDevice] = []
    private let storageKey = "lockedDeviceID"

    // Add UserDefaults persistence
    @Published var currentlyLockedDeviceID: Int? {
        didSet {
            if let id = currentlyLockedDeviceID {
                UserDefaults.standard.set(id, forKey: storageKey)
            } else {
                UserDefaults.standard.removeObject(forKey: storageKey)
            }
        }
    }
    @Published var delay: Double = 0.3

    init() {
        // Load persisted ID on initialization
        self.currentlyLockedDeviceID = UserDefaults.standard.integer(forKey: storageKey)
        if UserDefaults.standard.integer(forKey: storageKey) == 0 {
            self.currentlyLockedDeviceID = nil
        }
        
        // Rest of existing init code...
        updateDeviceList()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(defaultDeviceChanged),
            name: .defaultInputDeviceChanged,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(deviceListChanged),
            name: .deviceListChanged,
            object: nil
        )
        
        // Ensure persisted device is locked on relaunch
        if let lockedID = currentlyLockedDeviceID {
            ensureDeviceLocked(deviceID: lockedID)
        }
        

    }

    
    @objc func updateDeviceList() {
        let devices = audio.allInputDevices
            .map { device in
                AudioDevice(
                    id: Int(device.id),
                    name: device.name,
                    isDefault: device.isDefaultInputDevice,
                    isLocked: currentlyLockedDeviceID ?? -1 == device.id
                )
            }
            .sorted { $0.name < $1.name }
        
        DispatchQueue.main.async {
            self.audioDevices = devices
        }
        
        // Ensure locked device if needed
        if let lockedID = currentlyLockedDeviceID {
            ensureDeviceLocked(deviceID: lockedID)
        }
    }
    
    func lockDevice(deviceID: Int) {
        guard let device = audio.allInputDevices.first(where: { $0.id == deviceID }) else { return }
        
        self.currentlyLockedDeviceID = deviceID
        
        // Set as default device
        device.isDefaultInputDevice = true
        
        updateDeviceList()
    }
    
    func unlockDevice() {
        self.currentlyLockedDeviceID = nil
        updateDeviceList()
    }

    @objc func defaultDeviceChanged() {
        guard let lockedID = currentlyLockedDeviceID else { return }
        
        // Add a small delay before restoring the locked device
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.ensureDeviceLocked(deviceID: lockedID)
        }
    }
    
    @objc func deviceListChanged() {
        updateDeviceList()
    }

    func ensureDeviceLocked(deviceID: Int) {
        guard let device = audio.allInputDevices.first(where: { $0.id == deviceID }) else { return }
        
        if !device.isDefaultInputDevice {
            device.isDefaultInputDevice = true
        }
    }
}

struct AudioDevice: Identifiable {
    let id: Int
    let name: String
    let isDefault: Bool
    let isLocked: Bool
}
