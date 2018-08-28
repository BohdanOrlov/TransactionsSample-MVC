# TransactionsSample-MVC

Sample project to display a list with transactions from https://lootiosinterview.docs.apiary.io/# endpoint.

### App Description

The app will display a transactions list, the balance and a graph with the balance history. The most important things from UX pespective for this type of application is to be able to easily see the history of transactions and spending based on categories. I've added 2 features in the home screen:

* Search 
* Filter based on categoriy. Ideally the API should return more information for each transaction but for this sample I've just generated a random category for each one.

There is also a detail view which will display the transactions details and a map if it has location info.

### Project and App Architecture

I've decided to build this project in MVC, I wanted to demostate some way to make simpler and smaller modules. There is also a MVVM version here https://github.com/tomangistalis/TransactionsSample-MVVM

There is a network abstruction layer based on Moya which helps a lot with cleaner API syntax and testability. It can easily be adapted for mocking reponses in tests. It has a Dependency Container which will contain all core services and its very useful for unit testing. It also uses the Realm databases for persisting data.

### Dependencies

This project uses Cocoapods for adding third party libraries and all Pods will be commited to the repository so it can be run without problems. In a production app I would use Carthage for faster build times.

There is also a Gemfile to install some other utilities needed such as Fastlane and Cocoapods.

### What to improve

* Add more filters
* Add statistics view for easily viewing spending categories.



