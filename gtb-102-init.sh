#!/bin/bash

THIS_TERM="102"
STEP=0

echo -e "\nHi, Welcome to GTB ${THIS_TERM}.\n"

######## GitHub username #######
STEP=$((STEP + 1))
echo -e "${STEP}. Please tell me your username on GitHub.com:"

while :; do
  read -r GITHUB_USERNAME
  [[ $(curl -s -o /dev/null -w "%{http_code}" "https://api.github.com/users/${GITHUB_USERNAME}") -eq "200" ]] && break
  echo -e "<< ERROR >>: We cannot verify this username with GitHub.com, Please try again or contact your coach:"
done
echo -e "\nGood job! Thank you ${GITHUB_USERNAME}.\n"

######## Sonarqube token #######
STEP=$((STEP + 1))
echo -e "${STEP}. Your sonarqube token is: (please go to http://8.131.255.5/sonarqube/account/security/ to generate one in case your don't have)"

while :; do
  read -r SONARQUBE_TOKEN
  [[ $(curl -s -o /dev/null -w "%{http_code}" -u "${SONARQUBE_TOKEN}": http://8.131.255.5/sonarqube/api/user_tokens/search) -eq "200" ]] && break
  echo -e "<< ERROR >>: We cannot verify this username with GTB sonarqube server, Please try again or contact your coach:"
done

######## Set up #######

echo -e "\nYour local environment is setting up, please wait..."
touch ~/.gradle/gradle.properties

grep -vq "systemProp.gtb" ~/.gradle/gradle.properties >tmp || mv tmp ~/.gradle/gradle.properties

{
  echo "systemProp.gtb.sonar.host.url=http://8.131.255.5/sonarqube/"
  echo "systemProp.gtb.sonar.login=${SONARQUBE_TOKEN}"
  echo "systemProp.gtb.sonar.student.term=GTB-${THIS_TERM}"
  echo "systemProp.gtb.sonar.student.name=${GITHUB_USERNAME}"
} >>~/.gradle/gradle.properties

echo -e "DONE."
