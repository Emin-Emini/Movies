# Movies

Open [this link](https://github.com/EminRma/Movies/tree/master) to check the project on Github.

The project is private so I have to invite you. Please contact me on [e20191479@novaims.unl.pt](e20191479@novaims.unl.pt)

## Project Specification, Requirements and Storyboards for Individual Work

To complete the course requirements for *Mobile Apps Development*, as the individual work, I have selected the **10th application** from proposals, to display latest movies released separated by companies.
To develop this application, I decided to use **Swif**t and **Xcode**, in order to build a small **iOS application**, which will include all of the required funcionalities.

I decided to name this app **Movies**, so that the user has a clearer idea of what the application is all about. I choose to work on this project, cause for me it was new thing to work with TMDb API.

The main task of the application is to get movie data from a **TMDb API** and to present that data visually to the user.

I used different libraries for the project, like Apple’s libraries and other third-party libraries.


Some of the third-party libraries were:

**SwiftyJSON** – In Swift you can get JSON data in different ways, even without using any library. But SwiftyJSON makes the life easier, with less code and less effort you can get data from JSON API. Also, Swift is very strict about types. But although explicit typing is good for saving us from mistakes, it becomes painful when dealing with JSON and other areas that are, by nature, implicit about types.

**Alamofire** – used to create an HTTP request for movies. Alamofire is an HTTP networking library written in Swift.

**AlamofireImage** – used to create an HTTP request for movies posters and images. It’s same as Alamofire, and it’s developed by same developers. But it’s an image library including image response serializers, UIImage and UIImageView extensions, custom image filters, an auto-purging in-memory cache and a priority-based image downloading system.

**MBProgressHUD** – used to present visually that the data are loading. There is Activity Indicator from Apple that does the same job, but MBProgressHUD is easier to work with and doesn’t require work as Activity Indicator does.

**ScrollableSegmentedControl UI** – Showing 6 companies was tricky because of width space. Firstly, I used Segmented Controller, but unfortunately it didn’t fit more than 5 companies on the view. I could insert more than 5 companies, but the it affected user interface (UI) negatively. The names of companies were hard to read, and everything was like compressed. So, I used this library to make the Segmented Controller scrollable.


In order to build this application, first of all, I created the *UIViewControllers* (user interface), based on the data, that I wanted to show inside each screen within the application. Then, for each activity, I added the code to make requests from the API and display that data to the user. I created only one View Controller as a model, then stored data separately per each tab. So, the app has *5 tabs*, **Popular, Most Rated, Last Launched (divided by companies), Now Playing, Upcoming.**

Also, the movies can be shown on *list* (using: *TableView*) and on *grid* (using: *CollectionView*)
