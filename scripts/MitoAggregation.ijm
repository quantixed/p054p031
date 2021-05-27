/*
 * Original version of this:
 * 	extracted channel 2 from tif to do the segmentation
 * Now we will take nd2 files that are single channel and calibrated,
 * 	segment them and
 * 	quantify the blobs
 * It helps to switch the windowless option on for nd2 files before starting!
 */

// first macro definition
macro "MitoAgg Make Masks" {
	if (nImages > 0) exit ("Please close any images and try again.");
	inDir = getDirectory("Choose Source Directory ");
	outDir = getDirectory("Choose Destination Directory ");

	setBatchMode(true);
	processFolder(inDir, outDir);
	setBatchMode(false);
}

// builds file list
function processFolder(inputStr, outputStr) {
	list = getFileList(inputStr);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(endsWith(list[i], ".nd2")) {
			processFile(inputStr, list[i], outputStr);
		}
	}
}

// makes the mask and saves
function processFile(inputStr, file, outputStr)	{
	fPath = inputStr + File.separator + file;
	open(fPath);
	id0 = getImageID();
	title0 = getTitle();

	run("Duplicate...", "title=img1");
	id1 = getImageID();
	title1 = getTitle();
	run("Duplicate...", "title=img2");
	id2 = getImageID();
	title2 = getTitle();
	run("Gaussian Blur...", "sigma=10");

	imageCalculator("Subtract create", title1, title2);
	id3 = getImageID();
	title3 = getTitle();

	selectImage(id3);
	setAutoThreshold("Otsu dark");
	setOption("BlackBackground", true);
	run("Convert to Mask");
	sPath = outputStr + File.separator + replace(file, ".nd2", "_msk.tif");
	save(sPath);
	run("Close All");
}

// now for second macro definition
macro "MitoAgg Analyze Mask" {
	if (nImages == 0) exit ("Please open a mask image.");

	id0 = getImageID();
	title0 = getTitle();
	dir0 = getInfo("image.directory");
	fName0 = getInfo("image.filename");
	fPath = dir0 + File.separator + fName0;
	resultBaseName = File.getNameWithoutExtension(fPath);
	i = 0;
	rPath = dir0 + File.separator + resultBaseName + d2s(i,0) + ".csv";

	// we will save the results for name.tif as name_0.csv
	// or name_1.csv if name_0.csv exists
	do	{
		rPath = dir0 + File.separator + resultBaseName + d2s(i,0) + ".csv";
		i += 1;
	} while (File.exists(rPath));

	run("Set Measurements...", "area mean standard min perimeter integrated redirect=None decimal=3");
  	run("Analyze Particles...", "size=16-Infinity pixel display clear");
	selectWindow("Results");
	saveAs("Results", rPath);
	run("Close All");
}
