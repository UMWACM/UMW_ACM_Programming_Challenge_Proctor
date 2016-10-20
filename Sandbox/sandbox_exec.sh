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
if ping -i 0.5 -c 1 8.8.4.4 > /dev/null 2>&1
then
  echo '[ Integrity Breach ] The container is online!'
  exit 1
fi

# Remove all characters which are not a-zA-Z, then lowercase everything and trim whitespace
alpha_only() {
  echo "$1" | sed 's/[^[:alpha:]]\+//g' | tr '[:upper:]' '[:lower:]' | xargs | tr '\n' ' '
}

tests() {
  # Note: increase this number if we ever have more than 1k tests
  for i in $(seq 0 1000); do
    echo "[Debug] Sandbox test num $i"
    
    in_file="${chal_ins}$i.txt"
    their_out_file="${tmp_dir}$i.txt"
    if [[ ! -e "$in_file" ]]; then
      echo "$in_file does not exist!"
      break;
    fi
    
    rm -f "$their_out_file"
    cd ${tmp_dir}
    
    test $(tail -c 1 $in_file) && echo >> "$in_file" # Add a new line if one doesn't already exist
    $@ < "$in_file" > "$their_out_file" # 2>/dev/null
  done
}

case "$1" in
  java)
    echo "Java code"
    javac "$2"
    class_name="${2%.*}"
    if [[ ! -e "$class_name.class" ]]; then
      echo 'Java class file not found after compilation'
      exit 1
    fi
    tests java "$class_name"
  ;;
    
  c)
    echo "C code"
    bin_name="${2%.*}"
    gcc "$2" -o "$bin_name" || exit 1
    if [[ ! -e "$bin_name" ]]; then
      echo 'C binary not found after compilation'
      exit 1
    fi
    tests "./$bin_name"
  ;;
  
  python)
    echo "Python code at $2"
    cat "$2"
    tests python "$2"
  ;;
    
  *)
    echo "[ Language $1 not supported ]"
  ;;
esac
