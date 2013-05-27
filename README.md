goodreads-oauth
===============

A Project to make the pain of OAuth integration with Goodreads easier for Objective-C

My goal in creating this library is to make it as easy as possible to integrate Goodreads into an iOS app. All methods are class methods so that you don't need to pass an object everywhere you want to use the API. However, the result is that the UI for version 1.0 is not customizable without editing the source. If you have suggestions, requests or want to contribute, create an issue, email at <yjkogan@gmail.com>, or just submit a pull request.

The underlying OAuth library is that of Christian Hansen and is available at <https://github.com/Christian-Hansen/simple-oauth1>. I made small modifications so that the library specifically supports Goodreads rather than LinkedIn.

#Installation
##Installation from Source
1. Clone the repository: `git clone https://github.com/yjkogan/goodreads-oauth.git`
2. From the root of the repository you will need to include the `Dependencies` directory, as well as the `GROAuth.h` and `.m` files in your project. The easiest way to do this is to drag them into the file navigator of your project.
3. Check the box under "Add to targets".
4. Optionally (but recommended), you can choose to "Copy items to destination group's folder (if needed)".
5. Click "Finish"

##Installation using Cocoapods
####Coming Soon!

#Usage
##Initializing GROAuth
Initialize GROAuth with your API Keys by calling `[GROAuth setGoodreadsOAuthWithConsumerKey:YOUR_KEY secret:YOUR_SECRET]`. It's recommended that you do this in `application: didFinishLaunchingWithOptions:` in your appDelegate
##Logging the User In
To log the user in and (if they haven't already) ask them to authorize your app, just call `GROAuth loginWithGoodreadsWithCompletion:`. This will present a webview on top of the current window through which the user can log in. If there is an error (user not authorizing your app, networking, etc.), it will be passed to your completion block. Else, you'll recieve a dictionary containing the `oauth_token` and `oauth_token_secret`, which are the access tokens you need to sign your requests.
##Sending Queries to Goodreads
All paths sent to GROAuth should be the paths listed in the documentation for the Goodreads API, minus the leading `http://goodreads.com`, so for example, if you wanted to use the `auth.user` method, you would want to give the path `api/auth_user`. This is concatonated onto the goodreads home URL. For some reason, not all api paths start with `/api`…
###Queries requiring OAuth
There are a number of convenience methods for accessing data from Goodreads. The most important thing to point out though is that there are two versions for each method: one that requires access tokens and one that does not. Methods that don't require access tokens defaults to using the access tokens most recently acquired.

Another thing to be aware of is that the dictionaries returned from calls that return an NSDictionary are a bit of a pain to use. If anyone has suggestions for a better library than <https://github.com/nicklockwood/XMLDictionary>, please let me know.
###Queries that don't require OAuth
Sending OAuth signed queries to API paths that don't require OAuth return an html document rather than an XML one, so these extra methods are necessary. If the request requires your key as a parameter (they probably all do, but I haven't checked yet), you can easily get it with `[GROAuth consumerKey]`. The same qualification is true as with OAuth queries regarding NSDictionaries you get back.