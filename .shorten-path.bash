# Simple BASH function that shortens
# a very long path for display by removing
# the left most parts and replacing them
# with a leading ...
#
# the first argument is the path
#
# the second argument is the maximum allowed
# length including the '/'s and ...
#
shorten_path()
 {
  x=${1}
  len=${#x}
  max_len=$2

  if [ $len -gt $max_len ]
  then
      # finds all the '/' in
      # the path and stores their
      # positions
      #
      pos=()
      for ((i=0;i<len;i++))
      do
          if [ "${x:i:1}" == "/" ]
          then
              pos=(${pos[@]} $i)
          fi
      done
      pos=(${pos[@]} $len)

      # we have the '/'s, let's find the
      # left-most that doesn't break the
      # length limit
      #
      i=0
      while [ $((len-pos[i])) -gt $((max_len-3)) ]
      do
          i=$((i+1))
      done

      # let us check if it's OK to
      # print the whole thing
      #
      if [ ${pos[i]} == 0 ]
      then
          # the path is shorter than
          # the maximum allowed length,
          # so no need for ...
          #
          echo ${x}

      elif [ ${pos[i]} == $len ]
      then
          # constraints are broken because
          # the maximum allowed size is smaller
          # than the last part of the path, plus
          # '...'
          #
          echo ...${x:((len-max_len+3))}
      else
          # constraints are satisfied, at least
          # some parts of the path, plus ..., are
          # shorter than the maximum allowed size
          #
          echo ...${x:pos[i]}
      fi
  else
      echo ${x}
  fi
 }

