# Detects disk to use for installation.
#
# If there's only one disk then it will be used. Otherwise, user will be
# prompted to choose installation disk.
function detect_disk
  # read all disks
  set -l disks (
    lsblk -o PATH,TYPE \
        | grep disk \
        | cut -d ' ' -f 1
  )
  set -l len (count $disks)

  # if only one then print it
  if test $len -le 1
    echo $disks
    return
  end

  # otherwise ask user to choose
  echo "Choose disk to use for installation:" >&2
  for i in (seq 1 $len)
    echo " $i. $disks[$i]" >&2
  end

  set -l choice 0
  while ! contains $choice (seq 1 $len)
    read choice
  end

  # print choosen disk
  echo $disks[$choice]
end
