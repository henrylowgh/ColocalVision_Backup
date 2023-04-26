	
	/* COLOCALIZATION ANALYSIS SCRIPT */
	/* Developed By Henry Low */
	/* Diaz Lab - University of California, Davis */
	/* Acknowledgements: I thank Christina Meyer, Dr. David Speca, and Dr. Elva Diaz for their 
	input, and feedback during the process of developing this tool! */

	/* Graphical User Interface (GUI) for inputting preferences*/
	Dialog.create("ColocalVision - Colocalization Analysis Settings");

	// Input channel names
	Dialog.addMessage("Channel Names", 15, "blue");
	Dialog.addString("Channel 1:", "MAP2");
	Dialog.addToSameRow();
	Dialog.addString("Channel 2:", "TAU");
	Dialog.addToSameRow();
	Dialog.addString("Channel 3:", "BAI2");
	Dialog.addToSameRow();
	Dialog.addString("Channel 4:", "PICCOLO");

	// Input channel threshold values
	Dialog.addMessage("Threshold Values", 15, "blue");
	Dialog.addNumber("C1 - Lower:", 0);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 - Upper:", 255);
	Dialog.addNumber("C2 - Lower:", 0);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 - Upper:", 255);
	Dialog.addNumber("C3 - Lower:", 0);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 - Upper:", 255);
	Dialog.addNumber("C4 - Lower:", 0);
	Dialog.addToSameRow();
	Dialog.addNumber("C4 - Upper:", 255);

	// Select which pairs of channels to perform colocalization analysis on
	Dialog.addMessage("Channel Pairs to Use for Colocalization Analysis", 15, "blue");
	channelPairsArray = newArray("C1 + C2", "C1 + C3", "C1 + C4", "C2 + C3", "C2 + C4", "C3 + C4");
	defaultCheckboxArray = newArray(6);
	for (i = 0; i < 6; i++) {
		defaultCheckboxArray[i] = false;
	}
	Dialog.addCheckboxGroup(2, 3, channelPairsArray, defaultCheckboxArray);


	
	// Input whether to use Z projections + whether to view original image channels as STACK or PROJECTION
	Dialog.addMessage("Z Projection Options", 15, "blue");
	zProjectOptionsArray = newArray("None", "(A) Use Z Projection + View Original Image as Z-STACK", "(B) Use Z Projection + View Original Image as Z-PROJECTION");
	//Dialog.addMessage("Select a Z Projection option", 12, "black");
	//Dialog.addChoice("Select an option", zProjectOptionsArray, "None");
	Dialog.addRadioButtonGroup("Select an option. Leave as 'None' if you do not want to use Z Projections in your analysis.", zProjectOptionsArray, 3, 1, "None");
	Dialog.addMessage("(A) and (B) produce the same measurement results, differing only in how the original image channels are displayed.", 10, "black");



	// Input measurement settings
	Dialog.addMessage("Particle Size Measurement Settings (Units of pixel^2)", 15, "blue");
	//Dialog.addMessage("Measurement Units in pixel^2", 10, "black");

	Dialog.addNumber("C1 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C4 Min", 0.005);
	
	Dialog.addNumber("C1 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C4 Max", 1000);
	
	Dialog.addNumber("C1 + C2 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C3 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C4 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 + C3 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 + C4 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 + C4 Min", 0.005);

	Dialog.addNumber("C1 + C2 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C3 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C4 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 + C3 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 + C4 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 + C4 Max", 1000);
	
	/*
	Dialog.addNumber("C1 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 Max", 1000);
	
	Dialog.addNumber("C3 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C4 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C4 Max", 1000);
	
	Dialog.addNumber("C1 + C2 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C2 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C3 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C3 Max", 1000);
	
	Dialog.addNumber("C1 + C4 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C1 + C4 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 + C3 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 + C3 Max", 1000);

	Dialog.addNumber("C2 + C4 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C2 + C4 Max", 1000);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 + C4 Min", 0.005);
	Dialog.addToSameRow();
	Dialog.addNumber("C3 + C4 Max", 1000);
	*/

	
	
	// Set measurement scale
	Dialog.addMessage("Measurement Scale", 15, "red"); 	
	Dialog.addMessage("NOTE: Be aware that this sets the measurement scale in the GLOBAL preferences for ImageJ", 10, "black");	
	Dialog.addString("1 Pixel =", "0.0225");
	Dialog.addToSameRow();	
	Dialog.addString("Units:", "um");

	Dialog.addMessage("Script developed by Henry Low (with input and feedback from Christina Meyer, Dr. David Speca, and Dr. Elva Diaz)", 12, "#a800a8");	

	// Display user interface
	Dialog.show();



	/* Variables containing average threshold values (lower, upper) for each channel */ 
	// Upper thresholds should generally be 255
	C1lowerthresh = Dialog.getNumber();
	C1upperthresh = Dialog.getNumber();
	C2lowerthresh = Dialog.getNumber();
	C2upperthresh = Dialog.getNumber();
	C3lowerthresh = Dialog.getNumber();
	C3upperthresh = Dialog.getNumber();
	C4lowerthresh = Dialog.getNumber();
	C4upperthresh = Dialog.getNumber();
	
	/* Other variables */
	c1Name = Dialog.getString();
	c2Name = Dialog.getString();
	c3Name = Dialog.getString();
	c4Name = Dialog.getString();

	c1c2 = Dialog.getCheckbox();
	c1c3 = Dialog.getCheckbox();
	c1c4 = Dialog.getCheckbox();
	c2c3 = Dialog.getCheckbox();
	c2c4 = Dialog.getCheckbox();
	c3c4 = Dialog.getCheckbox();

	zProjectOption = Dialog.getRadioButton(); //Z Projection Options selection

	//Assign shorter Strings for zProjectOption if (A) or (B) was selected by user
	if (zProjectOption == "(A) Use Z Projection + View Original Image as Z-STACK") zProjectOption = "Option A";
	if (zProjectOption == "(B) Use Z Projection + View Original Image as Z-PROJECTION") zProjectOption = "Option B";

	c1minParticleSize = Dialog.getNumber();
	c2minParticleSize = Dialog.getNumber();
	c3minParticleSize = Dialog.getNumber();
	c4minParticleSize = Dialog.getNumber();
	c1maxParticleSize = Dialog.getNumber();
	c2maxParticleSize = Dialog.getNumber();
	c3maxParticleSize = Dialog.getNumber();
	c4maxParticleSize = Dialog.getNumber();

	c1c2min = Dialog.getNumber();
	c1c3min = Dialog.getNumber();
	c1c4min = Dialog.getNumber();
	c2c3min = Dialog.getNumber();
	c2c4min = Dialog.getNumber();
	c3c4min = Dialog.getNumber();
	c1c2max = Dialog.getNumber();
	c1c3max = Dialog.getNumber();
	c1c4max = Dialog.getNumber();
	c2c3max = Dialog.getNumber();
	c2c4max = Dialog.getNumber();
	c3c4max = Dialog.getNumber();
	
	/*
	print("C1 Min: " + c1minParticleSize);
	print("C2 Min: " + c2minParticleSize);
	print("C3 Min: " + c3minParticleSize);
	print("C4 Min: " + c4minParticleSize);
	
	print("C1 Max: " + c1maxParticleSize);
	print("C2 Max: " + c2maxParticleSize);
	print("C3 Max: " + c3maxParticleSize);
	print("C4 Max: " + c4maxParticleSize);

	print("C1 + C2 Min: " + c1c2min);
	print("C1 + C3 Min: " + c1c3min);
	print("C1 + C4 Min: " + c1c4min);
	print("C2 + C3 Min: " + c2c3min);
	print("C2 + C4 Min: " + c2c4min);
	print("C3 + C4 Min: " + c3c4min);
	
	print("C1 + C2 Max: " + c1c2max);
	print("C1 + C3 Max: " + c1c3max);
	print("C1 + C4 Max: " + c1c4max);
	print("C2 + C3 Max: " + c2c3max);
	print("C2 + C4 Max: " + c2c4max);
	print("C3 + C4 Max: " + c3c4max);
	*/
	
	scaleValue = Dialog.getString();
	scaleUnits = Dialog.getString();


	
	/* Configure global settings */
	run("Set Scale...", "distance=1 known=" + scaleValue + " unit=" + scaleUnits + " global"); //Measurement scale can be adjusted in user interface
	run("Colors...", "foreground=white background=black"); //Set LUT defaults
	setOption("BlackBackground", true); //Avoid using inverted LUT values
	setOption("Display Label", true); //Show channel and z-slice information in results table
	setOption("Limit to Threshold", true); //Only measure thresholded images



	/* Process and set up channel windows */
	//Set Channel Colors
	rename("MainWindow");
	setChannelColor(1, "Green");
	setChannelColor(2, "Red");
	setChannelColor(3, "Yellow");
	setChannelColor(4, "Cyan");
	
	//Increase contrast for each channel
	for (i = 1; i <= 4; i++)  {
		Stack.setChannel(i);
		run("Enhance Contrast", "saturated=0.35");
	}

	//If Z-Projection Option (B) was selected -> Create Max Intensity Z Projection + Display original image channels as PROJECTIONS
	if (zProjectOption == "Option B") createZProjection();

	//Create Composite Duplicate
	run("Make Composite");
	run("Duplicate...", "title=Composite duplicate range=1-10");

	//Split channels from original image
	selectWindow("MainWindow");
	run("Split Channels");

	//Rename channel windows and create duplicates to be converted into binary masks during thresholding
	renameWindow(1, c1Name);
	renameWindow(2, c2Name);
	renameWindow(3, c3Name);
	renameWindow(4, c4Name);



	/* Create binary masks using threshold values */
	createMask(c1Name + "Mask", C1lowerthresh, C1upperthresh);
	createMask(c2Name + "Mask", C2lowerthresh, C2upperthresh);
	createMask(c3Name + "Mask", C3lowerthresh, C3upperthresh);
	createMask(c4Name + "Mask", C4lowerthresh, C4upperthresh);

	/* Create new binary masks on the basis of overlapping signals between channel masks */
	if (c1c2) createCombinedMask(c1Name, c2Name); // MAP2 + TAU
	if (c1c3) createCombinedMask(c1Name, c3Name); // MAP2 + BAI2
	if (c1c4) createCombinedMask(c1Name, c4Name); // MAP2 + PICCOLO
	if (c2c3) createCombinedMask(c2Name, c3Name); // TAU + BAI2
	if (c2c4) createCombinedMask(c2Name, c4Name); // TAU + PICCOLO
	if (c3c4) createCombinedMask(c3Name, c4Name); // BAI2 + PICCOLO

	/* Analyze particle signals and display data in "Results" window */
	
	//Analyze individual channel masks
	performMeasurements(c1Name + "Mask", c1Name, c1minParticleSize, c1maxParticleSize); // MAP2Mask
	performMeasurements(c2Name + "Mask", c2Name, c2minParticleSize, c2maxParticleSize); // TAUMask
	performMeasurements(c3Name + "Mask", c3Name, c3minParticleSize, c3maxParticleSize); // BAI2Mask
	performMeasurements(c4Name + "Mask", c4Name, c4minParticleSize, c4maxParticleSize); // PICCOLOMask
	
	//Analyze colocalized channel masks
	if (c1c2) performMeasurements(c1Name + " + " + c2Name, c2Name, c1c2min, c1c2max);
	if (c1c3) performMeasurements(c1Name + " + " + c3Name, c3Name, c1c3min, c1c3max);
	if (c1c4) performMeasurements(c1Name + " + " + c4Name, c4Name, c1c4min, c1c4max);
	if (c2c3) performMeasurements(c2Name + " + " + c3Name, c3Name, c2c3min, c2c3max);
	if (c2c4) performMeasurements(c2Name + " + " + c4Name, c4Name, c2c4min, c2c4max);
	if (c3c4) performMeasurements(c3Name + " + " + c4Name, c4Name, c3c4min, c3c4max);
	

	/* Custom-defined functions for script tasks */

	//Function for setting channel color
	function setChannelColor(channelIndex, color) {
		
		Stack.setChannel(channelIndex);
		run(color);
		
	}

	//Function for creating a new Max Intensity Z-projection of the original image and using it for analysis
	function createZProjection() {
		
		run("Z Project...", "projection=[Max Intensity]");
		selectWindow("MainWindow");
		close();
		selectWindow("MAX_MainWindow");
		rename("MainWindow");
		
	}

	//Function for renaming and duplicating channel windows
	function renameWindow(channelIndex, name) {
		
		selectWindow("C" + channelIndex + "-MainWindow");
		rename(name);
		run("Duplicate...", "title=" + name + "Mask duplicate range=1-10");
		
	}

	//Function for creating binary masks using threshold values
	//Set threshold range using values acquired from AvgThresholdBatch.ijm script
	//Non-inverted LUT values(black = 0, white = 255) 
	//Automatically convert to binary masks with black background
	function createMask(maskName, lower, upper) {
		
		selectWindow(maskName);
		setThreshold(lower, upper);
		run("Convert to Mask", "method=Default background=Dark black");

		// If Z-Projection Option (A) was selected -> Create Max Intensity Z Projection at this step + Display original image channels as Z-STACKS
		if (zProjectOption == "Option A") { //Create and threshold Max Intensity Projection binary masks for each channel Z-stack
			run("Z Project...", "projection=[Max Intensity]");
			selectWindow(maskName);
			close();
			selectWindow("MAX_" + maskName);
			rename(maskName);
			setThreshold(lower, upper);
			run("Convert to Mask", "method=Default background=Dark black");
		}

		// If None or Option B was selected 
		else { //Use duplicate channel window created from previous step, directly threshold and convert into binary mask
			setThreshold(lower, upper);
			run("Convert to Mask", "method=Default background=Dark black");
		}
		
		
	}

	//Function for creating new binary masks on the basis of overlapping signals between channel masks using ImageCalculator 
	function createCombinedMask(mask1, mask2) {
		imageCalculator("AND create stack", mask1 + "Mask", mask2 + "Mask");
		selectWindow("Result of " + mask1 + "Mask");
		rename(mask1 + " + " + mask2);
	}

	//Function for analyzing particle signals and display data in "Results" window
	function performMeasurements(window, redirect, minParticleSize, maxParticleSize) {
		run("Set Measurements...", " area mean integrated limit display redirect=" + redirect + " decimal=4");
		selectWindow(window);
		run("Analyze Particles...", "size=" + minParticleSize + "-" + maxParticleSize + "circularity=0.00-1.00 show=[Overlay Outlines] display summarize stack");
	}
	
