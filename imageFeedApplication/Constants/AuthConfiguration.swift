import Foundation

let accessKey = "qXw9QTvVZevvup2zLAwGLPMe19qQJl7vSgtr6fwvHu0"
let secretKey = "YcvkXZLL9z8wRct0fjGjjFEK3HJ3mbWErBqcjITNWkQ"
let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
let accessScope = "public+read_user+write_likes"
let defaultBaseURL = URL(string: "https://api.unsplash.com")
let unsplashPostRequestURL = "https://unsplash.com/oauth/token"
let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let getProfileURL = "https://api.unsplash.com/me"
let getProfileImageURL = "https://api.unsplash.com/users/"
let getPhotosURL = "https://api.unsplash.com/photos"
let likePhotosURL = "https://api.unsplash.com/photos/:id/like"

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
}
