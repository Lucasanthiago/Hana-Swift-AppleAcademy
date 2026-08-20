import Foundation

/// Access point for the API keys the app needs at runtime.
///
/// The values are not stored in source. They are declared in
/// `Config/Secrets.xcconfig` (git-ignored), injected into the target's
/// Info.plist at build time as `$(PLANT_ID_API_KEY)` and friends, and read
/// back here. `Config/Base.xcconfig` defines empty defaults so that a clone
/// without a `Secrets.xcconfig` still builds.
///
/// This keeps the keys out of the repository. It does not make them secret
/// in a distributed build: anything shipped inside an app bundle can be
/// recovered from the binary. See the README for the full caveat.
enum AppSecrets {
    static let plantID = value(for: "PLANT_ID_API_KEY")
    static let aiXplainTeam = value(for: "AIXPLAIN_TEAM_API_KEY")
    static let postHog = value(for: "POSTHOG_API_KEY")

    private static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            print("""
                [AppSecrets] Missing value for \(key).
                Copy Config/Secrets.example.xcconfig to Config/Secrets.xcconfig \
                and fill it in. See the README.
                """)
            return ""
        }
        return value
    }
}
