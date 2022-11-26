struct Issue: Decodable {
    let number: Int
    let title: String
    let profileURL: String
    let userName: String
    let contents: String
    var bannerURL: String = ""
    
    enum CodingKeys: String, CodingKey {
        case number
        case title
        case profileURL = "avatar_url"
        case user
        case userName = "login"
        case contents = "body"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(
            keyedBy: CodingKeys.self,
            forKey: .user
        )
        
        self.number = try container.decodeIfPresent(Int.self, forKey: .number) ?? 0
        self.title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        self.profileURL = try nestedContainer.decodeIfPresent(String.self, forKey: .profileURL) ?? ""
        self.userName = try nestedContainer.decodeIfPresent(String.self, forKey: .userName) ?? ""
        self.contents = try container.decodeIfPresent(String.self, forKey: .contents) ?? ""
    }
    
    init() {
        self.number = 0
        self.title = ""
        self.profileURL = ""
        self.userName = ""
        self.contents = ""
        self.bannerURL = "https://s3.ap-northeast-2.amazonaws.com/hellobot-kr-test/image/main_logo.png"
    }
}
