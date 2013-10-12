#use 
#sed 's/\r//g' rename_find.sh > rename_find_lix.sh

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
    # awk '{
    #     $name = "'"$filename"'";
    #     print "tail=",+ substr( $name, match( $name, /[1-9]/ ) );
    # }' $resourcesDir"/"$filename | sed 's/\s//g' > temp.sh;

    # source ./temp.sh;
    # #handle
    # echo $tail;
    # rm ./temp.sh;
    # sed 's/\(\d{1,3}\)/\1/g' "$filename";
}

#start
echo "------------Start------------";
# for file in ` ls $resourcesDir `
#     do
#         handle $file;
#     done

#example
# find -name '*.sh' –printf %f\\n \
#     | awk –F . '{ print $1 }' \
#     | xargs –i{} mv {}.sh {}\[${USER}\].sh 

#ok
find $resourcesDir -name '*.*' \
    | awk -F \/ '{print $3}' \
    | sed 's/^\([^0-9]*\)\([0-9]*\)\(.*\)\.\(.*\)$/\1 \2 \3 \4 \0/g' \
    | awk -v resourcesDir=$resourcesDir -v targetDir=$targetDir '{
            printf "cp \"%s/%s\" \"%s/%s%03d%s.%s\"\n", resourcesDir, $5, targetDir, $1, $2, $3, $4;
        }' \
    | awk '{
            system( $0 );
        }'
    # | xargs -I{} cp {}