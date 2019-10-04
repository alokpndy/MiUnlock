//
//  ViewController.swift
//  miMac
//
//  Created by Alok pandey on 03/10/19.
//  Copyright © 2019 Alok pandey. All rights reserved.
//

import Cocoa



class ViewController: NSViewController {
    
    @IBOutlet weak var label: NSTextField!
    var bandData : [MiBand] = []
    lazy var miBand = MBand(log: { [weak self] logEntry in self?.log(logEntry)})
   // lazy var timer = Timer(timeInterval: 4.0, repeats: true) { _ in
    //    print("RUNNIG TIMER NOW _______________!")
     //   self.miBand.discoverDevices()
      //}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        _ = miBand
     //   _ = timer
        self.label.stringValue = "Starting"
      //  RunLoop.current.add(timer, forMode: .common)
    }

    
    func log(_ string: MiBand) {
        bandData.append(string)
        print("Updated Value is \(string)")
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func connectDevice(_ sender: Any) {
        self.miBand.lockDeviceScreen()

        
    }
    
}

