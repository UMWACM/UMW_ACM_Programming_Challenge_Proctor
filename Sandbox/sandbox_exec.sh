#!/bin/bash

# This script runs inside the sandbox and executes challenge code

# The submitted code is in /build
# args: language, filename, tmp_dir, chal_dir

# The inputs will be mounted at /in/NN.txt
# and we will write the resulting outputs of this code to /their_out/NN.txt

#echo "Running sandbox as `whoami` in `pwd`"

tmp_dir="$3"
chal_ins="$4"

# Test to ensure we are truly disconnected from the web:
if ping -i 0.5 -c 1 8.8.4.4 >/dev/null 2>&1
then
  echo '[ Integrity Breach ] The container is online!'
  exit 1
fi

cd ${tmp_dir}

# Remove all characters which are not a-zA-Z, then lowercase everything and trim whitespace
alpha_only() {
  echo "$1" | sed 's/[^[:alpha:]]\+//g' | tr '[:upper:]' '[:lower:]' | xargs | tr '\n' ' '
}

tests() {
  # Note: increase this number if we ever have more than 1k tests
  for i in $(seq 0 1000); do
    
    in_file="${chal_ins}$i.txt"
    their_out_file="${tmp_dir}$i.txt"
    if [[ ! -e "$in_file" ]]; then
      #echo "$in_file does not exist!"
      break;
    fi
    
    echo "[ Running Test $i ]"
    rm -f "$their_out_file"
    
    test $(tail -c 1 $in_file) && echo >> "$in_file" # Add a new line if one doesn't already exist
    echo | cat "$in_file" - | $@ > "$their_out_file" # 2>/dev/null
    echo "EXEC cat $their_out_file"
    cat "$their_out_file"
  done
}

case "$1" in
  java)
    class_name="${2%.*}"
    echo "[ Compiling java class ${class_name} in file $2 ]"
    javac "$2"
    if [[ ! -e "$class_name.class" ]]; then
      echo 'Java class file not found after compilation'
      exit 1
    fi
    javap_classname=$(javap $class_name | head -n 2 | tail -n 1 | sed 's/public class //g' | sed 's/ {//g')
    if [[ "$javap_classname" != "$class_name" ]]; then
      echo "[ Warning ] It looks like your java class is declared inside a package (javap reports $javap_classname, we think it is $class_name)"
    fi
    tests java "$class_name"
  ;;
    
  c)
    bin_name="${2%.*}"
    echo "[ Compiling c binary ${bin_name} in file $2 ]"
    gcc "$2" -o "$bin_name" || exit 1
    if [[ ! -e "$bin_name" ]]; then
      echo 'C binary not found after compilation'
      exit 1
    fi
    tests "./$bin_name"
  ;;
  
  python)
    tests python "$2"
  ;;
    
  *)
    echo "[ Language $1 not supported ]"
  ;;
esac
