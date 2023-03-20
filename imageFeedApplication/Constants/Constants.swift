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
