/* BATCH IMAGE THRESHOLD ANALYSIS SCRIPT */
/* Developed By Henry Low */
/* Diaz Lab - University of California, Davis */
/* Acknowledgements: I thank Christina Meyer, Dr. David Speca, and Dr. Elva Diaz for their 
input, and feedback during the process of developing this tool! */


import ij.WindowManager as WindowManager
import ij.plugin.frame.RoiManager as RoiManager

class BatchThresholdAnalysis implements DialogListener {
/* Graphical User Interface (GUI) for inputting preferences*/
Dialog.create("ColocalVision - Batch Image Threshold Analysis Settings")

Dialog.addMessage("Channel Names", 18, "blue")
Dialog.addString("Channel 1:", "MAP2")
Dialog.addString("Channel 2:", "TAU")
Dialog.addString("Channel 3:", "BAI2")
Dialog.addString("Channel 4:", "PICCOLO")

Dialog.addMessage("Z-Slice Projection", 18, "blue")
Dialog.addCheckbox("Use Max Intensity Z-Slice Projections for Determining Image Thresholds", false)

autoThresholdArray = ["Default", "Huang", "Intermodes", "IsoData", "IJ_IsoData", "Li", "MaxEntropy", "Mean", "MinError", "Minimum", "Moments", "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Shanbhag", "Yen"]
Dialog.addMessage("Autothresholding Algorithm", 18, "blue")
Dialog.addRadioButtonGroup("Select an algorithm to use for calculating the threshold values (Click Help button for more info)", autoThresholdArray, 3, 6, "Default")
Dialog.addHelp("https://imagej.net/plugins/auto-threshold")

Dialog.addMessage("Script developed by Henry Low (with input and feedback from Christina Meyer, Dr. David Speca, and Dr. Elva Diaz)", 12, "#a800a8")

Dialog.show()


/* Variables */
c1Name = Dialog.getString()
c2Name = Dialog.getString()
c3Name = Dialog.getString()
c4Name = Dialog.getString()

zProjectOption = Dialog.getCheckbox()

autoThresholdOption = Dialog.getRadioButton()


/* Configure global settings */
setOption("BlackBackground", true) //Avoid inverted LUT values
setOption("Display Label", true) //Show channel and z-slice information in results column
setOption("Limit to Threshold", true) //Only measure thresholded images

//setBatchMode(true) // Enables BatchMode (Configures ImageJ console for batch processing)

/* Initialize Batch Processing */
run("Clear Results") //Clear previous results
inputDirectory = getDirectory("Choose a Directory of Images") //User dialog for selecting a directory of images
fileList = getFileList(inputDirectory) //Get the list of image files from that directory

/* Initialize Threshold Table */
//Create table to store threshold values
emptyArray = [0]
Table.create("ThresholdTable")

//Initialize threshold table columns
for (j = 1; j < 5; j++) {
    Table.setColumn("C" + j + "-Lower", emptyArray)
    Table.setColumn("C" + j + "-Upper", emptyArray)
}
Table.setColumn("Image", emptyArray)

/* Process each image in input folder */ 
for (i = 0; i < fileList.length; i++) {
    processImageThresholds(fileList[i]) //Call main function
}

calculateAverages() //Calculate average thresholds

//setBatchMode(false) // Disable BatchMode

/* Save threshold table as file (such as a .csv file) */
outputFile = File.openDialog("Save threshold values as a file") // User dialog for selecting file save location
selectWindow("ThresholdTable")
saveAs("Results", outputFile)  //
//Function for setting channel color
def setChannelColor(channelIndex, color) {
    Stack.setChannel(channelIndex)
    run(color)
}

//Function for creating a new Max Intensity Z-projection of the original image and using it for determining channel thresholds
def createZProjection() {
    run("Z Project...", "projection=[Max Intensity]")
    selectWindow("MainWindow")
    close()
    selectWindow("MAX_MainWindow")
    rename("MainWindow")
}

//Function for renaming and duplicating channel windows
def renameWindow(channelIndex, name) {
    selectWindow("C" + channelIndex + "-MainWindow")
    rename(name)
    run("Duplicate...", "title=" + name + "Mask duplicate range=1-10")
}

//Main function for determining threshold ranges of channels in each image
def processImageThresholds(imageFile) {       
    open(imageFile)
    
    // Configure image settings
    run("Set Scale...", "distance=1 known=0.0225 unit=um global") //Edit this if scale is different
    run("Colors...", "foreground=white background=black") //Set LUT defaults
    
    // Get the filename from the title of the image that is currently open
    def fileName = getTitle()
    print(fileName)
    
    def tC1lower = 0
    def tC1upper = 0
    def tC2lower = 0
    def tC2upper = 0
    def tC3lower = 0
    def tC3upper = 0
    def tC4lower = 0
    def tC4upper = 0
    
    //Set Channel Colors
    rename("MainWindow")
    setChannelColor(1, "Green")
    setChannelColor(2, "Red")
    setChannelColor(3, "Yellow")
    setChannelColor(4, "Cyan")
    
    //Increase contrast for each channel
    for (def x = 1; x <= 4; x++)  {
        Stack.setChannel(x)
        run("Enhance Contrast", "saturated=0.35")
    }
    
    // Create Max Intensity Z Projection if option was checked
    if (zProjectOption) createZProjection()
    
    //Create Composite Duplicate
    run("Make Composite")
    run("Duplicate...", "title=Composite duplicate range=1-10")
    
    //Split channels from original image and rename channel windows
    selectWindow("MainWindow")
    run("Split Channels")
    
    //Rename channel windows and create duplicates to be converted into binary masks during thresholding
    renameWindow(1, c1Name)
    renameWindow(2, c2Name)
    renameWindow(3, c3Name)
    renameWindow(4, c4Name)
    
    //Perform autothreshold on duplicated channels using default algorithm
    //Threshold with dark background, on entire stack, using STACK HISTOGRAM
    //Non-inverted LUT values(black = 0, white = 255) 
    //Automatically convert to binary masks
    selectWindow(c1Name + "Mask")
    setAutoThreshold(autoThresholdOption + " dark stack")
    getThreshold(lower, upper)
    tC1lower = lower
    tC1upper = upper
    //print("C1 Threshold: " + tC1lower + " " + tC1upper)
    Table.set("C1-Lower", i, tC1lower)
    Table.set("C1-Upper", i, tC1upper)
    
    selectWindow(c2Name + "Mask")
	
//Function for setting channel color
def setChannelColor(channelIndex, color) {
	Stack.setChannel(channelIndex)
	run(color)
}

//Function for creating a new Max Intensity Z-projection of the original image and using it for determining channel thresholds
def createZProjection() {
	run("Z Project...", "projection=[Max Intensity]")
	selectWindow("MainWindow")
	close()
	selectWindow("MAX_MainWindow")
	rename("MainWindow")
}

//Function for renaming and duplicating channel windows
def renameWindow(channelIndex, name) {
	selectWindow("C" + channelIndex + "-MainWindow")
	rename(name)
	run("Duplicate...", "title=" + name + "Mask duplicate range=1-10")
}
