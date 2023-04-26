
	// Define directories and file suffix for images
	#@ File (label = "Input directory", style = "directory") input
	#@ File (label = "Output directory", style = "directory") output
	#@ String (label = "File suffix", value = "") suffix

	// Create table to store threshold values
	emptyArray = newArray(0);
	Table.create("ThresholdTable");
	
	// Initialize threshold table columns
	for (j = 1; j < 5; j++) {
		Table.setColumn("C" + j + "-Lower", emptyArray);
		Table.setColumn("C" + j + "-Upper", emptyArray);
	}
	Table.setColumn("Image", emptyArray);	
	
	//Perform batch processing
	processFolder(input);
	
	// function to scan folders/subfolders/files to find files with correct suffix
	function processFolder(input) {
		list = getFileList(input);
		list = Array.sort(list);
		for (i = 0; i < list.length; i++) {
			if(File.isDirectory(input + File.separator + list[i]))
				processFolder(input + File.separator + list[i]);
			if(endsWith(list[i], suffix))
				processFile(input, output, list[i]);
		}
	}

	function processFile(input, output, file) {
		
		print("Processing: " + input + File.separator + file);

		run("Bio-Formats Importer", "open=" + inputDirectory + fileList[i] + " color_mode=Default rois_import=[ROI manager] split_channels view=Hyperstack stack_order=XYCZT");	
		
		// Configure initial settings
		setOption("BlackBackground", true); //Avoid inverted LUT values
		setOption("Display Label", true); //Show channel and z-slice in results column
		setOption("Limit to Threshold", true); //Only measure thresholded regions
		run("Set Scale...", "distance=1 known=0.0225 unit=um global"); // Set measurement scale
		run("Colors...", "foreground=white background=black"); //Set Background and Foreground colors
		
		// Get the filename from the title of the image that's open
		fileName = getTitle();
		print(fileName);
		
		tC1lower = 0;
		tC1upper = 0;
		tC2lower = 0;
		tC2upper = 0;
		tC3lower = 0;
		tC3upper = 0;
		tC4lower = 0;
		tC4upper = 0;
		
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
		
		//Table.set("Image", i, filename);
		
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
		Table.set("C1-Lower", i, tC1lower);
		Table.set("C1-Upper", i, tC1upper);
		
		selectWindow("TAUMask");
		setAutoThreshold("Default dark stack");
		getThreshold(lower, upper);
		tC2lower = lower;
		tC2upper = upper;
		print("C2 Threshold: " + tC2lower + " " + tC2upper);
		Table.set("C2-Lower", i, tC2lower);
		Table.set("C2-Upper", i, tC2upper);
		
		selectWindow("BAI2Mask");
		setAutoThreshold("Default dark stack");
		getThreshold(lower, upper);
		tC3lower = lower;
		tC3upper = upper;
		print("C3 Threshold: " + tC3lower + " " + tC3upper);
		Table.set("C3-Lower", i, tC3lower);
		Table.set("C3-Upper", i, tC3upper);
		
		selectWindow("PICCOLOMask");
		setAutoThreshold("Default dark stack");
		getThreshold(lower, upper);
		tC4lower = lower;
		tC4upper = upper;
		print("C4 Threshold: " + tC4lower + " " + tC4upper);
		Table.set("C4-Lower", i, tC4lower);
		Table.set("C4-Upper", i, tC4upper);

		Table.set("Image", i, fileName);
		
		while (nImages>0) { 
			selectImage(nImages); 
			close(); 
		} 

	}

	// Save threshold table as file
	outputFile = File.openDialog("Save threshold values as a file"); // User dialog for selecting file save location
	selectWindow("ThresholdTable");
	saveAs("Results", outputFile);  // Save the threshold data	
	