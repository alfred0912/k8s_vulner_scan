# Ref:
# https://gist.github.com/rverchere/6ea6b7f6f51e81cdab06660e83783387

#!/usr/bin/env bash
RED='\033[0;31m'
NC='\033[0m'

OLDIFS="$IFS"
IFS=$'\n'
VULN=$1

# Check command existence before using it
if ! command -v trivy &> /dev/null; then
  echo "trivy not found, please install it"
   exit
fi
if ! command -v kubectl &> /dev/null; then
  echo "trivy not found, please install it"
   exit
fi

# CVE-2021-44228
echo "Scanning $1..."

#List all images
imgs=`kubectl get pods --all-namespaces -o jsonpath='{range .items[*]}{.spec.containers[*].image}{" "}' | tr " " "\n" | sort -u`
for img in ${imgs}; do
  echo "scanning ${img}"
  result=`trivy image --severity CRITICAL ${img}`
  if echo ${result} | grep -q "$1" ; then
    echo -e "${RED}${img} is vulnerable, please patch!${NC}"
  fi
done

IFS="$OLDIFS"
