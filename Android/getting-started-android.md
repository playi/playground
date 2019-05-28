# Follow these steps to start building apps for <br /> Dash & Dot in minutes.

The Wonder Workshop API is hosted by our servers.  It is tested with the Android API level 19+ (Kitkat 4.4.2 and above) with our supported [Android device list](https://www.makewonder.com/compatibility).  

## Prerequisites

* Your favorite Android IDE (we use [Android Studio](http://developer.android.com/sdk/index.html))
* Dash and/or Dot robot. If you don't have one, you can order one from [our store](https://store.makewonder.com/).
* An Android device that supports Bluetooth 4 (BTLE), hopefully from our supported [Android device list](https://www.makewonder.com/compatibility). Other Android devices *may* not work well as it depends on the manufacturing spec of BTLE support for that device.  

---

### 1. Create an Android project and install [gradle](https://gradle.org/)


### 2. Include WonderWorkshop maven repository to your gradle config file 
We leverage maven, so add this sample snippet in the your app's <root_dir>/build.gradle file so that all your app's build.gradle file can inherit from:

```java
subprojects {
   repositories {
       mavenLocal()
       mavenCentral()
       maven {
           url "https://wonderworkshop-releases.s3.amazonaws.com/" // our maven repository URL
       }
   }
}
```

Once you have included the maven information, for each of your Android app's build.gradle file, include the following dependencies:

```java
dependencies {
	// your app dependencies
   compile 'com.makewonder:W2AndroidAPI:1.2@aar' // latest API version is 1.2
   compile 'de.greenrobot:eventbus:2.4.0' 
   compile 'com.github.oxo42:stateless4j:2.5.0' 
}
```

### 3. Start hacking!

That is it, go ahead and start programming with your very own dash or dot, or run our [sample application](https://github.com/playi/playground) to see the robots in action.  Please note that since our developer program is still in private beta, you will need to be granted access of the sample application.  Please send your github screen name to [developers@makewonder.com](mailto:developers@makewonder.com) for access.  Also, Please let us know at [developers@makewonder.com](mailto:developers@makewonder.com) when you've built cool integrations with our robots, we would love to know! 
