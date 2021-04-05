#!/bin/bash

THIS_TERM="gtb-105"
STEP=0
BASE_URL="http://8.131.255.5"

echo -e "\nHi, Welcome to GTB ${THIS_TERM}.\n"

######## Full Name #######
STEP=$((STEP + 1))
echo -e "${STEP}. Please tell me your Name"

while :; do
  echo -e "> your Family Name (e.g. Zhao, Qian, Sun):"
  read -r FAMILY_NAME

  echo -e "> your Given Name (e.g. xiaoli, gousheng, xiaoshuan):"
  read -r GIVEN_NAME

  FULL_NAME=$(echo "${FAMILY_NAME}.${GIVEN_NAME}" | tr '[:upper:]' '[:lower:]')

  [ "$(curl -s -o /dev/null -w "%{http_code}" "${BASE_URL}/dashboard/api/terms/${THIS_TERM}/students?gtbUsername=${FULL_NAME}")" -eq "200" ] && break
  echo -e "<< ERROR >>: We cannot verify your name, Please try again or contact your coach:"
done
echo -e "\nGood job! Thank you ${FULL_NAME}.\n"

######## Sonarqube token #######
STEP=$((STEP + 1))
echo -e "${STEP}. Your sonarqube token is: (please go to ${BASE_URL}/sonarqube/account/security/ to generate one in case your don't have)"

while :; do
  read -r SONARQUBE_TOKEN
  [ "$(curl -s -o /dev/null -w "%{http_code}" -u "${SONARQUBE_TOKEN}": ${BASE_URL}/sonarqube/api/user_tokens/search)" -eq "200" ] && break
  echo -e "<< ERROR >>: We cannot verify this username with GTB sonarqube server, Please try again or contact your coach:"
done

######## Set up #######

echo -e "\nYour local environment is setting up, please wait..."
mkdir -p ~/.gradle && touch ~/.gradle/gradle.properties

grep -vq "systemProp.gtb" ~/.gradle/gradle.properties >tmp || mv tmp ~/.gradle/gradle.properties

{
  echo "systemProp.gtb.sonar.host.url=http://8.131.255.5/sonarqube/"
  echo "systemProp.gtb.sonar.login=${SONARQUBE_TOKEN}"
  echo "systemProp.gtb.sonar.student.term=${THIS_TERM}"
  echo "systemProp.gtb.sonar.student.name=${FULL_NAME}"
} >>~/.gradle/gradle.properties

echo -e "DONE."

