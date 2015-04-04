// this sets the background color of the master UIView (when there are no windows/tab groups on it)
Ti.UI.setBackgroundColor('#000');

var wormhole = require('ti.wormhole');
Ti.API.info("module is => " + wormhole);

var sampleGroupIdentifier = "group.appworkbench.TodayExtenionWormhole";
var sampleEventName = "wormEvent";
var sampleWormDirectory = "tiwormhole";
var displayCount = 0;

var win = Ti.UI.createWindow({  
    title:'Wormhole Example',
    backgroundColor:'#fff',
    layout:'vertical'
});

var countLabel = Ti.UI.createLabel({
	top:100,textAlign:'center', width:'auto', height:30,
	color:'#000', text:'Count:0', font:{fontSize:20,fontFamily:'Helvetica Neue'}	
});
win.add(countLabel);

var buttonContainer = Ti.UI.createView({
	height:	50, width:Ti.UI.FILL
});
win.add(buttonContainer);

var addButton = Ti.UI.createButton({
	left:0, width:150, title:'Add (+)'
});
buttonContainer.add(addButton);

var subtractButton = Ti.UI.createButton({
	right:0, width:150, title:'Subtract (-)'
});
buttonContainer.add(subtractButton);

subtractButton.addEventListener('click',function(){
	displayCount--;
	updateCounter();
});

addButton.addEventListener('click',function(){
	displayCount++;
	updateCounter();
});

var displayCounter = function(){
	countLabel.text = "Count: " + displayCount;
};

var updateCounter = function(){
	var sec = 10;
	alert("You close this message and open notification center. Your updates will happen in " + sec + " seconds");
	setTimeout(function(){
		wormhole.post(sampleEventName,{displayNumber:displayCount});
	},(sec * 1000));	
	displayCounter();	
};

var getWormValue = function(hole,fieldName,defaultValue){
	if(hole === undefined){
		return defaultValue;
	}
	if(hole.hasOwnProperty("wormhole")){
		if(hole.wormhole.hasOwnProperty(fieldName)){
			return hole.wormhole[fieldName];
		}else{
			return defaultValue;	
		}
	}else{
		return defaultValue;
	}	
};

console.log("starting the wormhole process");
console.log("First we create a wormhole");
wormhole.start({
	suiteName:sampleGroupIdentifier,
	directory:sampleWormDirectory
});

console.log("Next we add a wormhole listener");	
wormhole.addWormhole(sampleEventName,function(e){
	console.log("Event in ti app: " + JSON.stringify(e));
	displayCount = getWormValue(e,"displayNumber",0);
	displayCounter();
});

var readWormholeValues = function(){
	console.log("Need to add any saved wormhole values to start our display counter");	
	var holeValues = wormhole.readWormhole(sampleEventName);
	console.log("holeValues:" + JSON.stringify(holeValues));	
	displayCount = getWormValue(holeValues,"displayNumber",0);
};

win.addEventListener('open',function(){
	readWormholeValues();
	displayCounter();
});	
	
win.open();
