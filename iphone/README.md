<h1>Ti.Wormhole</h1>

Ti.Wormhole provides limited Titanium event support for the Today Widget and the Apple Watch.  This project is based off [MMWormhole](https://github.com/mutualmobile/MMWormhole).

<h2>Before you start</h2>
* At the moment you need the 3.5.x nightly build branch
* This module has only been tested on iOS8+

<h2>How do I get started? How do I use this module?</h2>

Examples and documentation coming shortly.  Keep in mind you will need to code your extension in Objective-C or use the Swift to Objective-C bridge.  I'm working on samples for both, but will provide Objective-C first.

<h2>Methods</h2>

<h4>start</h4>

Starts up the wormhole. You need to provide the SuiteName you want to communicate with and optionally provide a message directory.

Dictionary Fields
* suiteName : String with the suite name you want to communicate with.
* directory : (optional) String with the wormhole directory name 

<b>Sample</b>

<pre><code>
//Add the core module into your project
var wormhole = require('ti.wormhole');

wormhole.start({
	suiteName:'group.appworkbench.TodayExtentionSharing'
});

</code></pre>

<h4>addWormhole</h4>

Add's a wormhold listener.  This will listen for your extension or watch app to sent a message.

Parameters
* Wormhole Name : The name of the wormhole you want to create a listener on.
* callback : Function to return the wormhole results when fired.

<b>Sample</b>

<pre><code>
//Add the core module into your project
var wormhole = require('ti.wormhole');

//Hows how to listen to the button wormhole event
wormhole.addWormhole("button",function(e){
	console.log(JSON.stringify(e));
});

</code></pre>

<h4>post</h4>

Posts a message to the extension or watch app.  Keep in mind, you will want to do this when your extension or watch app is loaded. This might mean you need to post from the background.

Parameters
* Wormhole Name : The name of the wormhole you are posting to.
* Dictionary : The value dictionary you want to pass to native.

<b>Sample</b>

<pre><code>
//Add the core module into your project
var wormhole = require('ti.wormhole');

//Wrap in a timeout to give us enough time to load the extension
setTimeout(function(){
	//Post to the button2 workhole a new buttonNumber value
	wormhole.post("button2",{buttonNumber:4});
},10000);

</code></pre>

<h4>readWormhole</h4>

Reads an existing wormhole value, and returns a dictionary. If no wormhole values are found, undefined is returned.

Parameters
* Wormhole Name : The name of the wormhole you are reading.

<b>Sample</b>

<pre><code>
//Add the core module into your project
var wormhole = require('ti.wormhole');

var holeValues = wormhole.readWormhole("button2");
console.log("Wormhole values: " + JSON.stringify(holeValues));

</code></pre>

<h4>removeWormhole</h4>

Remove and closes the specified wormhole.

Parameters
* Wormhole Name : The name of the wormhole you are closing.

<b>Sample</b>

<pre><code>
//Add the core module into your project
var wormhole = require('ti.wormhole');

wormhole.removeWormhole("button2");

</code></pre>

<h4>clearAllMessageContents</h4>

Clear all wormhole message contents.

Parameters
* None

<b>Sample</b>

<pre><code>
//Add the core module into your project
var wormhole = require('ti.wormhole');

wormhole.clearAllMessageContents();

</code></pre>