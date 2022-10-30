import CoreAudio
import Foundation
import SimplyCoreAudio
import SwiftCLI

let audio = SimplyCoreAudio()

func getAvailableInputDevices() -> String {
    let devices = audio.allInputDevices
    let pad = devices.map { "\($0.id)".count }.max() ?? 0
    return devices.sorted(by: {
        $0.id < $1.id
    }).map {
        let id = "\($0.id)".padding(toLength: pad, withPad: " ", startingAt: 0)
        return "\(id) - \($0.name)"
    }.joined(separator: "\n")
}

class PrintCommand: Command {
    let name = "ls"
    let shortDescription = "Print available input devices"
    
    func execute() throws {
        stdout <<< getAvailableInputDevices()
    }
}

class LockCommand: Command {
    let name = "lock"
    let shortDescription = "Lock input device"
    @Param var id: Int
    @Key("-d", "--delay", description: "Delay to lock input device when changed, in seconds, double")
    var delay: Double?
    
    func execute() throws {
        let devices = audio.allInputDevices
        let selected = devices.first {
            $0.id == id
        }
        
        guard let selected = selected else {
            stderr <<< "No such device `id == \(id)`, available input devices:"
            stderr <<< getAvailableInputDevices()
            return
        }
        
        func detectAndLock() {
            if !selected.isDefaultInputDevice {
                let current = audio.defaultInputDevice?.name ?? "Unknown"
                print("Current input device is `\(current)`, instead of selected `\(selected.name)`, locking...")
                selected.isDefaultInputDevice = true
            }
        }
        
        detectAndLock()
        
        NotificationCenter.default.addObserver(
            forName: .defaultInputDeviceChanged,
            object: nil,
            queue: .main
        ) { (notification) in
            if !selected.isDefaultInputDevice {
                print("Input Device Changed!")
            }
            let seconds = self.delay ?? 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                detectAndLock()
            }
        }
        
        print("Running")
        print("Locking to `\(selected.name)`")
        RunLoop.main.run()
    }
}

let ail = CLI(name: "ail")
ail.commands = [PrintCommand(), LockCommand()]
ail.go()
