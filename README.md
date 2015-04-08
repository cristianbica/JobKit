# JobKit

[![CI Status](http://img.shields.io/travis/cristianbica/JobKit.svg?style=flat)](https://travis-ci.org/cristianbica/JobKit)
[![Version](https://img.shields.io/cocoapods/v/JobKit.svg?style=flat)](http://cocoapods.org/pods/JobKit)
[![License](https://img.shields.io/cocoapods/l/JobKit.svg?style=flat)](http://cocoapods.org/pods/JobKit)
[![Platform](https://img.shields.io/cocoapods/p/JobKit.svg?style=flat)](http://cocoapods.org/pods/JobKit)

**Warning: this project is in alpha state**

## About

JobKit is a job queueing system for iOS application. It has a pluggable storage adapters and this repo contains adapters for Core Data (persistent), Realm (persistent) and a memory adapter.

Currently it has a naive implementation for a mobile device as it checks periodically (`tickInterval`) for new jobs but I'm going to implement an notifications based processing trigger.

## Installation

JobKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
# this will install all the available storage adapters and their dependencies
pod "JobKit"
# this will install the core classes and the Realm adapter
pod "JobKit/Realm"
# this will install the core classes and the Core Data adapter
pod "JobKit/CoreData"
# this will install the core classes and the Memory adapter
pod "JobKit/Memory"
```

## Usage
In your AppDelegate initialize JobKit:

```objective-c
  //initialize manager
  [JobKit setupDefaultManagerWithStorageProvider:[JKCoreDataAdapter class]];
  //set tick interval
  [JobKit defaultManager].tickInterval = .5;
  //start processing jobs
  [JobKit start];
```

There are 3 way in which you can enqueue jobs to JobKit:

 1 - Creating a subclass of `JKJob`

```objective-c
@interface JKTestJob : JKJob
@end

@implementation JKTestJob
- (void)perform {
  //any arguments passed to the job can be found at self.arguments
}
@end

//enqueue a job
[JKTestJob performLater:nil];
[JKTestJob performLater:@["arg"]];
[JKTestJob performLater:@[@"arg1", @"2", @{@(3) : @"4"}]];
```
_Important: All arguments must conform to the `NSCoding` protocol._


2 - Enqueue invocation of a class method for any object

```objective-c
[SomeClass jk_performLater:@selector(aClassMethod) arguments:nil]
[SomeClass jk_performLater:@selector(aClassMethod) arguments:@["arg"]]
```
_Important: All arguments must conform to the `NSCoding` protocol._


3 - Enqueue invocation of an instance method for any object instance

```objective-c
[anObject jk_performLater:@selector(aClassMethod) arguments:nil]
[anObject jk_performLater:@selector(aClassMethod) arguments:@["arg"]]
```
_Important: The object and all arguments must conform to the `NSCoding` protocol._

## TODO
1. Optimize triggering job processing
2. Implement retry mechanism
3. Query interface for jobs
4. UI for jobs
5. Schedule jobs in the future / with delay
6. Process jobs on background modes

## Author

Cristian Bica, cristian.bica@gmail.com

## License

JobKit is available under the MIT license. See the LICENSE file for more info.
