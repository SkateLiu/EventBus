//
//  UIDevice+Extensions.swift
//  GDExtension
//
//  Created by Objc on 2019/8/14.
//

import Foundation
import UIKit

// MARK: - Global variables

/// Used to store BFAPNSIdentifier in defaults.
private let GDAPNSIdentifierDefaultsKey = "GDAPNSIdentifier"
/// Used to store BFDeviceIdentifier in defaults.
internal let GDDeviceIdentifierDefaultsKey = "GDDeviceIdentifier"

// MARK: - UIDevice extension
/// This extesion adds some useful functions to UIDevice
public extension GDReference where Base: UIDevice {
    // MARK: - Variables
    
    /// Get OS version string.
    static var osVersion: String {
        return UIDevice.current.systemVersion
    }
    
    /// Get current device is Bangs screen
    static var isIphoneX: Bool {
        if #available(iOS 11, *) {
            if let w = UIApplication.shared.delegate?.window,
                let window = w, window.safeAreaInsets.left > 0 || window.safeAreaInsets.bottom > 0 {
                return true
            }
            return false
        }
        return false
    }
    
    /// Get current device is Landscape
    static var isLandscape: Bool {
        return UIApplication.shared.statusBarOrientation.isLandscape
    }
    
//    static var macAddress: String {
//        let index  = Int32(if_nametoindex("en0"))
//        let bsdData = "en0".data(using: String.Encoding.utf8)!
//        var mib : [Int32] = [CTL_NET,AF_ROUTE,0,AF_LINK,NET_RT_IFLIST,index]
//        var len = 0;
//
//        if sysctl(&mib,UInt32(mib.count), nil, &len,nil,0) < 0 {
//            return "00:00:00:00:00:00"
//        }
//
//        var buffer = [CChar](repeating: 0, count: len)
//        if sysctl(&mib, UInt32(mib.count), &buffer, &len, nil, 0) < 0 {
//            return "00:00:00:00:00:00"
//        }
//
//        let infoData = NSData(bytes: buffer, length: len)
//        var interfaceMsgStruct = if_msghdr()
//
//        infoData.getBytes(&interfaceMsgStruct, length: MemoryLayout.size(ofValue: if_msghdr()))
//        let socketStructStart = MemoryLayout.size(ofValue: if_msghdr()) + 1
//        let socketStructData = infoData.subdata(with: NSMakeRange(socketStructStart, len - socketStructStart))
//
//        let rangeOfToken = socketStructData.range(of: bsdData, options: NSData.SearchOptions(rawValue: 0), in: Range(NSMakeRange(0, socketStructData.count)))
//
//        let macAddressData = socketStructData.subdata(in: Range(NSMakeRange(rangeOfToken?.startIndex ?? 0 + 3, 6)) ?? Range(NSMakeRange(0, 0))!)
//        var macAddressDataBytes = [UInt8](repeating: 0, count: 6)
//        macAddressData.copyBytes(to: &macAddressDataBytes, count: 6)
//        return macAddressDataBytes.map({ String(format:"%02x", $0) }).joined(separator: ":")
//    }
    
    /// Returns OS version without subversions.
    ///
    /// Example: 9.
    static var osMajorVersion: Int {
        let subVersion = UIDevice.current.systemVersion.substring(to: ".")
        guard let intSubVersion = Int(subVersion) else {
            return 0
        }
        return intSubVersion
    }
    
    /// Returns device platform string.
    ///
    /// Example: "iPhone7,2".
    ///
    /// - Returns: Returns the device platform string.
    static var hardwareModel: String {
        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var nameCopy = name
        var size: Int = 2
        sysctl(&nameCopy, 2, nil, &size, &name, 0)
        var hwMachine = [CChar](repeating: 0, count: Int(size))
        sysctl(&nameCopy, 2, &hwMachine, &size, &name, 0)
        
        let hardware = String(cString: hwMachine)
        return hardware
    }
    
    // swiftlint:disable switch_case_on_newline
    
    /// Returns the user-friendly device platform string.
    /// More info [here](https://www.theiphonewiki.com/wiki/Models).
    ///
    /// Example: "iPad Air (Cellular)".
    ///
    /// - Returns: Returns the user-friendly device platform string.
    static var detailedModel: String {
        let platform: String = hardwareModel
        
        switch platform {
        // iPhone 2G
        case "iPhone1,1":       return "iPhone 2G"
        // iPhone 3G
        case "iPhone1,2":       return "iPhone 3G"
        // iPhone 3GS
        case "iPhone2,1":       return "iPhone 3GS"
        // iPhone 4
        case "iPhone3,1":       return "iPhone 4"
        case "iPhone3,2":       return "iPhone 4"
        case "iPhone3,3":       return "iPhone 4"
        // iPhone 4S
        case "iPhone4,1":       return "iPhone 4S"
        // iPhone 5
        case "iPhone5,1":       return "iPhone 5"
        case "iPhone5,2":       return "iPhone 5"
        // iPhone 5c
        case "iPhone5,3":       return "iPhone 5c"
        case "iPhone5,4":       return "iPhone 5c"
        // iPhone 5s
        case "iPhone6,1":       return "iPhone 5s"
        case "iPhone6,2":       return "iPhone 5s"
        // iPhone 6 / 6 Plus
        case "iPhone7,1":       return "iPhone 6 Plus"
        case "iPhone7,2":       return "iPhone 6"
        // iPhone 6s / 6s Plus
        case "iPhone8,1":       return "iPhone 6s"
        case "iPhone8,2":       return "iPhone 6s Plus"
        // iPhone SE
        case "iPhone8,4":       return "iPhone SE"
        // iPhone 7 / 7 Plus
        case "iPhone9,1":       return "iPhone 7"
        case "iPhone9,2":       return "iPhone 7 Plus"
        case "iPhone9,3":       return "iPhone 7"
        case "iPhone9,4":       return "iPhone 7 Plus"
        // iPhone 8 / 8 Plus
        case "iPhone10,1":      return "iPhone 8"
        case "iPhone10,2":      return "iPhone 8 Plus"
        case "iPhone10,4":      return "iPhone 8"
        case "iPhone10,5":      return "iPhone 8 Plus"
        // iPhone X
        case "iPhone10,3":      return "iPhone X"
        case "iPhone10,6":      return "iPhone X"
        // iPhone XS / iPhone XS Max
        case "iPhone11,2":      return "iPhone XS"
        case "iPhone11,4":      return "iPhone XS Max"
        case "iPhone11,6":      return "iPhone XS Max"
        // iPhone XR
        case "iPhone11,8":      return "iPhone XR"
        // iPhone 11
        case "iPhone12,1":      return "iPhone 11"
        case "iPhone12,3":      return "iPhone 11 Pro"
        case "iPhone12,5":      return "iPhone 11 Pro Max"
        // iPod touch
        case "iPod1,1":         return "iPod touch (1st generation)"
        case "iPod2,1":         return "iPod touch (2nd generation)"
        case "iPod3,1":         return "iPod touch (3rd generation)"
        case "iPod4,1":         return "iPod touch (4th generation)"
        case "iPod5,1":         return "iPod touch (5th generation)"
        case "iPod7,1":         return "iPod touch (6th generation)"
        // iPad / iPad Air
        case "iPad1,1":         return "iPad"
        case "iPad2,1":         return "iPad 2"
        case "iPad2,2":         return "iPad 2"
        case "iPad2,3":         return "iPad 2"
        case "iPad2,4":         return "iPad 2"
        case "iPad3,1":         return "iPad 3"
        case "iPad3,2":         return "iPad 3"
        case "iPad3,3":         return "iPad 3"
        case "iPad3,4":         return "iPad 4"
        case "iPad3,5":         return "iPad 4"
        case "iPad3,6":         return "iPad 4"
        case "iPad4,1":         return "iPad Air"
        case "iPad4,2":         return "iPad Air"
        case "iPad4,3":         return "iPad Air"
        case "iPad5,3":         return "iPad Air 2"
        case "iPad5,4":         return "iPad Air 2"
        case "iPad6,11":         return "iPad Air 2"
        case "iPad6,12":         return "iPad Air 2"
        // iPad mini
        case "iPad2,5":         return "iPad mini"
        case "iPad2,6":         return "iPad mini"
        case "iPad2,7":         return "iPad mini"
        case "iPad4,4":         return "iPad mini 2"
        case "iPad4,5":         return "iPad mini 2"
        case "iPad4,6":         return "iPad mini 2"
        case "iPad4,7":         return "iPad mini 3"
        case "iPad4,8":         return "iPad mini 3"
        case "iPad4,9":         return "iPad mini 3"
        // iPad Pro 9.7
        case "iPad6,3":         return "iPad Pro (9.7-inch)"
        case "iPad6,4":         return "iPad Pro (9.7-inch)"
        // iPad Pro 10.5
        case "iPad7,3":         return "iPad Pro (10.5-inch)"
        case "iPad7,4":         return "iPad Pro (10.5-inch)"
        // iPad Pro 11
        case "iPad8,1":         return "iPad Pro (11-inch)"
        case "iPad8,2":         return "iPad Pro (11-inch)"
        case "iPad8,3":         return "iPad Pro (11-inch)"
        case "iPad8,4":         return "iPad Pro (11-inch)"
        // iPad Pro 12.9
        case "iPad6,7":         return "iPad Pro (12.9-inch)"
        case "iPad6,8":         return "iPad Pro (12.9-inch)"
        case "iPad7,1":         return "iPad Pro (12.9-inch, 2nd generation)"
        case "iPad7,2":         return "iPad Pro (12.9-inch, 2nd generation)"
        case "iPad8,5":         return "iPad Pro (12.9-inch, 3rd generation)"
        case "iPad8,6":         return "iPad Pro (12.9-inch, 3rd generation)"
        case "iPad8,7":         return "iPad Pro (12.9-inch, 3rd generation)"
        case "iPad8,8":         return "iPad Pro (12.9-inch, 3rd generation)"
        // Apple TV
        case "AppleTV2,1":      return "Apple TV (2nd generation)"
        case "AppleTV3,1":      return "Apple TV (3rd generation)"
        case "AppleTV3,2":      return "Apple TV (3rd generation)"
        case "AppleTV5,3":      return "Apple TV (4th generation)"
        case "AppleTV6,2":      return "Apple TV 4K"
        // Simulator
        case "i386", "x86_64":  return "Simulator"
        default:
            return platform
        }
    }
    
    // swiftlint:enable switch_case_on_newline
    
    /// Returns current device CPU frequency.
    static var cpuFrequency: Int {
        return getSysInfo(HW_CPU_FREQ)
    }
    
    /// Returns current device BUS frequency.
    static var busFrequency: Int {
        return getSysInfo(HW_TB_FREQ)
    }
    
    /// Returns device RAM size.
    static var ramSize: Int {
        return getSysInfo(HW_MEMSIZE)
    }
    
    /// Returns device CPUs number.
    static var cpusNumber: Int {
        return getSysInfo(HW_NCPU)
    }
    
    /// Returns device total memory.
    static var totalMemory: Int {
        return getSysInfo(HW_PHYSMEM)
    }
    
    /// Returns current device non-kernel memory.
    static var userMemory: Int {
        return getSysInfo(HW_USERMEM)
    }
    
    /// Retruns if current device is running in low power mode.
    @available(iOS 9.0, *)
    static var isLowPowerModeEnabled: Bool {
        return ProcessInfo.processInfo.isLowPowerModeEnabled
    }
    
    // MARK: - Functions

    
    /// Check if current device is an iPhone.
    ///
    /// - Returns: Returns true if it is an iPhone, otherwise false.
    static func isPhone() -> Bool {
        return hardwareModel.substring(to: 6) == "iPhone"
    }

    /// Check if current device is an iPad.
    ///
    /// - Returns: Returns true if it is an iPad, otherwise false.
    static func isPad() -> Bool {
        return hardwareModel.substring(to: 4) == "iPad"
    }

    /// Check if current device is an iPod.
    ///
    /// - Returns: Returns true if it is an iPod, otherwise false.
    static func isPod() -> Bool {
        return hardwareModel.substring(to: 4) == "iPod"
    }

    /// Check if current device is an Apple TV.
    ///
    /// - Returns: Returns true if it is an Apple TV, otherwise false.
    static func isTV() -> Bool {
        return hardwareModel.substring(to: 7) == "AppleTV"
    }

    /// Check if current device is an Applw Watch.
    ///
    /// - Returns: Returns true if it is an Apple Watch, otherwise false.
    static func isWatch() -> Bool {
        return hardwareModel.substring(to: 5) == "Watch"
    }
    
    /// Check if current device is a Simulator.
    ///
    /// - Returns: Returns true if it is a Simulator, otherwise false.
    static func isSimulator() -> Bool {
        return detailedModel == "Simulator"
    }
    
    /// Returns if current device is jailbroken.
    ///
    /// - Returns: Returns true if current device is jailbroken, otherwise false.
    static func isJailbroken() -> Bool {
        let canReadBinBash = FileManager.default.fileExists(atPath: "/bin/bash")
        if let cydiaURL = URL(string: "cydia://"), let canOpenCydia = (UIApplication.value(forKey: "sharedApplication") as? UIApplication)?.canOpenURL(cydiaURL) {
            return canOpenCydia || canReadBinBash
        } else {
            return canReadBinBash
        }
    }
    
    /// Returns system uptime.
    ///
    /// - Returns: eturns system uptime.
    static func uptime() -> TimeInterval {
        return ProcessInfo.processInfo.systemUptime
    }
    
    /// Returns sysyem uptime as Date.
    ///
    /// - Returns: Returns sysyem uptime as Date.
    static func uptimeDate() -> Date {
        return Date(timeIntervalSinceNow: -uptime())
    }
    
    /// Returns current device total disk space
    ///
    /// - Returns: Returns current device total disk space.
    static func totalDiskSpace() -> NSNumber {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return attributes[.systemSize] as? NSNumber ?? NSNumber(value: 0.0)
        } catch {
            return NSNumber(value: 0.0)
        }
    }
    
    /// Returns current device free disk space.
    ///
    /// - Returns: Returns current device free disk space.
    static func freeDiskSpace() -> NSNumber {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
            return attributes[.systemFreeSize] as? NSNumber ?? NSNumber(value: 0.0)
        } catch {
            return NSNumber(value: 0.0)
        }
    }
    
    /// Used to the system info.
    ///
    /// - Parameter typeSpecifier: Type of system info.
    /// - Returns: Return sysyem info.
    fileprivate static func getSysInfo(_ typeSpecifier: Int32) -> Int {
        var name: [Int32] = [CTL_HW, typeSpecifier]
        var nameCopy = name
        var size: Int = 2
        sysctl(&nameCopy, 2, nil, &size, &name, 0)
        var results: Int = 0
        sysctl(&nameCopy, 2, &results, &size, &name, 0)
        
        return results
    }
    
    /// When `save` is false, a new UUID will be created every time.
    /// When `save` is true, a new UUID will be created and saved in the user defatuls.
    /// It will be retrieved on next calls.
    ///
    /// - Parameters:
    ///   - save: If true the UUID will be saved, otherview not.
    ///   - force: If true a new UUID will be forced, even there is a saved one.
    /// - Returns: Returns the created (`save` = false`) or retrieved (`save` = true) UUID String.
    static func generateUniqueIdentifier(save: Bool = false, force: Bool = false) -> String {
        if save {
            let defaults = UserDefaults.standard
            
            guard !force else {
                let identifier = UUID().uuidString
                defaults.set(identifier, forKey: GDDeviceIdentifierDefaultsKey)
                defaults.synchronize()
                return identifier
            }
            
            guard let identifier = defaults.string(forKey: GDDeviceIdentifierDefaultsKey) else {
                let identifier = UUID().uuidString
                defaults.set(identifier, forKey: GDDeviceIdentifierDefaultsKey)
                defaults.synchronize()
                return identifier
            }
            
            return identifier
        }
        
        return UUID().uuidString
    }
    
    static func scalePad(for number:Float) -> Float{
        if isPad() {
            return number*1.5
        }
        return Float(414 / 375 * UIScreen.gd.minScreenLength / 414) * number
    }
    
    static func scale(for number:Float) -> Float{

        return Float(414 / 375 * UIScreen.gd.minScreenLength / 414) * number
    }
    
}

// MARK: - Global functions
public extension GDReference where Base :UIDevice {
    
    /// Compare OS versions.
    ///
    /// - Parameter version: Version, like "9.0".
    /// - Returns: Returns true if equal, otherwise false.
    func osVersionEqual(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedSame
    }
    
    /// Compare OS versions.
    ///
    /// - Parameter version: Version, like "9.0".
    /// - Returns: Returns true if greater, otherwise false.
    func osVersionGreaterThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedDescending
    }
    
    /// Compare OS versions.
    ///
    /// - Parameter version: Version, like "9.0".
    /// - Returns: Returns true if greater or equal, otherwise false.
    func osVersionGreaterThanOrEqual(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedAscending
    }
    
    /// Compare OS versions.
    ///
    /// - Parameter version: Version, like "9.0".
    /// - Returns: Returns true if less, otherwise false.
    func osVersionLessThan(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) == .orderedAscending
    }
    
    /// Compare OS versions.
    ///
    /// - Parameter version: Version, like "9.0".
    /// - Returns: Returns true if less or equal, otherwise false.
    func osVersionLessThanOrEqual(_ version: String) -> Bool {
        return UIDevice.current.systemVersion.compare(version, options: .numeric) != .orderedDescending
    }
}
