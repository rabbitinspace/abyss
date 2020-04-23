# Erases and partitions a disk.
#
# The function will erase the disk, convert partition table to GPT
# and create two partitions: EFI system partition and the root partition.
#
# Args:
#   $disk - name of the disk to partition.
#   $label - GPT label.
#   $align - sector alignment.
function partition -a disk -a label -a align
  sgdisk --zap-all --clear --mbrtogpt \
    --new 1:0:+550M --typecode 1:EF00 \
    --new 2:0:0 --typecode 2:8300 --set-alignment $align --change-name $label \
    $disk >&2
end

# Prints name of a disk partition at specific index.
#
# If there's no partition at the provided index, the script will terminate
# the process with code 1.
#
# Args:
#   $disk - name of the disk to get partition from.
#   $index - index of the partition which name to print.
function get_partition -a disk -a index
  set -l partitions (
    lsblk $disk -o PATH,TYPE \
      | grep part \
      | cut -d ' ' -f 1
  )

  if ! contains $index (seq 1 (count $partitions))
    echo "No partition with at index $index" >&2
    return 1
  end

  echo $partitions[$index]
end
