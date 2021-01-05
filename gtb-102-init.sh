#!/bin/bash

THIS_TERM="102"

echo -e "\nHi, Welcome to GTB ${THIS_TERM}.\n"

echo -e "1. Please tell me your Last Name (Surname Name), e.g. Zhao, Qian, Sun, Li, Zhou, Wu, Zheng, Wang:"
read -r LAST_NAME

echo -e "2. And your First Name (Given Name) please, e.g. Xiangyun, Baochai, Xifeng, Tiezhu, Gousheng"
read -r FIRST_NAME

STUDENT_NAME="${FIRST_NAME}.${LAST_NAME}"

echo -e "\nGood job! Thank you ${STUDENT_NAME}.\n"
echo -e "3. Your sonarqube token is: (please go to http://8.131.255.5/sonarqube/account/security/ to generate token if your don't have)"

while :; do
  read -r SONARQUBE_TOKEN
  [[ ${SONARQUBE_TOKEN} =~ ^[a-z0-9]{40}$ ]] && break
  echo -e "<< ERROR >>: Your token should be 40 hexadecimals. Try again:"
done

echo -e "\nYour local environment is setting up, please wait..."
touch ~/.gradle/gradle.properties

grep -vq "systemProp.gtb" ~/.gradle/gradle.properties >tmp || mv tmp ~/.gradle/gradle.properties

{
  echo "systemProp.gtb.sonar.host.url=http://8.131.255.5/sonarqube/"
  echo "systemProp.gtb.sonar.login=${SONARQUBE_TOKEN}"
  echo "systemProp.gtb.sonar.student.term=GTB.${THIS_TERM}"
  echo "systemProp.gtb.sonar.student.name=${STUDENT_NAME}"
} >>~/.gradle/gradle.properties

echo -e "DONE."
