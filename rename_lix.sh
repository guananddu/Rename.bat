#use 
#sed 's/\r//g' rename.sh > rename_lix.sh

#usag
usage() {
    echo "Usage: sh rename.sh [-d dir] [-t target] [-r] [-a] [-n]";
    exit 1;
}

#vars
resourcesDir="./resources";
targetDir="./output";
renameType="replace";

while getopts d:t:ran option; do
    case "$option" in 
        d)
            echo "option: resources, value: $OPTARG";
            resourcesDir=$OPTARG;;
        t)
            echo "optins: target, value: $OPTARG";
            targetDir=$OPTARG;;
        r)
            renameType="replace";;
        a)
            renameType="append";;
        n)
            renameType="num";;
        \?) 
            usage;
            ;;
    esac    
done

#ensure
echo $resourcesDir;
echo $targetDir;
echo $renameType;

#handle
handle() {
    filename=$1;
    #find the num
    awk 'BEGIN {
        $name = "'"$filename"'";
        print "tail=",+ substr( $name, match( $name, /[1-9]/ ) );
    }' | sed 's/\s//g' > temp.sh;

    source ./temp.sh;
    #handle
    echo $tail;
    rm ./temp.sh;
}

#start
echo "------------Start------------";
for file in ` ls $resourcesDir `
    do
        handle $file;
    done