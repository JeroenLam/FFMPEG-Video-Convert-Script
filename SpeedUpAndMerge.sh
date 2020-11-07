# - - Ask user for the name of the project - - 
read -r -p "What is the name of the project? " var_name;
if [ -z "$var_name" ]; then
	echo "ERROR: no name provided";
	read temp;
	exit
fi

# - - Ask user how much speed they want - - 
read -r -p "How much do you want to speed up the video? (default 20x) " var_factor;
if [ -z "$var_factor" ]; then
	var_factor=20;
fi
var_coeficient=$(printf %.5f "$((10**5 * 1/$var_factor))e-5");

# - - Ask user what file extension they want - - 
read -r -p "What filetype do you want the result to be? (default .mp4) " var_extension;
if [ -z "$var_extension" ]; then
	var_extension=".mp4";
fi

# - - Ask user if they want to contatenate the video files - -
notReady=true;
while $notReady;
do
	read -r -p "Do you want to combine all video files? [Y/n] " input;
	case $input in
		[yY][eE][sS]|[yY]|"")
			var_concat=1;
			notReady=false;
		;;
		[nN][oO]|[nN])
			var_concat=0;
			notReady=false;
		;;
		*)
			echo "Invalid input...";
		;;
	esac
done


# Create project folder in Output
mkdir "./Output/$var_name";
if [[ $var_concat -ne 0 ]]; then
	echo "Preparing combining!"
	sleep 1;
	# Find all files and make a list of them
	for file in ./Input/*; do
		echo "file '$file'" >> temp.txt;
	done
	# Video conversion
	ffmpeg -f concat -safe 0 -itsscale $var_coeficient -i temp.txt -c copy "./Output/$var_name/$var_name$var_extension"
	rm temp.txt;
else
	echo "Preparing speedup!"
	sleep 1;
	idx=0;
	for file in ./Input/*; do
		# Video conversion
		ffmpeg -itsscale $var_coeficient -i $file -c copy "./Output/$var_name/20x-$idx$var_extension"
		echo 
		idx=$((idx+1));
	done
fi

# Copy video files to the project folder
mv ./Input/* ./Output/"$var_name"/;
	
	
read -r -p "Conversion is done! (press enter to leave)" temp;