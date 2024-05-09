//
//  InfoPlant.swift
//  PlanTio
//
//  Created by Lucas Santos on 08/05/24.
//




// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct Welcome: Codable {
    let id: Int
    let latin, family: String
    let common: [String]
    let category, origin: String
    let climate: Climate
    let tempmax, tempmin: Tempm
    let ideallight: Ideallight
    let toleratedlight: Toleratedlight
    let watering: Watering
    let insects: InsectsUnion
    let diseases: Diseases
    let use: [Use]
}

enum Climate: String, Codable {
    case aridTropical = "Arid Tropical"
    case subtropical = "Subtropical"
    case subtropicalArid = "Subtropical arid"
    case tropical = "Tropical"
    case tropicalHumid = "Tropical humid"
    case tropicalToSubtropical = "Tropical to subtropical"
}

enum Diseases: Codable {
    case enumArray([Disease])
    case enumeration(Disease)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Disease].self) {
            self = .enumArray(x)
            return
        }
        if let x = try? container.decode(Disease.self) {
            self = .enumeration(x)
            return
        }
        throw DecodingError.typeMismatch(Diseases.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Diseases"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumArray(let x):
            try container.encode(x)
        case .enumeration(let x):
            try container.encode(x)
        }
    }
}

enum Disease: String, Codable {
    case crownRot = "Crown rot"
    case downyMildiou = "Downy mildiou"
    case erwinia = "Erwinia"
    case fusarium = "Fusarium"
    case grayMold = "Gray mold"
    case nA = "N/A"
    case phytophtora = "Phytophtora"
    case powdery = "Powdery"
    case pythium = "Pythium"
}

enum Ideallight: String, Codable {
    case brightLight = "Bright light"
    case prefersBrightIndirectSunlight = "Prefers bright, indirect sunlight."
    case the6OrMoreHoursOfDirectSunlightPerDay = "6 or more hours of direct sunlight per day."
}

enum InsectsUnion: Codable {
    case enumArray([Insect])
    case enumeration(InsectsEnum)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([Insect].self) {
            self = .enumArray(x)
            return
        }
        if let x = try? container.decode(InsectsEnum.self) {
            self = .enumeration(x)
            return
        }
        throw DecodingError.typeMismatch(InsectsUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for InsectsUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .enumArray(let x):
            try container.encode(x)
        case .enumeration(let x):
            try container.encode(x)
        }
    }
}

enum Insect: String, Codable {
    case aphid = "Aphid"
    case mealyBug = "Mealy bug"
    case scale = "Scale"
    case snail = "Snail"
    case spiderMite = "Spider mite"
    case thrips = "Thrips"
    case whiteFly = "White fly"
}

enum InsectsEnum: String, Codable {
    case mealyBug = "Mealy bug"
    case nA = "N/A"
}

// MARK: - Tempm
struct Tempm: Codable {
    let celsius: Int
    let fahrenheit: Double
}

enum Toleratedlight: String, Codable {
    case diffused = "Diffused"
    case directSunlight = "Direct sunlight"
    case empty = "/"
    case toleratedlightDirectSunlight = "Direct sunlight."
}

enum Use: String, Codable {
    case colorsForms = "Colors / Forms"
    case flower = "Flower"
    case groundCover = "Ground cover"
    case hanging = "Hanging"
    case pottedPlant = "Potted plant"
    case primary = "Primary"
    case secondary = "Secondary"
    case tableTop = "Table top"
    case tertiary = "Tertiary"
}

enum Watering: String, Codable {
    case canBeDryBetweenWateringWaterWhenSoilIsHalfDry = "Can be dry between watering. Water when soil is half dry."
    case changeWaterRegularlyInTheVaseWaterWhenSoilIsHalfDry = "Change water regularly in the vase. Water when soil is half dry."
    case keepMoistBetweenWateringCanBeABitDryBetweenWatering = "Keep moist between watering. Can be a bit dry between watering"
    case keepMoistBetweenWateringCanDryBetweenWatering = "Keep moist between watering. Can dry between watering"
    case keepMoistBetweenWateringMustNotBeDryBetweenWatering = "Keep moist between watering. Must not be dry between watering"
    case keepMoistBetweenWateringWaterWhenSoilIsHalfDry = "Keep moist between watering. Water when soil is half dry."
    case mustBeDryBetweenWateringWaterOnlyWhenDry = "Must be dry between watering. Water only when dry."
    case waterOnlyWhenDryMustBeDryBetweenWatering = "Water only when dry. Must be dry between watering"
    case waterOnlyWhenDryOrWhenSoilIsHalfDry = "Water only when dry or when soil is half dry."
    case waterOnlyWhenTheSoilIsDryMustBeDryBetweenWatering = "Water only when the soil is dry. Must be dry between watering"
    case waterWhenSoilIsHalfDryCanBeDryBetweenWatering = "Water when soil is half dry. Can be dry between watering."
    case waterWhenSoilIsHalfDryChangeWaterInTheVaseRegularly = "Water when soil is half dry. Change water in the vase regularly."
}

