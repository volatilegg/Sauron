// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pokemon = try? JSONDecoder().decode(Pokemon.self, from: jsonData)

import Foundation

// MARK: - Pokemon
struct Pokemon: Codable {
    let abilities: [Ability]
    let baseExperience: Int
    let forms: [Species]
    let gameIndices: [GameIndex]
    let height: Int
    let id: Int
    let isDefault: Bool
    let locationAreaEncounters: String
    let moves: [Move]
    let name: String
    let order: Int
    let species: Species
    let stats: [Stat]
    let types: [TypeElement]
    let weight: Int
}

extension Pokemon {
    // MARK: - Ability
    struct Ability: Codable {
        let ability: Species
        let isHidden: Bool
        let slot: Int
    }

    // MARK: - Species
    struct Species: Codable {
        let name: String
        let url: String
    }

    // MARK: - GameIndex
    struct GameIndex: Codable {
        let gameIndex: Int
        let version: Species
    }

    // MARK: - Move
    struct Move: Codable {
        let move: Species
        let versionGroupDetails: [VersionGroupDetail]
    }

    // MARK: - VersionGroupDetail
    struct VersionGroupDetail: Codable {
        let levelLearnedAt: Int
        let moveLearnMethod, versionGroup: Species
    }

    // MARK: - OfficialArtwork
    struct OfficialArtwork: Codable {
        let frontDefault, frontShiny: String
    }

    // MARK: - Home
    struct Home: Codable {
        let frontDefault: String
        let frontFemale: String?
        let frontShiny: String
        let frontShinyFemale: String?
    }

    // MARK: - Stat
    struct Stat: Codable {
        let baseStat, effort: Int
        let stat: Species
    }

    // MARK: - TypeElement
    struct TypeElement: Codable {
        let slot: Int
        let type: Species
    }
}
