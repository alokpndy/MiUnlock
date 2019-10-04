//
//  MiBandService.swift
//  inFullBand
//
//  Created by Mikołaj Chmielewski on 28.11.2017.
//  Copyright © 2017 inFullMobile. All rights reserved.
//

import Foundation
import CoreBluetooth



class MBand : NSObject {
    
    var isLocked : Bool
    typealias LoggerFuction = (MiBand) -> Void
    lazy var manager = CBCentralManager(delegate: self, queue: DispatchQueue.main, options: nil)
    
    private var band: CBPeripheral? {
        didSet {
            oldValue?.delegate = nil
            guard let band = band else { return }
            band.delegate = self
        }
    }
    
    init(log: @escaping LoggerFuction) {
        self.isLocked = false
        super.init()
        _ = manager
        manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    func discoverDevices() {
        manager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    
    func lockDeviceScreen() {
        let libHandle = dlopen("/System/Library/PrivateFrameworks/login.framework/Versions/Current/login", RTLD_LAZY)
        let sym = dlsym(libHandle, "SACLockScreenImmediate")
        typealias myFunction = @convention(c) () -> Void
        let SACLockScreenImmediate = unsafeBitCast(sym, to: myFunction.self)
        SACLockScreenImmediate()
    }
    
    func enterPassword()  {
        let myAppleScript = "tell application \"System Events\" \nkeystroke \"password\" \ndelay 1 \nkeystroke return \nend tell"
        if let scriptObject = NSAppleScript(source: myAppleScript) {
            var errorDict: NSDictionary? = nil
            _ = scriptObject.executeAndReturnError(&errorDict)
            if errorDict != nil {
                print("error: \(String(describing: errorDict))")
            } else {
                self.isLocked = false
            }
        }
    }
    
    
    
}


extension MBand : CBCentralManagerDelegate {
    
    // NonOptional
    // called whenever the Bluetooth module changes state, called just after the manager has been initialized.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    // called every time the manager discovers a new peripheral. // scanForPeripherals
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.realName
        if name == "Mi Smart Band 4"  {
            let uniqueIdentifier : UUID = peripheral.identifier
            let rssivalue = RSSI.intValue
            print("DISCOVERED DEVICES: \(name) \n and rssi is \(rssivalue) \n and unique id is \(uniqueIdentifier)")
            if rssivalue  < (-48) {
                // ble is away from Mac
                if self.isLocked == false {
                    self.lockDeviceScreen()
                    self.isLocked = true
                    sleepDisplay()
                }
                
                
            } else {
                // device in range of Mac
                if self.isLocked == true {
                    wakeDisplay()
                    self.enterPassword()
                    // self.isLocked = false
                }
            }
        }
    }
    
}


// MARK: - Notifications about its state changes
extension MBand: CBPeripheralDelegate {
}

