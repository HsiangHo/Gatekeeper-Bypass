//
//  AppDelegate.swift
//  Gatekeeper-Bypass
//
//  Created by Jovi on 3/21/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    var statusItem: NSStatusItem?
    var mainMenu: NSMenu?
    var menuItemAppStoreIdentifiedDevelopers: NSMenuItem?
    var menuItemAnywhere: NSMenuItem?
    var menuItemAbout: NSMenuItem?
    var menuItemQuit: NSMenuItem?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        statusItem = NSStatusBar.system.statusItem(withLength: -1)
        if let item = statusItem{
            item.sendAction(on: [.leftMouseUp, .rightMouseUp])
            item.action = #selector(statusItem_click(_:))
            item.target = self
        }
        
        mainMenu = NSMenu.init(title: "mainMenu")
        if let menu = mainMenu {
            menuItemAppStoreIdentifiedDevelopers = menu.addItem(withTitle: "App Store & identified developers", action: #selector(chooseAppStoreAndIdentifiedDeveloper_click(_:)), keyEquivalent: "1")
            menuItemAppStoreIdentifiedDevelopers?.image = NSImage.init(named: "NSStatusAvailable")
            menuItemAppStoreIdentifiedDevelopers?.target = self
            
            menuItemAnywhere = menu.addItem(withTitle: "Anywhere", action: #selector(chooseAnywhere_click(_:)), keyEquivalent: "2")
            menuItemAnywhere?.image = NSImage.init(named: "NSStatusPartiallyAvailable")
            menuItemAnywhere?.target = self
            
            menu.addItem(NSMenuItem.separator())
            menuItemAbout = menu.addItem(withTitle: "About Gatekeeper-Bypass", action: #selector(about_click(_:)), keyEquivalent: "")
            menuItemAbout?.target = self
            menu.addItem(NSMenuItem.separator())
            
            menuItemQuit = menu.addItem(withTitle: "Quit", action: #selector(quit_click(_:)), keyEquivalent: "q")
            menuItemQuit?.target = self
        }
        
        __updateStatusItem()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @objc func statusItem_click(_ sender: NSButton){
        guard let event = NSApp.currentEvent else {
            return;
        }
        
        if event.type == .rightMouseUp || event.modifierFlags.contains(.option) {
            if __gatekeeperStatus(){
                __setGatekeeperStatus(false)
            }else{
                __setGatekeeperStatus(true)
            }
            __updateStatusItem()
        }else{
            guard let menu = mainMenu else{
                return;
            }
            statusItem?.popUpMenu(menu)
        }
    }
    
    @objc func chooseAppStoreAndIdentifiedDeveloper_click(_ sender: NSButton){
        __setGatekeeperStatus(true)
        __updateStatusItem()
    }
    
    @objc func chooseAnywhere_click(_ sender: NSButton){
        __setGatekeeperStatus(false)
        __updateStatusItem()
    }
    
    @objc func about_click(_ sender: NSButton){
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(nil);
    }
    
    @objc func quit_click(_ sender: NSButton){
        NSApp.terminate(nil)
    }
    
    func __setGatekeeperStatus(_ bFlag: Bool) -> Void {
        let args = bFlag ? ["-c", "spctl --master-enable"] : ["-c", "spctl --master-disable"]
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = args
        task.launch()
    }
    
    func __gatekeeperStatus() -> Bool {
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = ["-c", "spctl --status"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        
        task.launch()
        
        var bRslt = false
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue){
            bRslt = output.range(of: "enabled").location != NSNotFound
        }
        
        return bRslt;
    }
    
    func __updateStatusItem() -> Void {
        if let item = statusItem{
            item.image = NSImage.init(named: "NSStatusAvailable")
            item.title = "Gatekeeper: On"
            if !__gatekeeperStatus() {
                item.image = NSImage.init(named: "NSStatusPartiallyAvailable")
                item.title = "Gatekeeper: Off"
            }
        }
    }
}

