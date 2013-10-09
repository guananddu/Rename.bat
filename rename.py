import os, re, sys, getopt;

fileList = [ ];
rootdir = "./resources";
todir   = "./output";
renameType = "replace";

def usage():
    print('''
        Usage: rename.py [options...]
        Options:
            -d : old dir
            -t : target
            -r : replace
            -a : append
            -n : num
            -h : help
        rename.py -d ./old -t ./new -a
        '''
        )

try:
    opts, args = getopt.getopt( sys.argv[1:],'d:t:ranh' );
except getopt.GetoptError:
    usage();
    sys.exit();

for opt, arg in opts:
    if opt in ( '-h', '--help' ):
        usage();
        sys.exit();
    elif opt == '-d':
        if ( len( arg ) > 0 ):
            rootdir = arg;
    elif opt == '-t':
        if ( len( arg ) > 0 ):
            todir = arg;
    elif opt == '-r':
        renameType = "replace";
    elif opt == '-a':
        renameType = "append";
    elif opt == '-n':
        renameType = "num";

#放入序列
for root, subFolders, files in os.walk( rootdir ):
    if '.svn' in subFolders: subFolders.remove( '.svn' )  # 排除特定目录
    for file in files:
        # 查找特定扩展名的文件
        # if file.find( ".t2t" ) != -1:
        #     file_dir_path = os.path.join( root, file )
        #     fileList.append( file_dir_path )
        
        fileList.append( file );

patten = re.compile( r'\d{1,3}' );

def changeName( patten, num, fileName ): 
    if ( renameType == 'replace' 
        or renameType == 'append' ):
        newFileName = re.sub( patten, num, fileName );
        if ( renameType == 'append' ):
            newFileName = num + newFileName;
        return newFileName;
    if ( renameType == 'num' ):
        return num + fileName[ fileName.find( '.' ): ];
    return fileName;


def handleFile( fileName ):
    nums = re.search( patten, fileName );
    if nums:
        print( '----------------------' );
        # fullPatho = os.path.join( rootdir, fileName );
        fullPatho = rootdir + '/' + fileName;
        print( 'Handleing: ' + fullPatho );
        #int to string
        num = str( nums.group( 0 ) );
        if len( num ) == 2:
            num = '0' + num;
        elif len( num ) == 1:
            num = '00' + num;

        #already done
        newFileName = changeName( patten, num, fileName );

        print( 'Rename to: ' + newFileName );
        #copy
        # fullPathn = os.path.join( todir, newFileName );
        fullPathn = todir + '/' + newFileName;
        os.system( 'cp ' + fullPatho + ' ' + fullPathn );
        print( 'Copy to: ' + fullPathn );
    else:
        print( 'Empty!' );


for file in fileList:
    handleFile( file );