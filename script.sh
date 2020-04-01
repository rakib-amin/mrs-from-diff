# branch_to_compare
remote_branch_to_compare='origin/some-branch'

# setup repo
git clone git@github.com:rakib-amin/mrs-from-diff.git
cd mrs-from-diff
git fetch --all
git checkout $remote_branch_to_compare
git pull

# create diff 
git diff origin/master --name-only > ../diff.txt

repo_pwd=`pwd`

# loop through diff set for occurances of some changes you're interested in
list=()
count_total=0
while read p; do
  count=`grep -Rn some_change_im_interested_in "$repo_pwd/$p" | wc | awk '{ print $1; }'`
  if [[ $count > 0 ]] ; then
    list+=($p)
    count_total=$((count_total+1))
  fi
done <../diff.txt

# create assignments list
assignments=()
for i in ${list[@]}; do 
  filename="$(cut -d':' -f2 <<<"$i")"
  author=`git blame --show-email $filename | grep 'some_change_im_interested_in' | head -1 | sed -e 's/.*<\(.*\)@.*>.*/\1/'`
  assignments+=("$author"">""$i")
done 

# create assignemnts
for i in ${assignments[@]}; do 
  echo $i; 
done>../out.txt
