# Ti.Wormhole

Ti.Wormhole provides limited Titanium event support for the Today Widget and the Apple Watch. 
This project is based off [MMWormhole](https://github.com/mutualmobile/MMWormhole).

## Before you start
* At the moment you need the 3.5.0 and later
* This module has only been tested on iOS8 +

## How do I get started? How do I use this module?

Examples and documentation coming shortly.  Keep in mind you will need to code your extension in Objective-C or use the Swift to Objective-C bridge.  
I'm working on samples for both, but will provide Objective-C first.

## Methods

#### `start`

Starts up the wormhole. You need to provide the SuiteName you want to communicate with and optionally provide a message directory.

Dictionary Fields
* suiteName : String with the suite name you want to communicate with.
* directory : (optional) String with the wormhole directory name 

**Sample**

```js
// Add the core module into your project
var wormhole = require('ti.wormhole');

wormhole.start({
	suiteName:'group.appworkbench.TodayExtentionSharing'
});
```

#### `addWormhole`

Add's a wormhold listener.  This will listen for your extension or watch app to sent a message.

Parameters
* Wormhole Name : The name of the wormhole you want to create a listener on.
* callback : Function to return the wormhole results when fired.

**Sample**

```js
// Add the core module into your project
var wormhole = require('ti.wormhole');

// How how to listen to the button wormhole event
wormhole.addWormhole("button", function(e) {
	console.log(JSON.stringify(e));
});
```

#### `post`

Posts a message to the extension or watch app.  Keep in mind, you will want to do this when your extension or watch app is loaded. This might mean you need to post from the background.

Parameters
* Wormhole Name : The name of the wormhole you are posting to.
* Dictionary : The value dictionary you want to pass to native.

**Sample**

```js
// Add the core module into your project
var wormhole = require('ti.wormhole');

// Wrap in a timeout to give us enough time to load the extension
setTimeout(function() {
	// Post a new buttonNumber value to the button2 wormhole
	wormhole.post("button2",{ buttonNumber:4 });
},10000);
```

#### `readWormhole`

Reads an existing wormhole value, and returns a dictionary. If no wormhole values are found, undefined is returned.

Parameters
* Wormhole Name : The name of the wormhole you are reading.

**Sample**

```js
// Add the core module into your project
var wormhole = require('ti.wormhole');

var holeValues = wormhole.readWormhole("button2");
console.log("Wormhole values: " + JSON.stringify(holeValues));
```

#### `removeWormhole`

Remove and closes the specified wormhole.

Parameters
* Wormhole Name : The name of the wormhole you are closing.

**Sample**

```js
// Add the core module into your project
var wormhole = require('ti.wormhole');

wormhole.removeWormhole("button2");
```

#### `clearAllMessageContents`

Clear all wormhole message contents.

Parameters
* None

**Sample**

```js
// Add the core module into your project
var wormhole = require('ti.wormhole');

wormhole.clearAllMessageContents();
```
