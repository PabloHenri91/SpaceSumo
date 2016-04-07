//
//  CharacterGenerator.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/14/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class CharacterGenerator {
    
    static let sharedInstance = CharacterGenerator()
    
    struct indexOfNames : OptionSetType {
        typealias RawValue = UInt32
        private var value: UInt32 = 0
        init(_ value: UInt32) { self.value = value }
        init(rawValue value: UInt32) { self.value = value }
        init(nilLiteral: ()) { self.value = 0 }
        static var allZeros: indexOfNames { return self.init(0) }
        static func fromMask(raw: UInt32) -> indexOfNames { return self.init(raw) }
        var rawValue: UInt32 { return self.value }
        
        static var random: indexOfNames { return self.init(0) }
        
        static var AFRICAN: indexOfNames { return indexOfNames(1) }
        static var AUSTRALIAN: indexOfNames { return indexOfNames(2) }
        static var BELGIAN: indexOfNames { return indexOfNames(3) }
        static var CHINESE: indexOfNames { return indexOfNames(4) }
        static var DUTCH: indexOfNames { return indexOfNames(5) }
        static var EAST_SLAVIC: indexOfNames { return indexOfNames(6) }
        static var ENGLISH: indexOfNames { return indexOfNames(7) }
        static var FRENCH: indexOfNames { return indexOfNames(8) }
        static var GERMAN: indexOfNames { return indexOfNames(9) }
        static var GREEK: indexOfNames { return indexOfNames(10) }
        static var INDIAN: indexOfNames { return indexOfNames(11) }
        static var IRISH: indexOfNames { return indexOfNames(12) }
        static var ISRAELI: indexOfNames { return indexOfNames(13) }
        static var ITALIAN: indexOfNames { return indexOfNames(14) }
        static var JAPANESE: indexOfNames { return indexOfNames(15) }
        static var KOREAN: indexOfNames { return indexOfNames(16) }
        static var LATIN_AMERICAN: indexOfNames { return indexOfNames(17) }
        static var MUSLIM: indexOfNames { return indexOfNames(18) }
        static var NORTH_AMERICAN: indexOfNames { return indexOfNames(19) }
        static var POLISH: indexOfNames { return indexOfNames(20) }
        static var SCANDINAVIAN: indexOfNames { return indexOfNames(21) }
        static var SCOTTISH: indexOfNames { return indexOfNames(22) }
        static var SPANISH: indexOfNames { return indexOfNames(23) }
    }
    
    struct genders : OptionSetType {
        typealias RawValue = UInt32
        private var value: UInt32 = 0
        init(_ value: UInt32) { self.value = value }
        init(rawValue value: UInt32) { self.value = value }
        init(nilLiteral: ()) { self.value = 0 }
        static var allZeros: genders { return self.init(0) }
        static func fromMask(raw: UInt32) -> genders { return self.init(raw) }
        var rawValue: UInt32 { return self.value }
        
        static var random: genders { return self.init(0) }
        
        static var male: genders { return genders(1) }
        static var female: genders { return genders(2) }
    }
    
    // AFRICAN
    // Nigeria
    // South Africa (African descent)
    
    var m_arrAfMFirstNames = [String]()
    var m_arrAfFFirstNames = [String]()
    var m_arrAfLastNames = [String]()
    
    // AUSTRALIAN
    // Australia
    var m_arrAuMFirstNames = [String]()
    var m_arrAuFFirstNames = [String]()
    var m_arrAuLastNames = [String]()
    
    // BELGIAN
    // Belgium
    var m_arrBgMFirstNames = [String]()
    var m_arrBgFFirstNames = [String]()
    var m_arrBgLastNames = [String]()
    
    // CHINESE
    // China
    var m_arrChMFirstNames = [String]()
    var m_arrChFFirstNames = [String]()
    var m_arrChLastNames = [String]()
    
    // DUTCH
    // Netherlands
    // South Africa (European descent)
    var m_arrDuMFirstNames = [String]()
    var m_arrDuFFirstNames = [String]()
    var m_arrDuLastNames = [String]()
    
    // EAST SLAVIC
    // Ukraine
    var m_arrRsMFirstNames = [String]()
    var m_arrRsFFirstNames = [String]()
    var m_arrRsMLastNames = [String]()
    var m_arrRsFLastNames = [String]()
    
    // ENGLISH
    // South Africa (European descent)
    // UK
    var m_arrEnMFirstNames = [String]()
    var m_arrEnFFirstNames = [String]()
    var m_arrEnLastNames = [String]()
    
    // FRENCH
    // Canada (francophone)
    // France
    var m_arrFrMFirstNames = [String]()
    var m_arrFrFFirstNames = [String]()
    var m_arrFrLastNames = [String]()
    
    // GERMAN
    // Germany
    var m_arrGmMFirstNames = [String]()
    var m_arrGmFFirstNames = [String]()
    var m_arrGmLastNames = [String]()
    
    // GREEK
    // Greece
    var m_arrGrMFirstNames = [String]()
    var m_arrGrFFirstNames = [String]()
    var m_arrGrLastNames = [String]()
    
    // INDIAN
    // India
    var m_arrInMFirstNames = [String]()
    var m_arrInFFirstNames = [String]()
    var m_arrInLastNames = [String]()
    
    // IRISH
    // Ireland
    var m_arrIrMFirstNames = [String]()
    var m_arrIrFFirstNames = [String]()
    var m_arrIrLastNames = [String]()
    
    // ISRAELI
    // Israel
    var m_arrIsMFirstNames = [String]()
    var m_arrIsFFirstNames = [String]()
    var m_arrIsLastNames = [String]()
    
    // ITALIAN
    // Italy
    var m_arrItMFirstNames = [String]()
    var m_arrItFFirstNames = [String]()
    var m_arrItLastNames = [String]()
    
    // JAPANESE
    // Japan
    var m_arrJpMFirstNames = [String]()
    var m_arrJpFFirstNames = [String]()
    var m_arrJpLastNames = [String]()
    
    // KOREAN
    // South Korea
    var m_arrSkMFirstNames = [String]()
    var m_arrSkFFirstNames = [String]()
    var m_arrSkLastNames = [String]()
    
    // LATIN AMERICA
    // Argentina
    // Brazil
    // Mexico
    var m_arrMxMFirstNames = [String]()
    var m_arrMxFFirstNames = [String]()
    var m_arrMxLastNames = [String]()
    
    // MUSLIM
    // Egypt
    // Saudi Arabia (EU only)
    var m_arrAbMFirstNames = [String]()
    var m_arrAbFFirstNames = [String]()
    var m_arrAbLastNames = [String]()
    
    // NORTH AMERICAN
    // Canada (anglophone)
    // USA
    var m_arrAmMFirstNames = [String]()
    var m_arrAmFFirstNames = [String]()
    var m_arrAmLastNames = [String]()
    
    // POLISH
    // Poland (EW only)
    var m_arrPlMFirstNames = [String]()
    var m_arrPlFFirstNames = [String]()
    var m_arrPlMLastNames = [String]()
    var m_arrPlFLastNames = [String]()
    
    // SCANDINAVIAN
    // Norway
    // Sweden
    var m_arrNwMFirstNames = [String]()
    var m_arrNwFFirstNames = [String]()
    var m_arrNwLastNames = [String]()
    
    // SCOTTISH
    // Scotland
    var m_arrScMFirstNames = [String]()
    var m_arrScFFirstNames = [String]()
    var m_arrScLastNames = [String]()
    
    // SPANISH
    // Spain
    var m_arrEsMFirstNames = [String]()
    var m_arrEsFFirstNames = [String]()
    var m_arrEsLastNames = [String]()
    
    init() {
        
        if let path = NSBundle.mainBundle().pathForResource("DefaultNameList", ofType: "") {
            let data = (try! NSString(contentsOfFile: path, encoding: NSUTF16LittleEndianStringEncoding)).componentsSeparatedByString("\r\n")
            
            for line in data {
                
                let strings = line.componentsSeparatedByString("=")
                
                if let line0 = strings.first {
                    switch line0 {
                    case "m_arrAfMFirstNames":
                        m_arrAfMFirstNames.append(strings.last!)
                        break
                    case "m_arrAfFFirstNames":
                        m_arrAfFFirstNames.append(strings.last!)
                        break
                    case "m_arrAfLastNames":
                        m_arrAfLastNames.append(strings.last!)
                        break
                    case "m_arrAuMFirstNames":
                        m_arrAuMFirstNames.append(strings.last!)
                        break
                    case "m_arrAuFFirstNames":
                        m_arrAuFFirstNames.append(strings.last!)
                        break
                    case "m_arrAuLastNames":
                        m_arrAuLastNames.append(strings.last!)
                        break
                    case "m_arrBgMFirstNames":
                        m_arrBgMFirstNames.append(strings.last!)
                        break
                    case "m_arrBgFFirstNames":
                        m_arrBgFFirstNames.append(strings.last!)
                        break
                    case "m_arrBgLastNames":
                        m_arrBgLastNames.append(strings.last!)
                        break
                    case "m_arrChMFirstNames":
                        m_arrChMFirstNames.append(strings.last!)
                        break
                    case "m_arrChFFirstNames":
                        m_arrChFFirstNames.append(strings.last!)
                        break
                    case "m_arrChLastNames":
                        m_arrChLastNames.append(strings.last!)
                        break
                    case "m_arrDuMFirstNames":
                        m_arrDuMFirstNames.append(strings.last!)
                        break
                    case "m_arrDuFFirstNames":
                        m_arrDuFFirstNames.append(strings.last!)
                        break
                    case "m_arrDuLastNames":
                        m_arrDuLastNames.append(strings.last!)
                        break
                    case "m_arrRsMFirstNames":
                        m_arrRsMFirstNames.append(strings.last!)
                        break
                    case "m_arrRsFFirstNames":
                        m_arrRsFFirstNames.append(strings.last!)
                        break
                    case "m_arrRsMLastNames":
                        m_arrRsMLastNames.append(strings.last!)
                        break
                    case "m_arrRsFLastNames":
                        m_arrRsFLastNames.append(strings.last!)
                        break
                    case "m_arrEnMFirstNames":
                        m_arrEnMFirstNames.append(strings.last!)
                        break
                    case "m_arrEnFFirstNames":
                        m_arrEnFFirstNames.append(strings.last!)
                        break
                    case "m_arrEnLastNames":
                        m_arrEnLastNames.append(strings.last!)
                        break
                    case "m_arrFrMFirstNames":
                        m_arrFrMFirstNames.append(strings.last!)
                        break
                    case "m_arrFrFFirstNames":
                        m_arrFrFFirstNames.append(strings.last!)
                        break
                    case "m_arrFrLastNames":
                        m_arrFrLastNames.append(strings.last!)
                        break
                    case "m_arrGmMFirstNames":
                        m_arrGmMFirstNames.append(strings.last!)
                        break
                    case "m_arrGmFFirstNames":
                        m_arrGmFFirstNames.append(strings.last!)
                        break
                    case "m_arrGmLastNames":
                        m_arrGmLastNames.append(strings.last!)
                        break
                    case "m_arrGrMFirstNames":
                        m_arrGrMFirstNames.append(strings.last!)
                        break
                    case "m_arrGrFFirstNames":
                        m_arrGrFFirstNames.append(strings.last!)
                        break
                    case "m_arrGrLastNames":
                        m_arrGrLastNames.append(strings.last!)
                        break
                    case "m_arrInMFirstNames":
                        m_arrInMFirstNames.append(strings.last!)
                        break
                    case "m_arrInMFirstNames":
                        m_arrInMFirstNames.append(strings.last!)
                        break
                    case "m_arrInFFirstNames":
                        m_arrInFFirstNames.append(strings.last!)
                        break
                    case "m_arrInLastNames":
                        m_arrInLastNames.append(strings.last!)
                        break
                    case "m_arrIrMFirstNames":
                        m_arrIrMFirstNames.append(strings.last!)
                        break
                    case "m_arrIrFFirstNames":
                        m_arrIrFFirstNames.append(strings.last!)
                        break
                    case "m_arrIrLastNames":
                        m_arrIrLastNames.append(strings.last!)
                        break
                    case "m_arrIsMFirstNames":
                        m_arrIsMFirstNames.append(strings.last!)
                        break
                    case "m_arrIsFFirstNames":
                        m_arrIsFFirstNames.append(strings.last!)
                        break
                    case "m_arrIsLastNames":
                        m_arrIsLastNames.append(strings.last!)
                        break
                    case "m_arrItMFirstNames":
                        m_arrItMFirstNames.append(strings.last!)
                        break
                    case "m_arrItFFirstNames":
                        m_arrItFFirstNames.append(strings.last!)
                        break
                    case "m_arrItLastNames":
                        m_arrItLastNames.append(strings.last!)
                        break
                    case "m_arrJpMFirstNames":
                        m_arrJpMFirstNames.append(strings.last!)
                        break
                    case "m_arrJpFFirstNames":
                        m_arrJpFFirstNames.append(strings.last!)
                        break
                    case "m_arrJpLastNames":
                        m_arrJpLastNames.append(strings.last!)
                        break
                    case "m_arrSkMFirstNames":
                        m_arrSkMFirstNames.append(strings.last!)
                        break
                    case "m_arrSkFFirstNames":
                        m_arrSkFFirstNames.append(strings.last!)
                        break
                    case "m_arrSkLastNames":
                        m_arrSkLastNames.append(strings.last!)
                        break
                    case "m_arrMxMFirstNames":
                        m_arrMxMFirstNames.append(strings.last!)
                        break
                    case "m_arrMxFFirstNames":
                        m_arrMxFFirstNames.append(strings.last!)
                        break
                    case "m_arrMxLastNames":
                        m_arrMxLastNames.append(strings.last!)
                        break
                    case "m_arrAbMFirstNames":
                        m_arrAbMFirstNames.append(strings.last!)
                        break
                    case "m_arrAbFFirstNames":
                        m_arrAbFFirstNames.append(strings.last!)
                        break
                    case "m_arrAbLastNames":
                        m_arrAbLastNames.append(strings.last!)
                        break
                    case "m_arrAmMFirstNames":
                        m_arrAmMFirstNames.append(strings.last!)
                        break
                    case "m_arrAmFFirstNames":
                        m_arrAmFFirstNames.append(strings.last!)
                        break
                    case "m_arrAmLastNames":
                        m_arrAmLastNames.append(strings.last!)
                        break
                    case "m_arrPlMFirstNames":
                        m_arrPlMFirstNames.append(strings.last!)
                        break
                    case "m_arrPlFFirstNames":
                        m_arrPlFFirstNames.append(strings.last!)
                        break
                    case "m_arrPlMLastnames":
                        m_arrPlMLastNames.append(strings.last!)
                        break
                    case "m_arrPlFLastnames":
                        m_arrPlFLastNames.append(strings.last!)
                        break
                    case "m_arrNwMFirstNames":
                        m_arrNwMFirstNames.append(strings.last!)
                        break
                    case "m_arrNwFFirstNames":
                        m_arrNwFFirstNames.append(strings.last!)
                        break
                    case "m_arrNwLastNames":
                        m_arrNwLastNames.append(strings.last!)
                        break
                    case "m_arrScMFirstNames":
                        m_arrScMFirstNames.append(strings.last!)
                        break
                    case "m_arrScFFirstNames":
                        m_arrScFFirstNames.append(strings.last!)
                        break
                    case "m_arrScLastNames":
                        m_arrScLastNames.append(strings.last!)
                        break
                    case "m_arrEsMFirstNames":
                        m_arrEsMFirstNames.append(strings.last!)
                        break
                    case "m_arrEsFFirstNames":
                        m_arrEsFFirstNames.append(strings.last!)
                        break
                    case "m_arrEsLastNames":
                        m_arrEsLastNames.append(strings.last!)
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func getName(indexOfName:CharacterGenerator.indexOfNames, gender:CharacterGenerator.genders) -> String {
        
        var indexOfName:indexOfNames = indexOfName
        
        var gender:genders = gender
        
        if indexOfName == CharacterGenerator.indexOfNames.random {
            indexOfName = indexOfNames(UInt32(Int.random(min: 1, max: 23)))
        }
        
        if gender == CharacterGenerator.genders.random {
            gender = genders(UInt32(Int.random(min: 1, max: 2)))
        }
        
        var name = ""
        
        switch indexOfName {
        case indexOfNames.AFRICAN:
            //print("AFRICAN")
            if gender == genders.male {
                name = name + m_arrAfMFirstNames[Int.random(min: 0, max: m_arrAfMFirstNames.count - 1)]
            } else {
                name = name + m_arrAfFFirstNames[Int.random(min: 0, max: m_arrAfFFirstNames.count - 1)]
            }
            name = name + " " + m_arrAfLastNames[Int.random(min: 0, max: m_arrAfLastNames.count - 1)]
            break
        case indexOfNames.AUSTRALIAN:
            //print("AUSTRALIAN")
            if gender == genders.male {
                name = name + m_arrAuMFirstNames[Int.random(min: 0, max: m_arrAuMFirstNames.count - 1)]
            } else {
                name = name + m_arrAuFFirstNames[Int.random(min: 0, max: m_arrAuFFirstNames.count - 1)]
            }
            name = name + " " + m_arrAuLastNames[Int.random(min: 0, max: m_arrAuLastNames.count - 1)]
            break
        case indexOfNames.BELGIAN:
            ///print("BELGIAN")
            if gender == genders.male {
                name = name + m_arrBgMFirstNames[Int.random(min: 0, max: m_arrBgMFirstNames.count - 1)]
            } else {
                name = name + m_arrBgFFirstNames[Int.random(min: 0, max: m_arrBgFFirstNames.count - 1)]
            }
            name = name + " " + m_arrBgLastNames[Int.random(min: 0, max: m_arrBgLastNames.count - 1)]
            break
        case indexOfNames.CHINESE:
            //print("CHINESE")
            if gender == genders.male {
                name = name + m_arrChMFirstNames[Int.random(min: 0, max: m_arrChMFirstNames.count - 1)]
            } else {
                name = name + m_arrChFFirstNames[Int.random(min: 0, max: m_arrChFFirstNames.count - 1)]
            }
            name = name + " " + m_arrChLastNames[Int.random(min: 0, max: m_arrChLastNames.count - 1)]
            break
        case indexOfNames.DUTCH:
            //print("DUTCH")
            if gender == genders.male {
                name = name + m_arrDuMFirstNames[Int.random(min: 0, max: m_arrDuMFirstNames.count - 1)]
            } else {
                name = name + m_arrDuFFirstNames[Int.random(min: 0, max: m_arrDuFFirstNames.count - 1)]
            }
            name = name + " " + m_arrDuLastNames[Int.random(min: 0, max: m_arrDuLastNames.count - 1)]
            break
        case indexOfNames.EAST_SLAVIC:
            //print("EAST_SLAVIC")
            if gender == genders.male {
                name = name + m_arrRsMFirstNames[Int.random(min: 0, max: m_arrRsMFirstNames.count - 1)]
                name = name + " " + m_arrRsMLastNames[Int.random(min: 0, max: m_arrRsMLastNames.count - 1)]
            } else {
                name = name + m_arrRsFFirstNames[Int.random(min: 0, max: m_arrRsFFirstNames.count - 1)]
                name = name + " " + m_arrRsFLastNames[Int.random(min: 0, max: m_arrRsFLastNames.count - 1)]
            }
            break
        case indexOfNames.ENGLISH:
            //print("ENGLISH")
            if gender == genders.male {
                name = name + m_arrEnMFirstNames[Int.random(min: 0, max: m_arrEnMFirstNames.count - 1)]
            } else {
                name = name + m_arrEnFFirstNames[Int.random(min: 0, max: m_arrEnFFirstNames.count - 1)]
            }
            name = name + " " + m_arrEnLastNames[Int.random(min: 0, max: m_arrEnLastNames.count - 1)]
            break
        case indexOfNames.FRENCH:
            //print("FRENCH")
            if gender == genders.male {
                name = name + m_arrFrMFirstNames[Int.random(min: 0, max: m_arrFrMFirstNames.count - 1)]
            } else {
                name = name + m_arrFrFFirstNames[Int.random(min: 0, max: m_arrFrFFirstNames.count - 1)]
            }
            name = name + " " + m_arrFrLastNames[Int.random(min: 0, max: m_arrFrLastNames.count - 1)]
            break
        case indexOfNames.GERMAN:
            //print("GERMAN")
            if gender == genders.male {
                name = name + m_arrGmMFirstNames[Int.random(min: 0, max: m_arrGmMFirstNames.count - 1)]
            } else {
                name = name + m_arrGmFFirstNames[Int.random(min: 0, max: m_arrGmFFirstNames.count - 1)]
            }
            name = name + " " + m_arrGmLastNames[Int.random(min: 0, max: m_arrGmLastNames.count - 1)]
            break
        case indexOfNames.GREEK:
            //print("GREEK")
            if gender == genders.male {
                name = name + m_arrGrMFirstNames[Int.random(min: 0, max: m_arrGrMFirstNames.count - 1)]
            } else {
                name = name + m_arrGrFFirstNames[Int.random(min: 0, max: m_arrGrFFirstNames.count - 1)]
            }
            name = name + " " + m_arrGrLastNames[Int.random(min: 0, max: m_arrGrLastNames.count - 1)]
            break
        case indexOfNames.INDIAN:
            //print("INDIAN")
            if gender == genders.male {
                name = name + m_arrInMFirstNames[Int.random(min: 0, max: m_arrInMFirstNames.count - 1)]
            } else {
                name = name + m_arrInFFirstNames[Int.random(min: 0, max: m_arrInFFirstNames.count - 1)]
            }
            name = name + " " + m_arrInLastNames[Int.random(min: 0, max: m_arrInLastNames.count - 1)]
            break
        case indexOfNames.IRISH:
            //print("IRISH")
            if gender == genders.male {
                name = name + m_arrIrMFirstNames[Int.random(min: 0, max: m_arrIrMFirstNames.count - 1)]
            } else {
                name = name + m_arrIrFFirstNames[Int.random(min: 0, max: m_arrIrFFirstNames.count - 1)]
            }
            name = name + " " + m_arrIrLastNames[Int.random(min: 0, max: m_arrIrLastNames.count - 1)]
            break
        case indexOfNames.ISRAELI:
            ///print("ISRAELI")
            if gender == genders.male {
                name = name + m_arrIsMFirstNames[Int.random(min: 0, max: m_arrIsMFirstNames.count - 1)]
            } else {
                name = name + m_arrIsFFirstNames[Int.random(min: 0, max: m_arrIsFFirstNames.count - 1)]
            }
            name = name + " " + m_arrIsLastNames[Int.random(min: 0, max: m_arrIsLastNames.count - 1)]
            break
        case indexOfNames.ITALIAN:
            //print("ITALIAN")
            if gender == genders.male {
                name = name + m_arrItMFirstNames[Int.random(min: 0, max: m_arrItMFirstNames.count - 1)]
            } else {
                name = name + m_arrItFFirstNames[Int.random(min: 0, max: m_arrItFFirstNames.count - 1)]
            }
            name = name + " " + m_arrItLastNames[Int.random(min: 0, max: m_arrItLastNames.count - 1)]
            break
        case indexOfNames.JAPANESE:
            //print("JAPANESE")
            if gender == genders.male {
                name = name + m_arrJpMFirstNames[Int.random(min: 0, max: m_arrJpMFirstNames.count - 1)]
            } else {
                name = name + m_arrJpFFirstNames[Int.random(min: 0, max: m_arrJpFFirstNames.count - 1)]
            }
            name = name + " " + m_arrJpLastNames[Int.random(min: 0, max: m_arrJpLastNames.count - 1)]
            break
        case indexOfNames.KOREAN:
            //print("JAPANESE")
            if gender == genders.male {
                name = name + m_arrSkMFirstNames[Int.random(min: 0, max: m_arrSkMFirstNames.count - 1)]
            } else {
                name = name + m_arrSkFFirstNames[Int.random(min: 0, max: m_arrSkFFirstNames.count - 1)]
            }
            name = name + " " + m_arrSkLastNames[Int.random(min: 0, max: m_arrSkLastNames.count - 1)]
            break
        case indexOfNames.LATIN_AMERICAN:
            //print("LATIN_AMERICAN")
            if gender == genders.male {
                name = name + m_arrMxMFirstNames[Int.random(min: 0, max: m_arrMxMFirstNames.count - 1)]
            } else {
                name = name + m_arrMxFFirstNames[Int.random(min: 0, max: m_arrMxFFirstNames.count - 1)]
            }
            name = name + " " + m_arrMxLastNames[Int.random(min: 0, max: m_arrMxLastNames.count - 1)]
            break
        case indexOfNames.MUSLIM:
            //print("MUSLIM")
            if gender == genders.male {
                name = name + m_arrAbMFirstNames[Int.random(min: 0, max: m_arrAbMFirstNames.count - 1)]
            } else {
                name = name + m_arrAbFFirstNames[Int.random(min: 0, max: m_arrAbFFirstNames.count - 1)]
            }
            name = name + " " + m_arrAbLastNames[Int.random(min: 0, max: m_arrAbLastNames.count - 1)]
            break
        case indexOfNames.NORTH_AMERICAN:
            //print("NORTH_AMERICAN")
            if gender == genders.male {
                name = name + m_arrAmMFirstNames[Int.random(min: 0, max: m_arrAmMFirstNames.count - 1)]
            } else {
                name = name + m_arrAmFFirstNames[Int.random(min: 0, max: m_arrAmFFirstNames.count - 1)]
            }
            name = name + " " + m_arrAmLastNames[Int.random(min: 0, max: m_arrAmLastNames.count - 1)]
            break
        case indexOfNames.POLISH:
            //print("POLISH")
            if gender == genders.male {
                name = name + m_arrPlMFirstNames[Int.random(min: 0, max: m_arrPlMFirstNames.count - 1)]
                name = name + " " + m_arrPlFFirstNames[Int.random(min: 0, max: m_arrPlFFirstNames.count - 1)]
            } else {
                name = name + m_arrPlMLastNames[Int.random(min: 0, max: m_arrPlMLastNames.count - 1)]
                name = name + " " + m_arrPlFLastNames[Int.random(min: 0, max: m_arrPlFLastNames.count - 1)]
            }
            break
        case indexOfNames.SCANDINAVIAN:
            //print("SCANDINAVIAN")
            if gender == genders.male {
                name = name + m_arrNwMFirstNames[Int.random(min: 0, max: m_arrNwMFirstNames.count - 1)]
            } else {
                name = name + m_arrNwFFirstNames[Int.random(min: 0, max: m_arrNwFFirstNames.count - 1)]
            }
            name = name + " " + m_arrNwLastNames[Int.random(min: 0, max: m_arrNwLastNames.count - 1)]
            break
        case indexOfNames.SCOTTISH:
            //print("SCOTTISH")
            if gender == genders.male {
                name = name + m_arrScMFirstNames[Int.random(min: 0, max: m_arrScMFirstNames.count - 1)]
            } else {
                name = name + m_arrScFFirstNames[Int.random(min: 0, max: m_arrScFFirstNames.count - 1)]
            }
            name = name + " " + m_arrScLastNames[Int.random(min: 0, max: m_arrScLastNames.count - 1)]
            break
        case indexOfNames.SPANISH:
            //print("SPANISH")
            if gender == genders.male {
                name = name + m_arrEsMFirstNames[Int.random(min: 0, max: m_arrEsMFirstNames.count - 1)]
            } else {
                name = name + m_arrEsFFirstNames[Int.random(min: 0, max: m_arrEsFFirstNames.count - 1)]
            }
            name = name + " " + m_arrEsLastNames[Int.random(min: 0, max: m_arrEsLastNames.count - 1)]
            break
            
        default:
            break
        }
        
        return name
    }
}
