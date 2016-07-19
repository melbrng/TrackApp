# TrackApp

#Track App V1
User creates tracks - points of interest in geographical areas accompanied by photo(s)

##User Stories
###As a user I would like to 
track my location

take and store photos of a location

organize photos by category

see all photos associated with each category

see interesting attractions near my current location

broadcast my location to other users of the app - V2

share my photo/activity on social media

create a user profile

##Model
###User Profile
Name
Description
Image
[Track]

###Track
Comprised of 1 or more Footprints

[Footprint]
Description
User

###Footprint
User will have at least one footprint showing their current location. Must remember to ask permission and give ability to hide current location.

Image

Latitude

Longitude

Description

Track

##Firebase
###Database
Design proper JSON feed based on model
###Storage
Database will contain a file storage reference for each photo

#Track App User Stories

##User Story 1 - Track my location
###Model
Hook up to Firebase

Authenticate or create user

Core location sets the user’s current location

![](https://github.com/melbrng/TrackApp/blob/master/images/user_1.png)

### View and View Controllers
Login/auth UI and add track button

Map View with current user location

Enable map to show interesting attractions near my current location

###Test
Create a test user and verify authentication

##User story 2 - Take and store photos of a location
### Model
Implement a Footprint class for photo, latitude/longitude/GPS, description and write back data to Firebase database

### View and View Controllers
UI to access camera or choose photos from the photo library

UI for selected photo and for setting footprint attributes

![](https://github.com/melbrng/TrackApp/blob/master/images/user_2.png)
![](https://github.com/melbrng/TrackApp/blob/master/images/user_2a.png)

##User story 3 - Organize photos by category
### Model
Allow a user to assign each footprint to an existing Track or create/assign to a new Track

###View and View Controllers
Photo UI and track category dropdown 

Track UI for creating a new track and assign to footprint

##User story 4 - see all photos associated with each Track
### Model

Retrieve all footprints for the logged in user

![](https://github.com/melbrng/TrackApp/blob/master/images/user_4.png)

###View and View Controllers

Tableview UI that allows the user to scroll through all photos (footprints) in a category (Track)

Photo UI to view selected track

##User story 5 - set up a user profile

### Model
Implement a user class for the profile name, description and profile image 

### View and View Controllers
User profile UI for creating or editing user information

User profile UI will contain a tableView of Tracks

![](https://github.com/melbrng/TrackApp/blob/master/images/user_5.png)

##User story 6 - Share my photo/activity on social media

### Model
Allow the user to share footprint photos on social media

### View and View Controllers
Photo UI add Facebook, Twitter buttons 


#Track App V2 
##Brainstorm:
Allow users to follow each other’s Tracks

broadcast my location to other users of the app 

Incorporate hiking trails













