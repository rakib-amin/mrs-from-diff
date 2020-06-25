DIR_TO_CHK_OUT='test-dir'
BRANCH_FROM_WHERE_FILES_ARE='feature/some-out-dated-branch'

if [[ $# < 3 ]]; then
	echo "Usage: bash create_mr_from_list.sh [username] [feature] [input_file]"
	echo "example: bash create_mr_from_list.sh rakib add-file-reader list_files.txt"
	exit
fi

username=$1
module_name=$2
input_file=$3

file_list=()
while read line; do
  file_liet+=($line)
done<$input_file

git_branch="feature/${username}/${module_name}"

cd $DIR_TO_CHK_OUT
git fetch --all
git checkout origin/master
git checkout -b $git_branch 

for file_name in ${file_liet[@]}; do
    git checkout origin/$BRANCH_FROM_WHERE_FILES_ARE $file_name
done

git add .
git commit -m "! added files for ${module_name}"
git push --set-upstream origin $git_branch
