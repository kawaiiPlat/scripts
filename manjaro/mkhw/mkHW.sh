

printHelp(){
	echo "Useage: ./mkHW.sh [CLASS] [HW NAME]"
}

# main function
if [ $# -eq 2 ]
then
	# https://stackoverflow.com/a/246128
	SOURCE=${BASH_SOURCE[0]}
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
		DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
		SOURCE=$(readlink "$SOURCE")
		[[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
	done
	SCRIPT_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

	#checkClass $1

	dir=$PWD/$1
	if [ -d $dir ]
	then
		echo "$dir already exist, adding HW..."
	else
		echo "$dir doesn't already exist, ..."
		mkdir $dir
		mkdir "$dir/.config"

		echo "What is the professor's name?"
		read professor
		echo "$professor" > "$dir/.config/professor.txt"

		echo "What section / classNumber is this class"
		read classTime
		echo "$classTime" > "$dir/.config/classTime.txt"
	fi;

	#checkHW $1 $2
	file=$PWD/$1/$2/$2.tex
	if [ -f $file ]
	then
		echo "$file already exists, stopping..."
		exit 1
	else
		echo "$file doesn't already exist, creating..."
	fi;

	#makeHomework $1 $2
	dir=$PWD/$1/$2
	hwfile=$dir/$2.tex
	styfile=$dir/kawaiiHomework.sty
	style=$SCRIPT_DIR/Templates/kawaiiHomework/kawaiiHomework.sty
	template=$SCRIPT_DIR/Templates/kawaiiHomework/homework.tex

	echo "Making the directory $dir..."
	mkdir $dir

	if [ -f $template ]
	then
		echo "Copying template..."
		cp $template $hwfile
	else
		echo "Couldn't find $template, stopping" 
		exit 1
	fi

	if [ -f $style ]
	then
		echo "Copying style..."
		cp $style $styfile
	else
		echo "Couldn't find $style, stopping" 
		exit 1
	fi

	echo "Updating the Project and Class variables"

	classTime=$(<"$1/.config/classTime.txt")
	professor=$(<"$1/.config/professor.txt")

	sed -i "s/{TITLE}/\{$2\}/g" $hwfile
	sed -i "s/{CLASS}/\{$1\}/g" $hwfile
	sed -i "s/{SECTION}/\{$classTime\}/g" $hwfile
	sed -i "s/{PNAME}/\{$professor\}/g" $hwfile

else
	printHelp
	exit 1
fi
