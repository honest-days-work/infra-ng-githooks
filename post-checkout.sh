#!/bin/bash
c_red=`tput setaf 1`;
c_green=`tput setaf 2`;
c_bold=`tput bold`;
c_reset=`tput sgr0`;

echo -e "${c_bold}--- POST-CHECKOUT-HOOK ---${c_reset}"

BRANCH_NAME=$(git symbolic-ref --short -q HEAD)
NUM_CHECKOUTS=$(git reflog --date=local | grep -c ${BRANCH_NAME})

echo -en "\t- Increasing the version variable: Checkouts in this branch: $NUM_CHECKOUTS... "
final_out="version NOT changed"

if [[ "$1" == "$2" ]] && [[ "$3" == "1" ]] && [[ "$NUM_CHECKOUTS" == "1" ]]; then
  orig_version=$(grep -E 'repo_version[[:space:]]*=|module_version[[:space:]]*=' locals.tf  | cut -d '"' -f 2)
  new_version=`echo $orig_version| awk -F. -v OFS=. '{$NF += 1 ; print}' 2>/dev/null`
  if [[ $? -ne 0 ]]; then
    echo -e "${c_bold}${c_red}FAIL!!\n\t\tERROR:${c_reset} - ${new_version}"
    return 1
  fi
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    cmd_out=$(sed -i "s/${orig_version}/${new_version}/" locals.tf 2>&1)
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    cmd_out=$(sed -i '' -e "s/${orig_version}/${new_version}/" locals.tf 2>&1)
  fi
  if [[ $? -ne 0 ]]; then
    echo -e "${c_bold}${c_red}FAIL!!\n\t\tERROR:${c_reset} - ${cmd_out}"
    return 1
  fi
  final_out="version increased!"
fi

echo -e "${c_bold}${c_green}OK!! ${final_out}${c_reset}"
echo -e "${c_bold}--- POST-CHECKOUT-HOOK ---${c_reset}"
