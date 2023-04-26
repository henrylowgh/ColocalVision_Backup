	
	//Configure initial settings
	run("Set Scale...", "distance=1 known=0.0225 unit=um global"); // Set measurement scale
	run("Colors...", "foreground=white background=black"); //Set Background and Foreground colors
	setOption("BlackBackground", true); //Avoid inverted LUT values
	setOption("Display Label", true); //Show channel and z-slice in results column
	setOption("Limit to Threshold", true); //Only measure thresholded regions

	emptyArray = newArray(0);
	Table.create("ThresholdValues");
	
	for (i = 1; i < 5; i++) {
		Table.setColumn("C" + i + "-Lower", emptyArray);
		Table.setColumn("C" + i + "-Upper", emptyArray);
	}
	
	
	//Variables for storing threshold values
	var tC1lower;
	var tC1upper;
	var tC2lower;
	var tC2upper;
	var tC3lower;
	var tC3upper;
	var tC4lower;
	var tC4upper;
	
	//Channel names
	c1Name = "MAP2";
	c2Name = "TAU";
	c3Name = "BAI2";
	c4Name = "PICCOLO";
	
	
	//Set Channel Colors
	rename("MainWindow");
	Stack.setChannel(1);
	run("Green");
	Stack.setChannel(2);
	run("Red");
	Stack.setChannel(3);
	run("Yellow");
	Stack.setChannel(4);
	run("Cyan");


	//Set Contrast
	Stack.setChannel(1);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(2);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(3);
	run("Enhance Contrast", "saturated=0.35");
	Stack.setChannel(4);
	run("Enhance Contrast", "saturated=0.35");


	//Create Composite Duplicate
	run("Make Composite");
	run("Duplicate...", "title=Composite duplicate range=1-10");


	//Split channels from original image and rename channel windows
	selectWindow("MainWindow");
	run("Split Channels");

	selectWindow("C1-MainWindow");
	rename("MAP2");
	run("Duplicate...", "title=MAP2Mask duplicate range=1-10");

	selectWindow("C2-MainWindow");
	rename("TAU");
	run("Duplicate...", "title=TAUMask duplicate range=1-10");

	selectWindow("C3-MainWindow");
	rename("BAI2");
	run("Duplicate...", "title=BAI2Mask duplicate range=1-10");

	selectWindow("C4-MainWindow");
	rename("PICCOLO");
	run("Duplicate...", "title=PICCOLOMask duplicate range=1-10");


	//Perform autothreshold on duplicated channels using default algorithm
	//Threshold with dark background, on entire stack, using STACK HISTOGRAM
	//Non-inverted LUT values(black = 0, white = 255) 
	//Automatically convert to binary masks
	selectWindow("MAP2Mask");
	setAutoThreshold("Default dark stack");
	getThreshold(lower, upper);
	tC1lower = lower;
	tC1upper = upper;
	print("C1 Threshold: " + tC1lower + " " + tC1upper);
	Table.set("C1-Lower", 0, tC1lower);
	Table.set("C1-Upper", 0, tC1upper);

	selectWindow("TAUMask");
	setAutoThreshold("Default dark stack");
	getThreshold(lower, upper);
	tC2lower = lower;
	tC2upper = upper;
	print("C2 Threshold: " + tC2lower + " " + tC2upper);
	Table.set("C2-Lower", 0, tC2lower);
	Table.set("C2-Upper", 0, tC2upper);

	selectWindow("BAI2Mask");
	setAutoThreshold("Default dark stack");
	getThreshold(lower, upper);
	tC3lower = lower;
	tC3upper = upper;
	print("C3 Threshold: " + tC3lower + " " + tC3upper);
	Table.set("C3-Lower", 0, tC3lower);
	Table.set("C3-Upper", 0, tC3upper);

	selectWindow("PICCOLOMask");
	setAutoThreshold("Default dark stack");
	getThreshold(lower, upper);
	tC4lower = lower;
	tC4upper = upper;
	print("C4 Threshold: " + tC4lower + " " + tC4upper);
	Table.set("C4-Lower", 0, tC4lower);
	Table.set("C4-Upper", 0, tC4upper);

	while (nImages > 0) { 
		selectImage(nImages); 
		close(); 
	} 