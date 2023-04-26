import ij.*;
import ij.process.*;
import ij.gui.*;
import java.awt.*;
import ij.plugin.*;

public class ImageSetup implements PlugIn {

	public void run(String arg) {
		ImagePlus imp = IJ.getImage();
		imp.setTitle("Main");
		//IJ.run("Channels Tool...");
		imp.setC(1);
		IJ.run(imp, "Green", "");
		imp.setC(2);
		IJ.run(imp, "Red", "");
		imp.setC(3);
		IJ.run(imp, "Yellow", "");
		imp.setC(4);
		IJ.run(imp, "Cyan", "");
		//IJ.run("Brightness/Contrast...");
		IJ.run(imp, "Enhance Contrast", "saturated=0.35");
		imp.setDisplayRange(1, 31);
		IJ.run(imp, "Enhance Contrast", "saturated=0.35");
		imp.setDisplayRange(1, 50);
		IJ.run(imp, "Enhance Contrast", "saturated=0.35");
		imp.setDisplayRange(1, 73);
		IJ.run(imp, "Enhance Contrast", "saturated=0.35");
		imp.setDisplayRange(1, 9);
		IJ.run("Make Composite", "");
		IJ.run("Duplicate...", "title=Composite");
		ImagePlus[] channels = ChannelSplitter.split(imp);
		IJ.selectWindow("Main-C1");
		imp.setTitle("MAP2");
		IJ.selectWindow("Main-C2");
		imp.setTitle("TAU");
		IJ.selectWindow("Main-C3");
		imp.setTitle("BAI2");
		IJ.selectWindow("Main-C4");
		imp.setTitle("PICCOLO");
	}

}
