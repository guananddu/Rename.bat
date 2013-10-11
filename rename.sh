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

#for replace
ls -l $resourcesDir \
    | awk '{print $9}' \
    | sed '1d;s/^\([^0-9]*\)\([0-9]*\)\(.*\)\.\(.*\)$/\0 \1 \2 \3 \4/g' \
    | awk -v resourcesDir=$resourcesDir -v targetDir=$targetDir 'BEGIN{
            printf "#ALLNAME | LEFT | NUM | RIGHT | EXT\n"
            printf "#-------------------------------------------\n"
        }
        {printf "cp \"%s/%s\" \"%s/%s%03d%s.%s\"\n", resourcesDir, $1, targetDir, $2, $3, $4, $5}' \
    > .temp.replace.sh

#for append
ls -l $resourcesDir \
    | awk '{print $9}' \
    | sed '1d;s/^\([^0-9]*\)\([0-9]*\)\(.*\)\.\(.*\)$/\0 \1 \2 \3 \4/g' \
    | awk -v resourcesDir=$resourcesDir -v targetDir=$targetDir 'BEGIN{
            printf "#ALLNAME | LEFT | NUM | RIGHT | EXT\n"
            printf "#-------------------------------------------\n"
        }
        {printf "cp \"%s/%s\" \"%s/%03d%s%03d%s.%s\"\n", resourcesDir, $1, targetDir, $3, $2, $3, $4, $5}' \
    > .temp.append.sh

#for num
ls -l $resourcesDir \
    | awk '{print $9}' \
    | sed '1d;s/^\([^0-9]*\)\([0-9]*\)\(.*\)\.\(.*\)$/\0 \1 \2 \3 \4/g' \
    | awk -v resourcesDir=$resourcesDir -v targetDir=$targetDir 'BEGIN{
            printf "#ALLNAME | LEFT | NUM | RIGHT | EXT\n"
            printf "#-------------------------------------------\n"
        }
        {printf "cp \"%s/%s\" \"%s/%03d.%s\"\n", resourcesDir, $1, targetDir, $3, $5}' \
    > .temp.num.sh

if [[ $renameType == "replace" ]]; then
    echo "Type: replace..."
    source ./.temp.replace.sh
fi

if [[ $renameType == "append" ]]; then
    echo "Type: append..."
    source ./.temp.append.sh
fi

if [[ $renameType == "num" ]]; then
    echo "Type: num..."
    source ./.temp.num.sh
fi

echo "Done.Ok."

#clean
rm ./.temp.replace.sh
rm ./.temp.append.sh
rm ./.temp.num.sh

#有一种简单方式，直接使用for循环，文件名是确定的
