# Make sure you add the directory of Openscad (where openscad.exe is located) to your environmental variables!
# You can do so, by doing the following:
# Go to: Start -> Settings -> Control Panel -> System -> Advanced tab -> Environment Variables -> System Variables, select Path, then click Edit.
# Click to add new environmental variable, and copy-paste the location of the openscad directory into it.

# To RUN this, make sure to install Git Bash!
# Once installed, Go into the directory of where your openscad documents are 
#	(and also where this script should be as well; if it is not there, then add it).
# Right click, and select "Git Bash Here".
# In the console git-bash window that opens up, simply type in the following command and hit enter:  
#	sh render.sh
#
#  And that's it. 
#  This will render and export the children in the script's module (assuming the script is written that way) one by one as separate stl files.
#
#  *Additional note: - Can also be altered to allow for taking snapshots instead of full renders. The quickest way to do this is to change
#						 the file export type from stl to png. On line ~64:  openscad -D childNum=${i} -o ${lines[$i]}.stl ${renderScadFile}
#						 Change ${lines[$i]}.stl TO ${lines[$i]}.png
#


#!/bin/bash

# Directories of where to move exported files (once exported)
exportedDirectory="exported/3D_Files";
echoDirectory="exported/text";

# Name of scad file that contains the children/ parts/ modules you wish to export
renderScadFile="render_children_template_example.scad";

#
# Make sure that the method the render.scad file calls has an echo for each child's name (and no other echoes!)
#  (this is by default, if using the "render_children" template)
# ---> This command will shove all those echoes into a file, which is read at a later step
echo "Getting names of parts / children...";
openscad -D childNum=-1 -o children.echo ${renderScadFile}  &     # run this job in the background via the & operator

wait $!		# make sure we finish this step first, so wait until this background process finishes --> pid=$! to get the process id.

# get and store all echoed children in array by reading the echoed children file
IFS=$'\r\n' read -d '' -r -a lines < children.echo

prefix="ECHO: ";	# the prefix we will remove from the echoed line(s)

# remove prefix from all lines
lines=("${lines[@]/#$prefix}");
# remove trailing and leading quotes
lines=("${lines[@]/#\"}");
lines=("${lines[@]/%\"}");
# replace any spaces with "_" for the file name --> for all lines
lines=("${lines[@]// /_}"); 

length=${#lines[@]};	# number of total parts / children (length of the echoed children array)

echo "Done! Here are the names of the parts: ";
echo "${lines[@]}";
echo "For a total of" $length "parts.";
echo "Proceeding to next step -> rendering ...";

beginChild=0;	# child to begin loop --> default is 0
endChild=$length;	# child when to end loop --> default is the number of total parts / children

for ((i=beginChild; i<endChild; i++)); do
	echo "Rendering child:" ${i};
	# openscad -D param1=${whatever} -D param2=$(i) -o [EXPORTED_FILE_NAME]_${i}.stl [SCAD_FILE_NAME].scad
	openscad -D childNum=${i} -o ${lines[$i]}.stl ${renderScadFile}
	echo "Done!";	
done &		# run this job in the background via the & operator

wait $!     # make sure we finish this step first, so wait until this background process finishes --> pid=$! to get the process id.

echo "Done! All child objects have been exported.";
echo "Moving rendered parts / children into exported directory...";

# move stl files into exported folder (and create it if it does not exist --> otherwise, override files already there with same name)
mkdir -p $exportedDirectory
mv *.stl $exportedDirectory

# move echoed children file into the exported files as well (*helps keep the original Code file structure clean)
mkdir -p $echoDirectory 
mv children.echo $echoDirectory

echo "All Done! All child objects have been exported and are now in the exported directory.";
