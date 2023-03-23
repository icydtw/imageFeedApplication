import Foundation

let AccessKey = "d-iva2pDkEyXhP0Un9pddPQoSc2hSOwZ2Y-_yVxUjd4"
let SecretKey = "YZgWAL55at-KCuUmnNBhJFo482TuT8qPQRAOnTJC7FE"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashPostRequestURL = "https://unsplash.com/oauth/token"
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let GetProfileURL = "https://api.unsplash.com/me"
let GetProfileImageURL = "https://api.unsplash.com/users/"
let GetPhotosURL = "https://api.unsplash.com/photos"
let LikePhotosURL = "https://api.unsplash.com/photos/:id/like"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let unsplashPostRequestURL: String
    let unsplashAuthorizeURLString: String
    let getProfileURL: String
    let getProfileImageURL: String
    let getPhotosURL: String
    let likePhotosURL: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, unsplashPostRequestURL: String, unsplashAuthorizeURLString: String, getProfileURL: String, getProfileImageURL: String, getPhotosURL: String, likePhotosURL: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.unsplashPostRequestURL = unsplashPostRequestURL
        self.unsplashAuthorizeURLString = unsplashAuthorizeURLString
        self.getProfileURL = getProfileURL
        self.getProfileImageURL = getProfileImageURL
        self.getPhotosURL = getPhotosURL
        self.likePhotosURL = likePhotosURL
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey,
                                 secretKey: SecretKey,
                                 redirectURI: RedirectURI,
                                 accessScope: AccessScope,
                                 defaultBaseURL: DefaultBaseURL,
                                 unsplashPostRequestURL: UnsplashPostRequestURL,
                                 unsplashAuthorizeURLString: UnsplashAuthorizeURLString,
                                 getProfileURL: GetProfileURL,
                                 getProfileImageURL: GetProfileURL,
                                 getPhotosURL: GetPhotosURL,
                                 likePhotosURL: LikePhotosURL)
    }
}
